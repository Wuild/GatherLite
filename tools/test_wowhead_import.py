"""Offline importer tests: python -m unittest discover -s tools -p 'test_*.py'."""
import json
import io
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import update_forever_wowhead as importer


def page(data, url="https://www.wowhead.com/forever/object=1731/copper-vein"):
    return (f'<link rel="canonical" href="{url}">'
            f'<script>var g_mapperData = {json.dumps(data)}; doNotExecute();</script>')


class ParserTests(unittest.TestCase):
    def parse(self, data):
        return importer.parse_page(page(data), 1731, 1731)

    def test_ui_map_not_area_id_and_duplicate_coordinates(self):
        nodes = self.parse({"12": [{"uiMapId": 1429, "coords": [[20.9, 51.4], [20.9, 51.4]]}]})
        self.assertEqual(nodes, {(1731, 1429, 209000, 514000)})

    def test_layers_and_coordinate_edges(self):
        nodes = self.parse({"12": [{"uiMapId": 1429, "coords": [[0, 100]]},
                                   {"uiMapId": 9999, "coords": [[100, 0]]}]})
        self.assertEqual(len(nodes), 2)
        self.assertIn((1731, 9999, 1000000, 0), nodes)

    def test_explicit_empty_data(self):
        self.assertEqual(self.parse({}), set())

    def test_explicit_unknown_location_is_reported(self):
        html = ('<link rel="canonical" href="https://www.wowhead.com/forever/object=1731">'
                'The location of this object is unknown.'
                '<script>WH.Gatherer.addData(2, 16, {"1731": {"name_enus": "Copper Vein"}});</script>')
        warnings = []
        self.assertEqual(importer.parse_page(html, 1731, 1731, warnings), set())
        self.assertEqual(len(warnings), 1)
        with self.assertRaises(importer.ImportError):
            importer.parse_page(html.replace('addData(2, 16', 'addData(2, 4'), 1731, 1731)

    def test_no_mapper_and_invalid_json_fail(self):
        for html in [page({}).replace("g_mapperData", "somethingElse"),
                     page({}).replace("= {}", "= {bad}"), "captcha challenge"]:
            with self.subTest(html=html), self.assertRaises(importer.ImportError):
                importer.parse_page(html, 1731, 1731)

    def test_empty_mapper_array_requires_forever_object_registration(self):
        html = page([])
        with self.assertRaises(importer.ImportError):
            importer.parse_page(html, 1731, 1731)
        html += '<script>WH.Gatherer.addData(2, 16, {"1731": {}});</script>'
        warnings = []
        self.assertEqual(importer.parse_page(html, 1731, 1731, warnings), set())
        self.assertIn("empty mapper array", warnings[0])
        with self.assertRaises(importer.ImportError):
            importer.parse_page(html.replace('= []', '= [1]'), 1731, 1731)

    def test_retail_classic_wrong_object_and_host_rejected(self):
        for url in ["https://www.wowhead.com/classic/object=1731",
                    "https://www.wowhead.com/object=1731",
                    "https://www.wowhead.com/forever/object=1732",
                    "https://example.com/forever/object=1731"]:
            with self.subTest(url=url), self.assertRaises(importer.ImportError):
                importer.parse_page(page({}, url), 1731, 1731)

    def test_bad_positions_fail(self):
        for coords in [[[101, 20]], [[-1, 0]], [[None, 0]], [[True, 0]],
                       [[float("nan"), 0]], [[1]], [[1, 2, 3]], ["1,2"]]:
            with self.subTest(coords=coords), self.assertRaises(importer.ImportError):
                self.parse({"12": [{"uiMapId": 1429, "coords": coords}]})

    def test_missing_map_fails_except_reported_placeholder(self):
        with self.assertRaises(importer.ImportError):
            self.parse({"12": [{"coords": [[50, 50]]}]})
        warnings = []
        nodes = importer.parse_page(page({"1583": [{"coords": [[0, 0]]}]}), 1731, 1731, warnings)
        self.assertEqual(nodes, set())
        self.assertEqual(len(warnings), 1)

    def test_non_integer_maps_fail(self):
        for map_id in [True, 0, -1, "1429", 1.2]:
            with self.subTest(map_id=map_id), self.assertRaises(importer.ImportError):
                self.parse({"12": [{"uiMapId": map_id, "coords": [[50, 50]]}]})

    def test_render_is_deterministic_and_only_coordinates(self):
        a = (1731, 1429, 500000, 400000)
        b = (1617, 1429, 200000, 300000)
        self.assertEqual(importer.render_lua([a, b]), importer.render_lua([b, a]))
        self.assertNotIn("predefined = true", importer.render_lua([a]))
        self.assertNotIn("loot", importer.render_lua([a]))
        self.assertIn("[1731] = {", importer.render_lua([a]))
        self.assertIn("0.5, 0.4", importer.render_lua([a]))

    def test_forever_catalog_and_group_roundtrip(self):
        catalog = importer.read_catalog(importer.ROOT / "scripts/nodes.lua")
        self.assertEqual(catalog[2055], ("mining", 1731))
        self.assertNotIn(181555, catalog)  # Fel Iron
        nodes = {(1731, 1429, 500000, 400000), (1617, 1429, 200000, 300000)}
        self.assertEqual(importer.unpack_nodes(importer.group_nodes(nodes)), nodes)


def listing(rows, category="mineral-veins", **metadata):
    view = {"id": "objects", "data": rows, **metadata}
    return (f'<link rel="canonical" href="{importer.SOURCE}objects/{category}">'
            f'<script type="application/json" id="data.page.listPage.listviews">{json.dumps([view])}</script>')


class DiscoveryTests(unittest.TestCase):
    def setUp(self):
        self.ore = {"id": 439558, "name": "Cold Iron Deposit", "skill": 125, "type": -4}
        self.herb = {"id": 439557, "name": "Nightmare Moss", "skill": 125, "type": -3}

    def test_listing_ids_names_and_skill(self):
        rows = importer.parse_listing(listing([self.ore]), "mineral-veins")
        self.assertEqual(rows[439558]["skill"], 125)
        self.assertEqual(rows[439558]["name"], "Cold Iron Deposit")

    def test_wrong_client_truncated_and_missing_listing_rejected(self):
        for html in [listing([self.ore]).replace("/forever/", "/classic/"),
                     listing([self.ore], _truncated=True), listing([self.ore], totalCount=2),
                     listing([]), "challenge page"]:
            with self.subTest(html=html), self.assertRaises(importer.ImportError):
                importer.parse_listing(html, "mineral-veins")

    def test_malformed_objects_rejected(self):
        for rows in [[self.ore, self.ore], [self.herb], [{**self.ore, "id": True}],
                     [{**self.ore, "skill": None}], [{**self.ore, "name": ""}]]:
            with self.subTest(rows=rows), self.assertRaises(importer.ImportError):
                importer.parse_listing(listing(rows), "mineral-veins")

    def test_offline_discovery_reports_new_ids_and_excludes_quest_pickups(self):
        with tempfile.TemporaryDirectory() as folder:
            cache = Path(folder)
            (cache / "mineral-veins.html").write_text(listing([self.ore]))
            quest = {"id": 176753, "name": "Doom Weed", "skill": 1, "type": -3}
            (cache / "herbs.html").write_text(listing([self.herb, quest], "herbs"))
            catalog = {439558: ("mining", 439558)}
            with patch.object(importer, "urlopen", side_effect=AssertionError("network called")):
                with patch("sys.stdout", new_callable=io.StringIO):
                    ids, report = importer.discover_objects(catalog, cache, True, False, 2, [0])
            self.assertEqual(ids, {439558})
            self.assertEqual([r["id"] for r in report["unmapped"]], [439557])
            self.assertEqual([r["id"] for r in report["excluded"]], [176753])


class CommandTests(unittest.TestCase):
    def setUp(self):
        for stream in ("sys.stdout", "sys.stderr"):
            replacement = patch(stream, new_callable=io.StringIO)
            replacement.start()
            self.addCleanup(replacement.stop)
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.state, self.output = self.root / "state.json", self.root / "forever.lua"
        self.args = ["--objects", "1731", "--offline", "--cache-dir", str(self.root),
                     "--state", str(self.state), "--output", str(self.output)]
        self.html = self.root / "1731.html"
        self.html.write_text(page({"12": [{"uiMapId": 1429, "coords": [[12.3456, 65.4321]]}]}), encoding="utf-8")

    def test_offline_import_is_additive_and_repeatable(self):
        self.assertEqual(importer.main(self.args), 0)
        first_lua, first_state = self.output.read_bytes(), self.state.read_bytes()
        self.assertEqual(importer.main(self.args), 0)
        self.assertEqual(first_lua, self.output.read_bytes())
        self.assertEqual(first_state, self.state.read_bytes())
        self.html.write_text(page({}), encoding="utf-8")
        self.assertEqual(importer.main(self.args), 0)
        self.assertEqual(first_lua, self.output.read_bytes(), "empty source cannot erase previous locations")

    def test_dry_run_does_not_write(self):
        self.assertEqual(importer.main(self.args + ["--dry-run"]), 0)
        self.assertFalse(self.state.exists())
        self.assertFalse(self.output.exists())

    def test_failure_keeps_both_outputs(self):
        self.assertEqual(importer.main(self.args), 0)
        before = (self.output.read_bytes(), self.state.read_bytes())
        self.html.write_text("challenge page", encoding="utf-8")
        self.assertEqual(importer.main(self.args), 1)
        self.assertEqual(before, (self.output.read_bytes(), self.state.read_bytes()))

    def test_later_failure_does_not_publish_partial_run(self):
        with patch.object(importer, "fetch_page", side_effect=[self.html.read_text(), importer.ImportError("later fetch failed")]):
            self.assertEqual(importer.main(self.args + ["--objects", "1731", "1732"]), 1)
        self.assertFalse(self.output.exists())
        self.assertFalse(self.state.exists())

    def test_discovery_imports_new_known_ids_and_preserves_report(self):
        self.assertEqual(importer.main(self.args), 0)
        args = ["--discover", "--offline", "--state", str(self.state), "--output", str(self.output)]
        report = {"unmapped": [{"id": 999999, "name": "Future Vein"}], "excluded": []}
        with patch.object(importer, "discover_objects", return_value=({439558}, report)):
            with patch.object(importer, "fetch_page", side_effect=lambda obj, *a: page({}, f"{importer.SOURCE}object={obj}")) as fetch:
                self.assertEqual(importer.main(args), 0)
        self.assertIn(439558, {call.args[0] for call in fetch.call_args_list})
        self.assertEqual({call.args[0] for call in fetch.call_args_list}, {1731, 439558})
        self.assertEqual(json.loads(self.state.read_text())["discovery"], report)

    def test_missing_offline_cache_does_not_fetch(self):
        with patch.object(importer, "urlopen", side_effect=AssertionError("network called")):
            self.assertEqual(importer.main(self.args + ["--objects", "1732"]), 1)

    def test_malformed_state_does_not_write(self):
        for state in [[], {"schema": 2, "source": importer.SOURCE, "objects": {}, "nodes": None}]:
            self.state.write_text(json.dumps(state), encoding="utf-8")
            self.assertEqual(importer.main(self.args), 1)
            self.assertFalse(self.output.exists())

    def test_catalog_output_is_rejected(self):
        with self.assertRaises(SystemExit):
            importer.main(self.args + ["--output", str(importer.ROOT / "scripts/nodes.lua")])

    def test_generate_only_needs_no_cached_pages(self):
        self.assertEqual(importer.main(self.args), 0)
        before = self.output.read_bytes()
        self.html.unlink()
        args = ["--state", str(self.state), "--output", str(self.output), "--generate-only"]
        with patch.object(importer, "fetch_page", side_effect=AssertionError("page access")):
            self.assertEqual(importer.main(args), 0)
        self.assertEqual(before, self.output.read_bytes())

    def test_grouped_state_validation(self):
        catalog = importer.read_catalog(importer.ROOT / "scripts/nodes.lua")
        for nodes in [{"1731": {"1429": [500000]}}, {"1731": {"1429": [1000001, 0]}},
                      {"1731": {"0": [0, 0]}}, {"2055": {"1429": [0, 0]}},
                      {"99999999": {"1429": [0, 0]}}]:
            self.state.write_text(json.dumps({"schema": 2, "source": importer.SOURCE,
                                              "objects": {}, "nodes": nodes}), encoding="utf-8")
            with self.assertRaises(importer.ImportError):
                importer.read_state(self.state, catalog)

    def test_committed_database_matches_state(self):
        catalog = importer.read_catalog(importer.ROOT / "scripts/nodes.lua")
        state = importer.read_state(importer.ROOT / "tools/wowhead/forever.json", catalog)
        nodes = importer.unpack_nodes(state["nodes"])
        self.assertGreaterEqual(len(nodes), 25000)
        self.assertEqual(importer.render_lua(nodes), (importer.ROOT / "plugins/database/data/forever.lua").read_text())


if __name__ == "__main__":
    unittest.main()
