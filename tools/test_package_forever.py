"""Release ZIP regressions: contents, version, load chain, and repeatability."""

from pathlib import Path
import tempfile
import unittest
import zipfile

from package_forever import build_package

REPOSITORY = Path(__file__).resolve().parents[1]
VERSION = "8.0.0-forever.1"


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "source"
        self.output = Path(self.temp.name) / "output"
        self.write("VERSION", VERSION)
        self.write("LICENSE", "license")
        self.write("CHANGELOG.md", f"### Changes\n\n#### {VERSION} — test\n\nRelease notes.\n\n#### 7.7.0\nOld notes.")
        self.write("GatherLite_Camelot.toc", "\n".join([
            "## Title: GatherLite", "## Interface: 16001", "## Version: @project-version@",
            "## X-Curse-Project-ID: 334918", "scripts\\embeds.xml",
            "plugins\\database\\data\\forever.lua"]))
        self.write("scripts/embeds.xml", '<Ui><Include file="lib/load.xml"/></Ui>')
        self.write("scripts/lib/load.xml", '<Ui><Script file="../main.lua"/></Ui>')
        self.write("scripts/main.lua", "-- runtime")
        self.write("plugins/database/data/forever.lua", "-- data")
        self.write("icons/track_circle.tga", "fixture")

    def write(self, path, text):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text, encoding="utf-8")

    def test_clean_versioned_repeatable_package(self):
        for junk in ("tools/update.py", ".wowhead-cache/page.html", ".github/workflow.yml",
                     ".git/config", "dist/old.zip", "GatherLite_Vanilla.toc",
                     "scripts/__pycache__/test.pyc", "scripts/.hidden.lua"):
            self.write(junk, "must not ship")
        archive, version, notes, count = build_package(self.root, self.output, VERSION)
        first_build = archive.read_bytes()
        self.assertEqual(version, VERSION)
        self.assertNotIn("Old notes", notes)
        with zipfile.ZipFile(archive) as bundle:
            names = set(bundle.namelist())
            self.assertEqual(count, 8)
            self.assertEqual(len(names), count)
            self.assertTrue(all(p.startswith("GatherLite/") for p in names))
            self.assertIn("GatherLite/icons/track_circle.tga", names)
            self.assertEqual([p for p in names if p.endswith(".toc")], ["GatherLite/GatherLite_Camelot.toc"])
            toc = bundle.read("GatherLite/GatherLite_Camelot.toc").decode()
            self.assertIn("## Version: " + VERSION, toc)
            self.assertNotIn("@project-version@", toc)
        build_package(self.root, self.output)
        self.assertEqual(first_build, archive.read_bytes())
        self.assertTrue(archive.with_suffix(".zip.sha256").exists())

    def test_mismatched_release_tag_rejected(self):
        with self.assertRaisesRegex(ValueError, "does not match"):
            build_package(self.root, self.output, "7.7.0")
        self.assertFalse(self.output.exists())

    def test_invalid_version_rejected(self):
        self.write("VERSION", "../../bad")
        with self.assertRaisesRegex(ValueError, "VERSION must use"):
            build_package(self.root, self.output)

    def test_missing_xml_dependency_rejected(self):
        (self.root / "scripts/main.lua").unlink()
        with self.assertRaisesRegex(ValueError, "Missing packaged dependency: scripts/main.lua"):
            build_package(self.root, self.output)

    def test_wrong_case_dependency_rejected(self):
        self.write("scripts/lib/load.xml", '<Ui><Script file="../Main.lua"/></Ui>')
        with self.assertRaisesRegex(ValueError, "Missing packaged dependency"):
            build_package(self.root, self.output)

    def test_legacy_database_rejected(self):
        self.write("plugins/database/data/vanilla.lua", "-- old data")
        with self.assertRaisesRegex(ValueError, "only the Forever database"):
            build_package(self.root, self.output)

    def test_wrong_client_rejected(self):
        toc = self.root / "GatherLite_Camelot.toc"
        self.write(toc.name, toc.read_text().replace("16001", "11509"))
        with self.assertRaisesRegex(ValueError, "TOC Interface"):
            build_package(self.root, self.output)

    def test_missing_release_notes_rejected(self):
        self.write("CHANGELOG.md", "#### Unreleased\nNot ready.")
        with self.assertRaisesRegex(ValueError, "Missing changelog section"):
            build_package(self.root, self.output)

    def test_actual_addon_packages_with_all_load_dependencies(self):
        archive, version, _, _ = build_package(REPOSITORY, self.output)
        with zipfile.ZipFile(archive) as bundle:
            names = bundle.namelist()
            self.assertFalse(any("/tools/" in p or "/.wowhead-cache/" in p for p in names))
            self.assertIn("GatherLite/scripts/libraries/Ace3-LICENSE.txt", names)
            self.assertIn("GatherLite/plugins/database/data/forever.lua", names)
            self.assertIn("## Version: " + version, bundle.read("GatherLite/GatherLite_Camelot.toc").decode())


if __name__ == "__main__":
    unittest.main()
