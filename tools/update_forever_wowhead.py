#!/usr/bin/env python3
"""Import Wowhead Forever map coordinates without executing page JavaScript.

Python 3.10+, standard library only. Updates merge into the Forever database.
"""
from __future__ import annotations

import argparse
import hashlib
from html.parser import HTMLParser
import json
import math
from pathlib import Path
import re
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.parse import unquote, urlparse
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "https://www.wowhead.com/forever/"
TABLES = {"mining": "Mining", "herbalism": "Herbalism", "containers": "Containers", "fishing": "Fishing"}
KINDS = {"ore": "mining", "herb": "herbalism", "container": "containers", "fishing": "fishing"}
GATHERING_LISTS = {"mineral-veins": -4, "herbs": -3}
# These entries in Wowhead's herb category are quest pickups, not Herbalism nodes.
QUEST_PICKUPS = {13891, 141853, 175207, 175566, 175928, 176189, 176753}


class ImportError(ValueError):
    """Invalid or unverified source data; leave generated files unchanged."""


class Page(HTMLParser):
    def __init__(self, html):
        super().__init__()
        self.canonical = None
        self.scripts = []
        self.script = None
        self.script_id = None
        self.json_scripts = {}
        self.feed(html)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "link" and attrs.get("rel") == "canonical":
            self.canonical = attrs.get("href")
        if tag == "script":
            self.script = []
            self.script_id = attrs.get("id")

    def handle_data(self, data):
        if self.script is not None:
            self.script.append(data)

    def handle_endtag(self, tag):
        if tag == "script" and self.script is not None:
            content = "".join(self.script)
            self.scripts.append(content)
            if self.script_id:
                self.json_scripts[self.script_id] = content
            self.script = None


def validate_url(url, object_id):
    parsed = urlparse(unquote(url or ""))
    if (parsed.scheme != "https" or parsed.netloc != "www.wowhead.com"
            or not re.fullmatch(rf"/forever/object={object_id}(?:/[^/]*)?", parsed.path)):
        raise ImportError(f"Expected Forever object {object_id}, got {url!r}")


def positive_int(value, label):
    if type(value) is not int or value <= 0:
        raise ImportError(f"Invalid {label}: {value!r}")
    return value


def parse_page(html, object_id, canonical_id, warnings=None):
    page = Page(html)
    validate_url(page.canonical, object_id)
    matches = []
    for script in page.scripts:
        marker = re.search(r"\b(?:var\s+)?g_mapperData\s*=\s*", script)
        if marker:
            try:
                matches.append(json.JSONDecoder().raw_decode(script[marker.end():])[0])
            except json.JSONDecodeError as exc:
                raise ImportError("Wowhead mapper is not valid JSON") from exc
    registered = any(re.search(rf'WH\.Gatherer\.addData\(2,\s*16,\s*\{{\s*"{object_id}"\s*:', script)
                     for script in page.scripts)
    if not matches and "The location of this object is unknown." in html and registered:
        if warnings is not None:
            warnings.append("Wowhead explicitly reports the object's location as unknown")
        return set()
    # Some dungeon objects list a zone but supply an explicitly empty mapper array.
    if len(matches) == 1 and matches[0] == [] and registered:
        if warnings is not None:
            warnings.append("Wowhead provides no map coordinates (empty mapper array)")
        return set()
    if len(matches) != 1 or not isinstance(matches[0], dict):
        raise ImportError("Expected one g_mapperData object; page may be blocked or its format changed")
    nodes = set()
    for area_id, layers in matches[0].items():
        if not isinstance(layers, list):
            raise ImportError(f"Invalid mapper layers for area {area_id}")
        for layer in layers:
            if not isinstance(layer, dict) or not isinstance(layer.get("coords"), list):
                raise ImportError(f"Missing coordinates for area {area_id}")
            if not layer["coords"]:
                continue
            # Wowhead uses [0, 0] without a UI map for an unlocated spawn
            # (for example, Small Thorium in Blackrock Spire). It is not a pin.
            if layer.get("uiMapId") is None and all(point == [0, 0] for point in layer["coords"]):
                if warnings is not None:
                    warnings.append(f"area {area_id}: skipped unlocated [0, 0] placeholder")
                continue
            # Wowhead's outer keys are area IDs, NOT the game's UI map IDs.
            map_id = positive_int(layer.get("uiMapId"), "uiMapId")
            for point in layer["coords"]:
                if not isinstance(point, list) or len(point) != 2:
                    raise ImportError(f"Invalid coordinate pair on map {map_id}")
                if any(type(v) not in (int, float) or not math.isfinite(v) or not 0 <= v <= 100 for v in point):
                    raise ImportError(f"Coordinate outside 0..100 on map {map_id}: {point!r}")
                # Integer millionths make deduplication deterministic.
                x, y = (round(v * 10000) for v in point)
                nodes.add((canonical_id, map_id, x, y))
    return nodes


def parse_listing(html, category):
    page = Page(html)
    url = SOURCE + "objects/" + category
    if page.canonical != url:
        raise ImportError(f"Expected Forever gathering listing {url}, got {page.canonical!r}")
    try:
        views = json.loads(page.json_scripts["data.page.listPage.listviews"])
    except (KeyError, json.JSONDecodeError) as exc:
        raise ImportError("Missing or invalid gathering listing JSON") from exc
    if not isinstance(views, list) or len(views) != 1 or not isinstance(views[0], dict):
        raise ImportError("Expected one gathering object listing")
    view = views[0]
    rows = view.get("data")
    if view.get("id") != "objects" or not isinstance(rows, list) or not rows:
        raise ImportError("Missing gathering object rows")
    if view.get("_truncated") or view.get("totalCount", len(rows)) != len(rows):
        raise ImportError("Gathering listing is truncated; refine discovery before importing")
    found = {}
    for row in rows:
        if not isinstance(row, dict) or row.get("type") != GATHERING_LISTS[category]:
            raise ImportError("Unexpected object type in gathering listing")
        object_id = positive_int(row.get("id"), "object ID")
        if object_id in found or not isinstance(row.get("name"), str) or not row["name"].strip():
            raise ImportError("Duplicate ID or missing gathering object name")
        skill = row.get("skill")
        if type(skill) is not int or skill < 0:
            raise ImportError("Invalid gathering skill requirement")
        found[object_id] = {"id": object_id, "name": row["name"], "skill": skill,
                            "category": category, "url": f"{SOURCE}object={object_id}"}
    return found


def discover_objects(catalog, cache, offline, refresh, delay, last_request):
    found = {}
    for category in GATHERING_LISTS:
        path = cache / f"{category}.html"
        if path.exists() and (offline or not refresh):
            html = path.read_text(encoding="utf-8-sig")
        else:
            if offline:
                raise ImportError(f"Missing cached listing: {path}")
            time.sleep(max(0, delay - (time.monotonic() - last_request[0])))
            url = SOURCE + "objects/" + category
            last_request[0] = time.monotonic()
            with urlopen(Request(url, headers={"User-Agent": "GatherLite-WowheadImporter/1.0"}), timeout=30) as response:
                if response.geturl() != url:
                    raise ImportError(f"Gathering listing redirected to {response.geturl()}")
                html = response.read().decode("utf-8-sig")
            parse_listing(html, category)
            cache.mkdir(parents=True, exist_ok=True)
            path.write_text(html, encoding="utf-8")
        rows = parse_listing(html, category)
        if found.keys() & rows.keys():
            raise ImportError("Object appears in multiple gathering categories")
        found.update(rows)
    excluded = [row for obj, row in sorted(found.items()) if obj in QUEST_PICKUPS]
    unmapped = [row for obj, row in sorted(found.items()) if obj not in catalog and obj not in QUEST_PICKUPS]
    for row in unmapped:
        print(f"NEW OBJECT needs catalog entry: {row['id']} {row['name']} ({row['category']}, skill {row['skill']})")
    print(f"Discovery: {len(found)} listed IDs, {len(unmapped)} unmapped, {len(excluded)} quest pickups excluded.")
    return set(found) & catalog.keys(), {"unmapped": unmapped, "excluded": excluded}


def read_catalog(path):
    catalog = {}
    for kind, ids in re.findall(r'InsertObject\("(\w+)",\s*\{([^}]+)\}', path.read_text(encoding="utf-8-sig")):
        if kind not in KINDS:
            raise ImportError(f"Unknown catalog kind: {kind}")
        aliases = [int(value) for value in re.findall(r"\d+", ids)]
        for object_id in aliases:
            catalog[object_id] = (KINDS[kind], aliases[0])
    if not catalog:
        raise ImportError("No objects found in scripts/nodes.lua")
    return catalog


def read_state(path, catalog):
    if not path.exists():
        return {"schema": 2, "source": SOURCE, "objects": {}, "nodes": {}}
    state = json.loads(path.read_text(encoding="utf-8"))
    if (not isinstance(state, dict) or state.get("schema") != 2 or state.get("source") != SOURCE
            or not isinstance(state.get("objects"), dict) or not isinstance(state.get("nodes"), dict)):
        raise ImportError("Unrecognized Forever import state")
    if any(not key.isdecimal() or int(key) not in catalog for key in state["objects"]):
        raise ImportError("Saved source object is not in the node catalog")
    for obj, maps in state["nodes"].items():
        if not obj.isdecimal() or int(obj) not in catalog or catalog[int(obj)][1] != int(obj):
            raise ImportError("Saved object is not canonical or not in the node catalog")
        if not isinstance(maps, dict):
            raise ImportError("Invalid saved map groups")
        for map_id, coords in maps.items():
            if not map_id.isdecimal() or int(map_id) <= 0:
                raise ImportError("Invalid saved map ID")
            if not isinstance(coords, list) or len(coords) % 2:
                raise ImportError("Expected flat x/y coordinate pairs")
            if any(type(v) is not int or not 0 <= v <= 1000000 for v in coords):
                raise ImportError("Invalid saved position")
    return state


def unpack_nodes(groups):
    return {(int(obj), int(map_id), coords[i], coords[i + 1])
            for obj, maps in groups.items() for map_id, coords in maps.items()
            for i in range(0, len(coords), 2)}


def group_nodes(nodes):
    groups = {}
    for obj, map_id, x, y in sorted(nodes):
        groups.setdefault(str(obj), {}).setdefault(str(map_id), []).extend([x, y])
    return groups


def render_lua(nodes):
    lines = [
        "-- Generated by tools/update_forever_wowhead.py. Do not edit by hand.",
        "-- [objectID][uiMapID] = { x, y, ... }; normalized coordinates.",
        "local _, addon = ...",
        "addon.predefined = {",
    ]
    for obj, maps in group_nodes(nodes).items():
        lines.append(f"    [{obj}] = {{")
        for map_id, coords in maps.items():
            lines.append(f"        [{map_id}] = {{")
            for offset in range(0, len(coords), 12):
                values = [f"{v / 1000000:.6f}".rstrip("0").rstrip(".") for v in coords[offset:offset + 12]]
                lines.append("            " + ", ".join(values) + ",")
            lines.append("        },")
        lines.append("    },")
    lines.append("}")
    return "\n".join(lines) + "\n"


def fetch_page(object_id, cache, offline, refresh, delay, last_request):
    path = cache / f"{object_id}.html"
    if path.exists() and (offline or not refresh):
        return path.read_text(encoding="utf-8-sig")
    if offline:
        raise ImportError(f"Missing cached page: {path}")
    time.sleep(max(0, delay - (time.monotonic() - last_request[0])))
    url = f"{SOURCE}object={object_id}"
    request = Request(url, headers={"User-Agent": "GatherLite-WowheadImporter/1.0", "Accept": "text/html"})
    last_request[0] = time.monotonic()
    with urlopen(request, timeout=30) as response:
        validate_url(response.geturl(), object_id)
        html = response.read().decode("utf-8-sig")
    # Validate before caching, including challenge pages returned with HTTP 200.
    page = Page(html)
    validate_url(page.canonical, object_id)
    cache.mkdir(parents=True, exist_ok=True)
    path.write_text(html, encoding="utf-8")
    return html


def atomic_write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(content, encoding="utf-8", newline="\n")
    temporary.replace(path)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--objects", nargs="+", type=int, help="Only fetch these IDs; default: previously imported IDs, or all catalog IDs for a new database")
    parser.add_argument("--cache-dir", type=Path, default=ROOT / ".wowhead-cache/forever")
    parser.add_argument("--offline", action="store_true", help="Only read saved <objectID>.html pages")
    parser.add_argument("--refresh", action="store_true", help="Re-download cached pages")
    parser.add_argument("--discover", action="store_true", help="Check complete mining/herb listings, import known IDs, report new unmapped IDs")
    parser.add_argument("--delay", type=float, default=2, help="Seconds between requests (minimum 1)")
    parser.add_argument("--state", type=Path, default=ROOT / "tools/wowhead/forever.json")
    parser.add_argument("--output", type=Path, default=ROOT / "plugins/database/data/forever.lua")
    parser.add_argument("--dry-run", action="store_true", help="Fetch/validate and report without changing state or Lua")
    parser.add_argument("--generate-only", action="store_true", help="Regenerate Lua from committed state; no cached pages or network required")
    args = parser.parse_args(argv)
    if not math.isfinite(args.delay) or args.delay < 1:
        parser.error("--delay must be at least 1 second")
    if args.offline and args.refresh:
        parser.error("--offline and --refresh cannot be combined")
    if args.generate_only and (args.objects or args.refresh or args.discover):
        parser.error("--generate-only cannot be combined with --objects, --refresh or --discover")
    if args.discover and args.objects:
        parser.error("--discover cannot be combined with --objects")
    if args.output.resolve() == args.state.resolve():
        parser.error("--output and --state must be different paths")
    protected = {ROOT / "scripts/nodes.lua"}
    if args.output.resolve() in protected or args.state.resolve() in protected:
        parser.error("Output paths must not overwrite the node catalog")
    try:
        catalog = read_catalog(ROOT / "scripts/nodes.lua")
        if args.generate_only and not args.state.exists():
            raise ImportError("--generate-only requires an existing import state")
        state = read_state(args.state, catalog)
        nodes = unpack_nodes(state["nodes"])
        before = len(nodes)
        objects = sorted(set(args.objects) if args.objects else
                         {int(key) for key in state["objects"]} or set(catalog))
        if args.generate_only:
            objects = []
        unknown = set(objects) - catalog.keys()
        if unknown:
            raise ImportError(f"Add unknown objects to scripts/nodes.lua and locales first: {sorted(unknown)}")
        last_request = [0.0]
        if args.discover:
            discovered, state["discovery"] = discover_objects(
                catalog, args.cache_dir, args.offline, args.refresh, args.delay, last_request)
            objects = sorted(set(objects) | discovered)
        for index, object_id in enumerate(objects, 1):
            kind, canonical_id = catalog[object_id]
            html = fetch_page(object_id, args.cache_dir, args.offline, args.refresh, args.delay, last_request)
            warnings = []
            imported = parse_page(html, object_id, canonical_id, warnings)
            nodes.update(imported)
            state["objects"][str(object_id)] = {
                "url": f"{SOURCE}object={object_id}",
                "sha256": hashlib.sha256(html.encode("utf-8")).hexdigest(),
                "coordinates": len(imported),
                "warnings": warnings,
            }
            print(f"[{index}/{len(objects)}] {object_id}: {len(imported)} unique coordinates", flush=True)
            for warning in warnings:
                print(f"  {warning}", flush=True)
        state["nodes"] = group_nodes(nodes)
        lua = render_lua(nodes)
        print(f"Forever database: {len(nodes)} unique nodes ({len(nodes) - before:+d}).")
        if not args.dry_run:
            # Complete all fetches/validation before touching either output. The
            # state is authoritative; rerunning can always regenerate the Lua.
            atomic_write(args.state, json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
            atomic_write(args.output, lua)
            print(f"Wrote {args.output}")
        return 0
    except (ImportError, OSError, HTTPError, URLError, json.JSONDecodeError) as exc:
        print(f"Import stopped: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
