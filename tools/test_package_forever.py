"""Release ZIP regressions: contents, version, load chain, and repeatability."""

from pathlib import Path
import json
import re
import tempfile
import unittest
import zipfile

from package_forever import build_package, prepare_package

REPOSITORY = Path(__file__).resolve().parents[1]
VERSION = "8.0.1"


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "source"
        self.output = Path(self.temp.name) / "output"
        self.write("LICENSE", "license")
        self.write("GatherLite.toc", "\n".join([
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

    def test_native_keybindings_ship(self):
        payload, _, _ = prepare_package(REPOSITORY, VERSION)
        self.assertIn("Bindings.xml", payload)
        self.assertIn(b"GatherLite:ToggleWindow()", payload["Bindings.xml"])

    def test_clean_versioned_repeatable_package(self):
        for junk in ("tools/update.py", ".wowhead-cache/page.html", ".github/workflow.yml",
                     ".git/config", "dist/old.zip", "GatherLite_Vanilla.toc",
                     "scripts/__pycache__/test.pyc", "scripts/.hidden.lua", ".env", ".env.example"):
            self.write(junk, "must not ship")
        archive, version, notes, count = build_package(self.root, self.output, VERSION)
        first_build = archive.read_bytes()
        self.assertEqual(version, VERSION)
        self.assertNotIn("Old notes", notes)
        with zipfile.ZipFile(archive) as bundle:
            names = set(bundle.namelist())
            self.assertEqual(count, 7)
            self.assertEqual(len(names), count)
            self.assertTrue(all(p.startswith("GatherLite/") for p in names))
            self.assertIn("GatherLite/icons/track_circle.tga", names)
            self.assertEqual([p for p in names if p.endswith(".toc")], ["GatherLite/GatherLite.toc"])
            toc = bundle.read("GatherLite/GatherLite.toc").decode()
            self.assertIn("## Version: " + VERSION, toc)
            self.assertNotIn("@project-version@", toc)
        build_package(self.root, self.output, VERSION)
        self.assertEqual(first_build, archive.read_bytes())
        self.assertTrue(archive.with_suffix(".zip.sha256").exists())

    def test_plain_release_and_existing_suffix_supported(self):
        for release in ("8.0.1", "8.0.2", "8.0.1-forever"):
            payload, version, _ = prepare_package(self.root, release)
            self.assertEqual(version, release)
            self.assertIn(f"## Version: {release}", payload["GatherLite.toc"].decode())
            self.assertIn("## Interface: 16001", payload["GatherLite.toc"].decode())

    def test_legacy_numbered_forever_version_supported(self):
        legacy = "8.0.0-forever.1"
        _, version, _, _ = build_package(self.root, self.output, legacy)
        self.assertEqual(version, legacy)

    def test_malformed_forever_suffix_rejected(self):
        for version in ("8.0", "08.0.1", "8.0.1-retail", "8.0.1-forever.", "8.0.1-forever.0", "8.0.1-forever-extra"):
            with self.subTest(version=version), self.assertRaisesRegex(ValueError, "Version must use"):
                build_package(self.root, self.output, version)

    def test_invalid_version_rejected(self):
        with self.assertRaisesRegex(ValueError, "Version must use"):
            prepare_package(self.root, "../../bad")

    def test_missing_xml_dependency_rejected(self):
        (self.root / "scripts/main.lua").unlink()
        with self.assertRaisesRegex(ValueError, "Missing packaged dependency: scripts/main.lua"):
            build_package(self.root, self.output, VERSION)

    def test_wrong_case_dependency_rejected(self):
        self.write("scripts/lib/load.xml", '<Ui><Script file="../Main.lua"/></Ui>')
        with self.assertRaisesRegex(ValueError, "Missing packaged dependency"):
            build_package(self.root, self.output, VERSION)

    def test_legacy_database_rejected(self):
        self.write("plugins/database/data/vanilla.lua", "-- old data")
        with self.assertRaisesRegex(ValueError, "only the Forever database"):
            build_package(self.root, self.output, VERSION)

    def test_wrong_client_rejected(self):
        toc = self.root / "GatherLite.toc"
        self.write(toc.name, toc.read_text().replace("16001", "11509"))
        with self.assertRaisesRegex(ValueError, "TOC Interface"):
            build_package(self.root, self.output, VERSION)

    def test_release_notes_are_optional_and_do_not_need_a_file(self):
        _, _, default_notes = prepare_package(self.root, VERSION)
        self.assertIn(VERSION, default_notes)
        _, _, notes = prepare_package(self.root, VERSION, "Custom release notes")
        self.assertEqual(notes, "Custom release notes")
        with self.assertRaisesRegex(ValueError, "must not be empty"):
            prepare_package(self.root, VERSION, " ")

    def rules(self, include=None, exclude=None):
        self.write("package-rules.json", json.dumps({
            "include": include if include is not None else ["GatherLite.toc", "LICENSE", "scripts/**/*", "plugins/**/*", "icons/**/*"],
            "exclude": exclude or []}))

    def test_include_extra_files_and_exclude_nested_files(self):
        self.write("docs/help.txt", "help")
        self.write("icons/unused.tga", "unused")
        self.write("icons/old/nested.tga", "old")
        self.rules(include=["GatherLite.toc", "LICENSE", "scripts/**/*", "plugins/**/*", "icons/**/*", "docs/*.txt"],
                   exclude=["icons/unused.tga", "icons/old"])
        payload, _, _ = prepare_package(self.root, VERSION)
        self.assertIn("docs/help.txt", payload)
        self.assertIn("icons/track_circle.tga", payload)
        self.assertNotIn("icons/unused.tga", payload)
        self.assertNotIn("icons/old/nested.tga", payload)

    def test_broad_rules_never_include_credentials_or_hidden_metadata(self):
        for name in (".env", ".env.production", ".git/config", "scripts/.env", "scripts/__pycache__/cache.pyc"):
            self.write(name, "private")
        self.rules(include=["**/*"])
        payload, _, _ = prepare_package(self.root, VERSION)
        self.assertFalse(any(".env" in p or ".git" in p or "__pycache__" in p for p in payload))

    def test_excluding_required_files_or_dependencies_fails(self):
        for name in ("GatherLite.toc", "LICENSE", "scripts/main.lua"):
            self.rules(exclude=[name])
            with self.subTest(name=name), self.assertRaisesRegex(ValueError, "Missing"):
                prepare_package(self.root, VERSION)

    def test_invalid_package_rules_fail(self):
        for rules in ('{', '{}', '{"include": "*", "exclude": []}',
                      '{"include": ["../outside"], "exclude": []}',
                      '{"include": ["C:/outside"], "exclude": []}'):
            self.write("package-rules.json", rules)
            with self.subTest(rules=rules), self.assertRaises(ValueError):
                prepare_package(self.root, VERSION)

    def test_catalog_icons_are_bundled(self):
        payload, _, _ = prepare_package(REPOSITORY, VERSION)
        catalog = payload["scripts/nodes.lua"].decode("utf-8")
        icons = re.findall(r'InsertObject\([^\n]+?, "[^"]+", "([^"]+)"', catalog)
        self.assertGreaterEqual(len(icons), 60)
        for icon in icons:
            self.assertFalse(icon.startswith("Interface"), icon)
            path = "icons/" + icon.replace("\\\\", "/")
            self.assertTrue(any(path + ext in payload for ext in (".tga", ".blp")), path)

    def test_actual_addon_packages_with_all_load_dependencies(self):
        archive, version, _, _ = build_package(REPOSITORY, self.output, VERSION)
        with zipfile.ZipFile(archive) as bundle:
            names = bundle.namelist()
            self.assertFalse(any("/tools/" in p or "/.wowhead-cache/" in p for p in names))
            self.assertIn("GatherLite/scripts/libraries/Ace3-LICENSE.txt", names)
            self.assertIn("GatherLite/plugins/database/data/forever.lua", names)
            self.assertIn("## Version: " + version, bundle.read("GatherLite/GatherLite.toc").decode())


if __name__ == "__main__":
    unittest.main()
