# Bundled ground navigation

GatherLite includes the walking terrain and ground search modules from
[Shortest Path Forever](https://github.com/cjber/shortest-path-forever), by
Cillian Berragan and contributors. Players do not need that addon installed.
The pinned revision, original hashes and adapted hashes are in
`vendor/manifest.json`. Runtime operation requires no network or external program.

## Licensing and source

The imported files and navigation data are **GPL-3.0-or-later**, not MIT.
Their full license is included in `vendor/LICENSE`, and their upstream provenance
and third-party inputs are preserved in `vendor/THIRD_PARTY.md`. Preserve those
notices and provide the corresponding source when redistributing this combined
addon under the GPL terms. GatherLite's pre-existing MIT copyright and permission
notices remain applicable to its original code; the root MIT license does not
relicense the imported GPL components. All runtime Lua source is shipped.

The nav data is derived from client terrain. The upstream source descriptions
are retained in the generated files; GatherLite has not independently baked or
verified that terrain against every Forever build. See upstream's
`tools/baker/README.md` for regeneration from a local client.

## Adaptations

`python tools/vendor_navigation.py` downloads only an explicitly pinned revision.
It changes the data global to `GatherLiteGroundPathData`, puts search state in
GatherLite's private `GroundNavigation` namespace, and disables the search's
endpoint relocation retries. No upstream UI, journey, transport, API or player
movement code is included. `ground.lua` supplies GatherLite's scheduler adapter,
bounded circuit planning, coordinate conversion and strict endpoint selection.

The bundle covers world map IDs 0, 1 and 2991. Decode uses Forever's
`C_EncodingUtil` Base64/zlib support. Only touched clusters are decoded, and the
upstream memory limits remain enabled. Each route frame gets a two-millisecond
search budget with cooperative checkpoints. Cancellation drops the worker and
releases decoded terrain and search scratch.

Up to 64 representative gathering stops are evaluated using terrain costs in
both directions. Stops must share mutually reachable terrain. Original resource
markers stay at their reported coordinates; route endpoints use the centre of
the containing walkable cell (about eight yards wide). Unsupported cells and
overlapping floors with no known resource elevation are omitted rather than
snapped across a wall or cliff. Swimming is allowed at its terrain cost; flying,
flight paths, teleports and transports are never used. All route legs, including
the return, are drawn from ground geometry, with no straight-line fallback.

Terrain resolution, client changes and imprecise gathering coordinates still
require in-game checks, especially near caves, bridges and narrow passages.
