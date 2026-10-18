#!/usr/bin/env python3
"""Import a pinned, GPL-covered terrain bundle and its two search modules.

Run explicitly to refresh vendored files; normal builds and the addon stay offline.
"""
import concurrent.futures
import hashlib
import json
from pathlib import Path
import urllib.request
import xml.etree.ElementTree as ET

REVISION = "01559975bff0320a9fd2be496a774e20978aa807"
REPOSITORY = "https://github.com/cjber/shortest-path-forever"
ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / "plugins/routes/navigation/vendor"


def fetch(path):
    url = f"https://raw.githubusercontent.com/cjber/shortest-path-forever/{REVISION}/{path}"
    with urllib.request.urlopen(url, timeout=60) as response:
        return path, response.read()


def adapt(path, source):
    if path.endswith(".lua"):
        source = source.replace(b"ShortestPathForeverPathData", b"GatherLiteGroundPathData")
        if path.startswith("Routing/"):
            source = source.replace(b"local ns = select(2, ...)",
                b"local ns = select(2, ...).GroundNavigation")
        if path == "Routing/Path.lua":
            # Farming endpoints must not jump from an isolated ledge to a
            # nearby connected surface. Unsupported stops are omitted instead.
            source = source.replace(b"local RETRIES = 8", b"local RETRIES = 0")
    return source


def main():
    _, xml = fetch("Nav/Nav.xml")
    paths = ["Nav/" + element.attrib["file"] for element in ET.fromstring(xml)]
    paths += ["Routing/PathGrid.lua", "Routing/Path.lua", "LICENSE", "THIRD_PARTY.md"]
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as executor:
        sources = dict(executor.map(fetch, paths))
    sources["Nav/Nav.xml"] = xml
    manifest = {"repository": REPOSITORY, "revision": REVISION,
        "license": "GPL-3.0-or-later", "files": {}}
    for path, source in sorted(sources.items()):
        content = adapt(path, source)
        target = DESTINATION / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
        manifest["files"][path] = {"upstream_sha256": hashlib.sha256(source).hexdigest(),
            "vendored_sha256": hashlib.sha256(content).hexdigest()}
    (DESTINATION / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Vendored {len(sources)} files from {REVISION}; "
        f"{sum(len(source) for source in sources.values()):,} source bytes")


if __name__ == "__main__":
    main()
