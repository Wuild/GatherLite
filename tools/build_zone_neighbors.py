"""Build the checked-in Lua neighbor table from pinned client DB2 exports.

Offline developer tool only; the addon never enumerates maps or builds a graph.
"""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "tools/maps/forever-1.60.1.70009"
OUTPUT = ROOT / "scripts/maps/zone-neighbors.lua"


def load_inventory(source=SOURCE):
    manifest = json.loads((source / "manifest.json").read_text())
    tables = {}
    for filename, info in manifest["sources"].items():
        data = (source / filename).read_bytes()
        if hashlib.sha256(data).hexdigest() != info["sha256"]:
            raise ValueError("Source checksum mismatch: " + filename)
        tables[filename] = list(csv.DictReader(data.decode("utf-8-sig").splitlines()))
    maps = {int(row["ID"]): row for row in tables["UiMap.csv"]}
    if len(maps) != len(tables["UiMap.csv"]):
        raise ValueError("Duplicate UI map IDs")
    rectangles = {}
    for row in tables["UiMapAssignment.csv"]:
        map_id = int(row["UiMapID"])
        if map_id not in maps:
            raise ValueError("Assignment for unknown map: " + str(map_id))
        info = maps[map_id]
        if int(info["System"]) != 0 or int(info["Type"]) < 3:
            continue  # overview and taxi maps are catalogued but never neighbors
        if tuple(float(row[k]) for k in ("UiMin_0", "UiMin_1", "UiMax_0", "UiMax_1")) != (0, 0, 1, 1):
            raise ValueError("Partial map assignment needs review: " + str(map_id))
        if map_id in rectangles:
            raise ValueError("Multiple assignments need review: " + str(map_id))
        bounds = tuple(float(row[k]) for k in ("Region_0", "Region_1", "Region_3", "Region_4"))
        if not all(math.isfinite(v) for v in bounds) or bounds[0] >= bounds[2] or bounds[1] >= bounds[3]:
            raise ValueError("Invalid map rectangle: " + str(map_id))
        rectangles[map_id] = (int(row["MapID"]), *bounds)
    expected = {i for i, m in maps.items() if int(m["System"]) == 0 and int(m["Type"]) >= 3}
    if rectangles.keys() != expected:
        raise ValueError("Missing geometry: " + str(sorted(expected - rectangles.keys())))
    return manifest, maps, rectangles


def rectangle_gap(a, b):
    """Lower bound on distance between any two points in the map rectangles."""
    if a[0] != b[0]:
        return math.inf
    dx = max(0, a[1] - b[3], b[1] - a[3])
    dy = max(0, a[2] - b[4], b[2] - a[4])
    return math.hypot(dx, dy)


def build_neighbors(maps, rectangles, radius):
    if not math.isfinite(radius) or radius < 0:
        raise ValueError("Invalid neighbor radius")
    neighbors = {i: [] for i in maps}
    ids = sorted(rectangles)
    for n, first in enumerate(ids):
        for second in ids[n + 1:]:
            if rectangle_gap(rectangles[first], rectangles[second]) <= radius:
                neighbors[first].append(second)
                neighbors[second].append(first)
    return neighbors


def render(manifest, maps, neighbors):
    lines = [
        "-- Static UI map inventory and spatial neighbor candidates for WoW Forever.",
        "-- Generated offline by tools/build_zone_neighbors.py; no runtime generation.",
        "-- Sources and checksums: tools/maps/forever-" + manifest["build"] + "/manifest.json",
        "-- Neighbors overlap or lie within the maximum minimap range in the same world.",
        "-- These are conservative rectangle candidates, not road/travel connections.",
        "-- Overview/taxi maps are included for completeness with empty neighbor lists.",
        "local _, addon = ...",
        'addon.zoneTreeBuild = "' + manifest["build"] + '"',
        "addon.zoneTreeRange = " + str(manifest["max_range_yards"]),
        "addon.zoneTree = {",
    ]
    for map_id, info in sorted(maps.items()):
        name = json.dumps(info["Name_lang"], ensure_ascii=False)
        ids = ", ".join(map(str, neighbors[map_id]))
        lines.append(f'    [{map_id}] = {{ name = {name}, parent = {info["ParentUiMapID"]}, '
                     f'mapType = {info["Type"]}, system = {info["System"]}, neighbors = {{ {ids} }} }},')
    return "\n".join(lines + ["}", ""])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Fail if the static Lua table differs from the pinned client data")
    args = parser.parse_args()
    manifest, maps, rectangles = load_inventory()
    neighbors = build_neighbors(maps, rectangles, manifest["max_range_yards"])
    output = render(manifest, maps, neighbors)
    if args.check:
        if OUTPUT.read_text(encoding="utf-8") != output:
            raise SystemExit("Zone table differs from pinned sources; run tools/build_zone_neighbors.py")
    else:
        OUTPUT.write_text(output, encoding="utf-8")
    print(f'{len(maps)} UI maps; {len(rectangles)} zone/battleground rectangles; '
          f'{sum(map(len, neighbors.values())) // 2} reciprocal neighbor pairs; build {manifest["build"]}')


if __name__ == "__main__":
    main()
