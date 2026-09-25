# Maintainer tools

Run commands from the repository root with Python 3.10 or newer. No third-party Python packages are required. GitHub Actions runs tests only.

## Publish to CurseForge

Forever is the sole supported client for GatherLite on the existing CurseForge project. Use normal release versions such as `8.0.1` and `8.0.2`; no client suffix is required. Existing addon and saved-variable names are unchanged.

Copy `.env.example` to `.env` in the repository root and set `CURSEFORGE_TOKEN` locally and `CURSEFORGE_GAME_VERSION=1.60.1` to the exact game version listed on CurseForge. Multiple versions use commas, for example `CURSEFORGE_GAME_VERSION=1.60.1,1.60.2` when both are supported. Spaces around commas are accepted and duplicate versions are removed. All versions must resolve before an archive is built for upload; one uploaded file is tagged with all selected versions. Set `CURSEFORGE_PROJECT_ID=334918` for the destination project (also the default when omitted). The game version defaults to `1.60.1` when omitted; `--version` sets the addon release version. This setting controls CurseForge compatibility labels and default release notes; it does not change the TOC interface number or add client compatibility. The addon and package validation currently target Forever. The token file is ignored by Git and excluded from packages. Quoted values and an optional `export` prefix are accepted; values are read literally, without shell expansion.

Preview the current working tree without a token, network requests, or a ZIP:

```sh
python tools/publish.py --version 8.0.1 --dry-run
```

Build a ZIP and SHA-256 checksum under `dist/` without a token, network requests, or upload:

```sh
python tools/publish.py --version 8.0.1 --package-only
```

`--package-only` and `--dry-run` are mutually exclusive. Both use the same archive rules and validation as publishing.

After reviewing changes and running tests, build and upload:

```sh
python tools/publish.py --version 8.0.1
```

Use `--changelog /path/to/notes.md` for optional Markdown release notes and `--env-file /path/to/credentials.env` for a different configuration file. Without notes, the publisher uses a short version/client description. Increase the minor version for new features and reserve patch increments for database updates. Always update the main window's What's New highlights before publishing (see `AGENT.md`).

The publisher validates the addon load paths, resolves the exact CurseForge game-version IDs for all configured game versions, and uploads a Release to the configured project. The ZIP and checksum are created under `dist/`; the source TOC's `@project-version@` is replaced inside the package only. Uncommitted changes are included. Tests, commits, and tags are not run or created by the publisher.

Success prints the accepted file link. Approval and public visibility still depend on CurseForge. Uploads are never retried automatically: after an error or timeout, check the author dashboard before retrying to avoid duplicate files. Tokens and raw API error bodies are not printed.

API reference: [CurseForge Upload API](https://support.curseforge.com/support/solutions/articles/9000197321).

## Archive contents

Edit `package-rules.json` in the repository root. `include` selects files using relative glob patterns; `exclude` removes matching files or directories, even if included. Use forward slashes, `*` for one path segment, and `**` for nested directories. For example, add `"docs/*.txt"` to `include` or `"icons/unused.tga"` to `exclude`.

The defaults include `GatherLite.toc`, `LICENSE`, and the `scripts`, `plugins`, and `icons` trees. Hidden files/directories (including `.env` and `.git`) and `__pycache__` are always excluded. Removing the TOC, license, Forever database, or a file referenced by the TOC/XML causes validation to fail. Asset paths used in Lua are not checked, so take care when excluding icons. The same rules apply to previews and published archives. Without the rules file, the original runtime-file defaults apply. The local publisher does not read `.pkgmeta`.

Run `python tools/publish.py --version 8.0.1 --dry-run` to validate selection without creating a ZIP or uploading.

## Update the database

```sh
python tools/update_forever_wowhead.py --discover --refresh --delay 10
```

See the [importer guide](wowhead/README.md) for selected-object refreshes, offline generation, and source details.

## Validate changes

```sh
python -m unittest discover -s tools -p 'test_*.py'
lua tools/test_compat.lua
lua tools/test_database.lua
lua tools/test_tracking.lua
lua tools/test_tooltips.lua
lua tools/test_routes.lua
lua tools/test_map_reveal.lua
lua tools/test_map_zoom.lua
```

Publisher tests mock HTTP. Packaging tests use temporary test archives. For allocation measurements with mocked game APIs, run `lua tools/test_tracking.lua --benchmark`.

In-game checks: enable `/console scriptErrors 1`, reload, test both map menus, gathering/lockpicking, tooltips, nearby circles, and saved history after reload.


For routing/window changes, also check in game: /gather opens World Map; scroll, drag, click a zone and right-click back; use breadcrumb dropdowns and the permanent sidebar; search and browse resources; calculate and cancel with visible progress; hide/clear a route; open the game world map and zoom/pan with the same circuit visible above terrain; check a rotating minimap; reload to restore the selected route. Verify every Settings category and control, including persistence after reload. Lua mocks cover logic and wiring, not rendering.


Fish reference checks are included in test_routes.lua and test_fish_import.py.
In game, enable Fishing separately for the world map and minimap with the
predefined database enabled. Verify catch markers without a selected fish, switch
zones, search a fish to narrow the overlay, then hide and clear it. Hover clustered
markers to inspect all reported fish. Check a zone-only fish (for example Raw
Longjaw Mud Snapper) shows zone information without invented pins, and check
Herbalism/Mining requirements in the resource list, details and pin tooltips.

## Static zone neighbors

The addon reads a checked-in neighbor table covering all 60 UI maps in Forever
build 1.60.1.70009. Rebuild it offline from the pinned client exports with
`python tools/build_zone_neighbors.py`, or validate it with
`python tools/build_zone_neighbors.py --check`.
See [the map audit](../docs/zone-neighbors.md) for source provenance, the definition
of a spatial neighbor, supported range and build-update instructions.
