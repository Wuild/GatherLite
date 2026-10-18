"""Offline checks for the pinned standalone navigation bundle and real terrain."""
import base64
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zlib

from vendor_navigation import DESTINATION, REVISION, adapt

ROOT = Path(__file__).resolve().parents[1]
NAV = DESTINATION / "Nav"
ENTRY = re.compile(r"data\.packed\.(\w+)\[(\d+)\] = \{([^\n}]+)\}")


def decode_map(map_id):
    fields = {name: {} for name in ("graph", "grid", "height", "floor")}
    for path in sorted(NAV.glob(f"Nav{map_id}_*.lua")):
        for name, index, blocks in ENTRY.findall(path.read_text()):
            decoded = []
            for block in json.loads("[" + blocks + "]"):
                raw = zlib.decompress(base64.b64decode(block, validate=True))
                if len(raw) > 16384:
                    raise ValueError("terrain block exceeds the frame-sized decoder limit")
                decoded.append(raw.decode("ascii"))
            fields[name][int(index)] = "".join(decoded)
    return fields


def write_fixture(destination, map_id=0):
    # Keep the real compressed load chain and lazy decoder. Python supplies
    # the game's Base64/zlib primitive; the Lua code still decodes on demand.
    paths = [NAV / f"Nav{map_id}.lua", *sorted(NAV.glob(f"Nav{map_id}_*.lua"))]
    decoded = {}
    for path in paths[1:]:
        for _, _, blocks in ENTRY.findall(path.read_text()):
            for block in json.loads("[" + blocks + "]"):
                decoded[block] = zlib.decompress(base64.b64decode(block)).decode("ascii")
    with Path(destination).open("w") as output:
        output.write("GatherLiteGroundPathData = nil\nlocal decoded={\n")
        for block, raw in decoded.items():
            output.write(f"[{json.dumps(block)}]={json.dumps(raw)},\n")
        output.write("}\nC_EncodingUtil={DecodeBase64=function(s) return s end,\n"
            "DecompressString=function(s) return assert(decoded[s]) end}\n")
        for path in paths:
            output.write(f"assert(loadfile({json.dumps(str(path.relative_to(ROOT)))}))()\n")


class NavigationTests(unittest.TestCase):
    def test_pinned_hashes_and_load_chain(self):
        manifest = json.loads((DESTINATION / "manifest.json").read_text())
        self.assertEqual(manifest["revision"], REVISION)
        self.assertEqual(manifest["license"], "GPL-3.0-or-later")
        for name, hashes in manifest["files"].items():
            with self.subTest(file=name):
                self.assertEqual(hashlib.sha256((DESTINATION / name).read_bytes()).hexdigest(),
                    hashes["vendored_sha256"])
        scripts = ET.fromstring((NAV / "Nav.xml").read_text())
        for script in scripts:
            self.assertIn("Nav/" + script.attrib["file"], manifest["files"])
        self.assertIn("GNU GENERAL PUBLIC LICENSE", (DESTINATION / "LICENSE").read_text())

    def test_all_compressed_terrain_and_counts(self):
        for map_id in (0, 1, 2991):
            fields = decode_map(map_id)
            header = (NAV / f"Nav{map_id}.lua").read_text()
            counts = re.search(r"counts = \{([^}]+)\}", header).group(1)
            for field, entries in fields.items():
                with self.subTest(map=map_id, field=field):
                    expected = int(re.search(rf"\b{field} = (\d+)", counts).group(1))
                    self.assertEqual(len(entries), expected)
                    self.assertTrue(all(re.fullmatch(r"[A-Za-z0-9+/]*", value)
                        for value in entries.values()))

    def test_import_disables_endpoint_relocation(self):
        result = adapt("Routing/Path.lua", b"local RETRIES = 8\nlocal ns = select(2, ...)")
        self.assertIn(b"local RETRIES = 0", result)
        self.assertIn(b".GroundNavigation", result)

    def test_real_elwynn_paths(self):
        lua = shutil.which("lua5.1") or shutil.which("luajit") or shutil.which("lua")
        if not lua:
            self.skipTest("Lua interpreter unavailable")
        with tempfile.TemporaryDirectory() as directory:
            fixture = Path(directory) / "terrain.lua"
            write_fixture(fixture)
            result = subprocess.run([lua, "tools/test_ground_routes.lua", str(fixture)],
                cwd=ROOT, capture_output=True, text=True, timeout=120)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn("Bundled Elwynn terrain passed:", result.stdout)


if __name__ == "__main__":
    unittest.main()
