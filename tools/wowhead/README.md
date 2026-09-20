# Updating the Forever database

Requires Python 3.10+; standard library only. Run from the repository root:

```sh
# Preview a fresh import; writes the HTML cache only.
python tools/update_forever_wowhead.py --refresh --dry-run
# Apply those cached pages.
python tools/update_forever_wowhead.py --offline
# Fetch and apply in one run.
python tools/update_forever_wowhead.py --refresh
# Also check the full mining/herb listings for missing IDs and known aliases.
python tools/update_forever_wowhead.py --discover --refresh
# Regenerate the Lua from committed state; no network or HTML cache needed.
python tools/update_forever_wowhead.py --generate-only
```

To update selected objects:

```sh
python tools/update_forever_wowhead.py --objects 1731 1617 --refresh
```

By default, all previously imported source IDs are refreshed. An entirely new database starts with the IDs in `scripts/nodes.lua`. `--discover` additionally reads the full [mineral-vein](https://www.wowhead.com/forever/objects/mineral-veins) and [herb](https://www.wowhead.com/forever/objects/herbs) listings, imports listed IDs already in the catalog, and reports unknown IDs with their names and minimum skills. It rejects truncated listings. Seven quest pickups in the herb listing are explicitly excluded; these are not Herbalism nodes. The discovery report is stored in `forever.json` so scheduled runs can detect newly unmapped objects without repeating old alerts. Discovery supports cached/offline pages and cannot be combined with `--objects` or `--generate-only`.

Selected-object imports preserve the other records. Updates are additive: missing spawns and empty responses do not erase known locations.

## Data format

* `plugins/database/data/forever.lua` is the only packaged location database. It stores `[objectID][uiMapID] = { x, y, ... }` with normalized 0–1 coordinates and no per-location tables or metadata.
* `tools/wowhead/forever.json` is the authoritative schema-2 import state. Its `nodes` object has the same grouping, with integer millionths instead of floating point coordinates. Source URLs, HTML hashes, counts, and warnings are stored once per imported object outside the packaged addon. Commit it with the generated Lua.
* `.wowhead-cache/forever/<objectID>.html` is an ignored local cache. Pages are reused unless `--refresh` is specified. Manually saved page source can be imported using `--offline`.

The Forever-only consolidation retains supported original-world locations plus Wowhead imports. The initial consolidation dropped 42 records with uncatalogued IDs 1610, 2653, and 177784. IDs 1610 and 2653 now have catalog definitions and freshly imported Wowhead locations; 177784 remains unsupported. There is no longer a dependency on a Vanilla file or any other client dataset. The canonical node catalog defines type, localized name, and icon once per object.

## Source handling

The importer reads pages under `https://www.wowhead.com/forever/`, for example [Copper Vein](https://www.wowhead.com/forever/object=1731/copper-vein). It validates final and canonical URLs and parses `g_mapperData` JSON without executing page scripts. Map IDs come from each layer's `uiMapId`, never the outer Wowhead area keys. Coordinates are normalized and rounded to six decimal places.

Aliases are normalized to the catalog's first object ID. Duplicate object/map/coordinate combinations are removed; nearby positions remain separate. The runtime resolves world coordinates and instances with HereBeDragons. Personal saved nodes are indexed first so predefined loading can avoid duplicate pins.

Requests are sequential, two seconds apart by default (`--delay`, minimum one). HTTP errors, wrong-client pages, malformed JSON, invalid coordinates, or missing map IDs stop the import before generated output is changed. Explicit unknown-location pages, empty mapper arrays on registered Forever object pages, and unmapped `[0, 0]` placeholders are reported and skipped. Empty mapper arrays can occur when Wowhead lists a dungeon but no pin coordinates. A Forever URL identifies Wowhead's selected database, but does not establish that every spawn was newly verified in the client.

## New objects and checks

Run `--discover --refresh` to find omissions. Add an object to `scripts/nodes.lua` and the locale files, including its icon and verified skill requirement, then run `--objects <id> --refresh`. Unknown IDs are reported but not automatically registered, to avoid generating invisible nodes or confusing quest pickups with gathering nodes. Catalog edits and translations require source verification. A one-entry `levels` table stores a verified minimum skill without guessing skill-up thresholds; native tooltip colors are retained above that minimum. Icons may be addon assets or built-in `Interface\\Icons\\...` paths.

### Catalog audit: September 18, 2026

The complete Forever listings contained 42 mineral-vein IDs and 57 herb-category IDs. All mineral veins and 50 herb IDs now have catalog entries; the other seven are quest pickups. The eight additional gathering types below contribute 134 coordinates:

| Object | Object ID | Minimum skill | Coordinates |
| --- | ---: | ---: | ---: |
| [Cold Iron Deposit](https://www.wowhead.com/forever/object=439558) | 439558 | 125 | 20 |
| [Fool's Gold Vein](https://www.wowhead.com/forever/object=439628) | 439628 | 175 | 17 |
| [Starsilver Vein](https://www.wowhead.com/forever/object=439778) | 439778 | 245 | 14 |
| [Greater Moonstone Formation](https://www.wowhead.com/forever/object=439815) | 439815 | 245 | 10 |
| [Nightmare Moss](https://www.wowhead.com/forever/object=439557) | 439557 | 125 | 17 |
| [Dreamroot](https://www.wowhead.com/forever/object=439627) | 439627 | 205 | 20 |
| [Moonroot](https://www.wowhead.com/forever/object=439810) | 439810 | 250 | 16 |
| [Star Lotus](https://www.wowhead.com/forever/object=439762) | 439762 | 250 | 20 |

Also added Incendicite (1610/1667), Lesser Bloodstone (2653), Indurium (19903), Hakkari Thorium (180215), and Small/Large Obsidian Chunks (181068/181069). Indurium and Hakkari Thorium currently provide no pin coordinates. Their IDs are tracked for future updates. The expanded import covers 125 source IDs and adds 768 locations overall, including previously unqueried aliases, for 25,921 total locations.

New icon names come from the corresponding loot items on these pages. Chinese names were checked against Wowhead's Forever `cn/object=<id>` pages. Six of the eight new types have only bracketed English placeholders there, so those retain the addon's English fallback until verified Chinese names are available.

### Rogue training chests

The [Forever chest listing](https://www.wowhead.com/forever/objects/chests) was checked separately. These seven types are registered under Containers:

| Type | Source object IDs |
| --- | --- |
| Practice Lockbox | 178244, 178245, 178246 |
| Buccaneer's Strongbox | 123330, 123331, 123332, 123333 |
| Battered Footlocker | 179486, 179488, 179490 |
| Waterlogged Footlocker | 179487, 179489, 179491 |
| Dented Footlocker | 179492, 179494, 179496 |
| Mossy Footlocker | 179493, 179497 |
| Scarlet Footlocker | 179498 |

The first ID in each row is canonical. The fresh Forever pages supplied 262 unique footlocker positions after alias deduplication, bringing the database to 26,183 locations and 144 source IDs. At that initial import, Practice Lockboxes and Buccaneer's Strongboxes reported unknown locations; their newly published coordinates were added in the September 20 refresh below. All 19 IDs remain in import state and are refreshed by normal scheduled updates. `--discover` still discovers mining/herb IDs; chest discovery is a separate catalog audit.

Pick Lock ([spell 1804](https://www.wowhead.com/forever/spell=1804/pick-lock)) records supported world-object names on successful casts, even without loot. Failed casts and inventory lockboxes do not create pins. Chinese names are verified from the corresponding Forever `cn/object=<id>` pages. Lockpicking thresholds are not inferred from the chest listing's generic `skill: 1` field.

```sh
python -m unittest discover -s tools -p 'test_*.py'
lua tools/test_database.lua
lua tools/test_compat.lua
lua tools/test_tracking.lua
```

Tests cover offline parsing, invalid input, additive updates, deterministic generation, the complete grouped database, lazy loading and release, shared runtime metadata, and gathering history for predefined nodes. CI runs the same checks.

### Database refresh: September 20, 2026

Refreshed all 144 source object pages and added **311 unique locations**, for **26,494 total**. All previously stored locations were preserved. The mining/herb listing check still found 99 IDs, no uncatalogued gathering objects, and seven excluded quest pickups.

The refresh includes five unique Practice Lockbox locations, three Buccaneer's Strongbox locations, and 16 additional footlocker locations (278 footlocker locations total). Alias coordinates are deduplicated before counting.

The initial run stopped at object 181109 with HTTP 403 after 135 successful pages. Those refreshed pages were applied from cache. A later retry of the remaining nine sources at ten-second intervals completed successfully and added no further locations. All 144 source records are now refreshed. The successful retry is consistent with a temporary access restriction; the response alone does not establish rate limiting as the cause.

For a slower refresh, use `--delay 10` (seconds between requests). The normal default remains two seconds.
