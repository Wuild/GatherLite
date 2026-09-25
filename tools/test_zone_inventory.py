"""Audit the static runtime list against the complete, pinned client inventory."""
import math
import re
import unittest
from pathlib import Path

from build_zone_neighbors import ROOT, OUTPUT, load_inventory, build_neighbors, rectangle_gap, render


class ZoneInventoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest, cls.maps, cls.rectangles = load_inventory()
        cls.neighbors = build_neighbors(cls.maps, cls.rectangles, 1000)

    def test_exact_runtime_artifact(self):
        self.assertEqual(OUTPUT.read_text(encoding="utf-8"), render(self.manifest, self.maps, self.neighbors))

    def test_all_client_ui_maps_classified(self):
        self.assertEqual(len(self.maps), 60)
        zones = [m for m in self.maps.values() if m['System'] == '0' and m['Type'] == '3']
        battlegrounds = [m for m in self.maps.values() if m['System'] == '0' and m['Type'] == '6']
        self.assertEqual(len(zones), 50)
        self.assertEqual(len(battlegrounds), 4)
        self.assertEqual(len(self.rectangles), 54)
        self.assertEqual(set(self.maps) - set(self.rectangles), {947, 1414, 1415, 1463, 1464, 2665})
        for i in set(self.maps) - set(self.rectangles):
            self.assertEqual(self.neighbors[i], [])

    def test_reciprocal_same_world_links(self):
        for first, linked in self.neighbors.items():
            self.assertEqual(linked, sorted(set(linked)))
            self.assertNotIn(first, linked)
            for second in linked:
                self.assertIn(first, self.neighbors[second])
                self.assertEqual(self.rectangles[first][0], self.rectangles[second][0])
        for i in (1459, 1460, 1461, 2521, 2524):
            self.assertEqual(self.neighbors[i], [], 'isolated world should not link transport destinations')

    def test_rectangle_distance_boundary(self):
        origin = (0, 0, 0, 100, 100)
        self.assertEqual(rectangle_gap(origin, (0, 50, 50, 150, 150)), 0)
        self.assertEqual(rectangle_gap(origin, (0, 100, 0, 200, 100)), 0)
        self.assertEqual(rectangle_gap(origin, (0, 700, 900, 800, 1000)), 1000)
        self.assertTrue(math.isinf(rectangle_gap(origin, (1, 0, 0, 100, 100))))
        rects = {1: origin, 2: (0, 700, 900, 800, 1000), 3: (0, 701, 900, 801, 1000)}
        neighbors = build_neighbors(dict.fromkeys(rects), rects, 1000)
        self.assertIn(2, neighbors[1])
        self.assertNotIn(3, neighbors[1])

    def test_every_sampled_nearby_point_has_a_candidate_link(self):
        # Independent point-distance oracle: sample each rectangle's corners,
        # edge midpoints and center, including across the 1000-yard range.
        points = {}
        for i, (_, x0, y0, x1, y1) in self.rectangles.items():
            points[i] = [(x, y) for x in (x0, (x0+x1)/2, x1) for y in (y0, (y0+y1)/2, y1)]
        for a in points:
            for b in points:
                if a >= b or self.rectangles[a][0] != self.rectangles[b][0]:
                    continue
                if any(math.hypot(x-u, y-v) <= 1000 for x, y in points[a] for u, v in points[b]):
                    self.assertIn(b, self.neighbors[a], f'missing candidate {a} / {b}')

    def test_existing_sources_are_covered(self):
        text = (ROOT / 'scripts/maps/reveal-data.lua').read_text()
        for i in re.findall(r'^    -- (\d+):', text, re.M):
            self.assertIn(int(i), self.maps)

    def test_range_setting_does_not_outgrow_table(self):
        settings = (ROOT / 'scripts/settings.lua').read_text()
        block = settings.split('nodeRange = {', 1)[1].split('iconSize = {', 1)[0]
        maximum = int(re.search(r'max = (\d+)', block).group(1))
        self.assertLessEqual(maximum, self.manifest['max_range_yards'])


if __name__ == '__main__':
    unittest.main()
