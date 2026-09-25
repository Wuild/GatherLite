# Zone neighbor audit

The checked-in `scripts/maps/zone-neighbors.lua` contains **every one of the 60
UI map IDs in Forever build 1.60.1.70009**. This is completeness against a specific
client build, not a claim about future versions or every named area in Azeroth.

| Map category | Entries | Neighbor behavior |
| --- | ---: | --- |
| Outdoor zones and cities | 50 | Same-world spatial candidates within 1,000 yards |
| Battlegrounds | 4 | Empty: each is in its own world instance |
| World/continent overview maps | 3 | Empty: these are not gathering zones |
| Taxi-system map views | 3 | Empty: alternate views, not additional zones |

The inventory includes Darkspear Islands (2524), the Zephras Isle taxi view (2665),
the older battlegrounds, and overview maps that were absent from the initial
50-entry list. Mount Hyjal (2482) now uses its name from the client export.
There are no separate dungeon/raid/floor UI map rows in this build's UiMap
export. Dungeon world-instance IDs belong to a different ID space and must not
be invented as UI map IDs. A parent ID is a map hierarchy relation, not evidence
that the maps are physically adjacent.

## Evidence and reproducibility

The pinned sources are in `tools/maps/forever-1.60.1.70009/`:

- [UiMap export](https://wago.tools/db2/UiMap/csv?build=1.60.1.70009): complete ID, name, parent, type and system inventory.
- [UiMapAssignment export](https://wago.tools/db2/UiMapAssignment/csv?build=1.60.1.70009): world-instance IDs and map rectangles.
- `manifest.json`: build, retrieval date, source URLs, SHA-256 checksums and the supported maximum minimap range.

The 61 assignment rows include two continent assignments on the world overview.
Each of the 54 normal-system zone/battleground maps has exactly one full-map
rectangle. The generator refuses missing, partial, ambiguous or invalid geometry
instead of silently claiming coverage.

## What a neighbor means

There are **189 reciprocal spatial candidate pairs**. Two eligible maps are
neighbors if they occupy the same world instance and their rectangles overlap,
touch, or have a shortest gap of at most 1,000 yards. That is the maximum range
allowed by the minimap settings. Overview and taxi maps never become candidates.

These are conservative candidates, not road connections or exact zone polygons.
Map rectangles include water and areas outside the playable zone, so some
neighbors look geographically distant. This intentionally avoids losing nearby
nodes merely because their map IDs differ. The minimap still checks the precise
node distance, instance and tracking filters before showing a pin. Boats,
portals and flight paths do not create links.

The minimap reads the static current-zone entry, projects the player into the
listed maps, and queries their nearby spatial buckets. **No map enumeration or
neighbor generation runs in the addon.** Unknown map IDs query their own buckets
only. Predefined database allocation is unchanged.

The world map uses the same neighbor list when a zone is selected and World Map >
Show neighboring zone nodes is enabled (off by default). The full
selected map rectangle is projected into each neighbor before querying its node
index. Pins are registered on the selected map while keeping their original
coordinates for tooltips and history. Pins load on zone selection/map opening
and settings changes. Panning and zooming do not query or rebuild pins; the map
canvas handles clipping. World, continent and taxi overviews show no node pins.
The separate GatherLite search/map window is unchanged.

## Updating and checking

```text
python tools/build_zone_neighbors.py
python tools/build_zone_neighbors.py --check
python -m unittest discover -s tools -p test_zone_inventory.py
lua tools/test_zones.lua
lua tools/test_tracking.lua
```

Generation and tests are offline. For a newer build, obtain matching UiMap and
UiMapAssignment exports, save a new versioned source directory with its manifest,
update the generator's source path, and review the generated diff. If the maximum
minimap range increases, regenerate with that larger bound. Do not hand-edit the
Lua output without updating the source audit.

The checks cover all source IDs, node-database coverage, reciprocal links,
instance isolation, missing spatial candidates, exact regenerated output,
settings-range coverage, cross-border queries and spatial-index integrity.
In-game visual testing has not been performed; the completeness result is based
on the pinned client-data exports and offline tests.
