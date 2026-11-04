# Third-party inputs

Everything Shortest Path Forever is built from that it did not write itself: where each comes from, where its pin
lives, its licence, and whether any of it reaches the zip players install. A pin is named by the constant that holds
it, so a data refresh that moves the pin never leaves this file behind. The addon itself is GPL-3.0-or-later
([LICENSE](LICENSE)).

## Ships in the zip

| Input | Used for | Pin | Licence |
|---|---|---|---|
| WoW: Forever client tables, via [wago.tools](https://wago.tools) | Taxi paths, transports, lifts, portals and teleports in `Data/*.lua` | `BUILD` in `tools/gen_routes.py` (`tools/gen_transit.py` imports it) | Blizzard Entertainment's game data |
| [CMaNGOS classic-db](https://github.com/cmangos/classic-db) | Portal and teleport destinations, transport spawns and periods in `Data/*.lua` | `DB_REV` in `tools/gen_transit.py` | GPL-3.0 |
| [CMaNGOS mangos-classic](https://github.com/cmangos/mangos-classic) | The transport timetable model and flight speed, reimplemented in `tools/gen_routes.py` and `tools/gen_transit.py` | Cited by source file in those scripts; no code copied | GPL-2.0-or-later |
| [InFlight](https://github.com/LudiusMaximus/InFlight) | Recorded flight durations in `Data/Taxi.lua` | `INFLIGHT_REV` in `tools/gen_transit.py` | MIT |
| Local client terrain, baked with TrinityCore's tools | The walkable cells in `Nav/*.lua` (`tools/baker/README.md`) | `TRINITY_REV` in `tools/baker/bake.sh` and the client build baked | Derived data, GPL-3.0-or-later; Blizzard's EULA applies to the client files |

No embedded libraries ship. `media/` is this addon's own: the icon is drawn in `media/icon.svg`, `zeppelin.tga` by
`tools/draw_zeppelin.py`, and `Dot.tga` is a plain white disc.
`Locales/*.lua` are machine translated, using the client's own GlobalStrings for the pinned build (via wago.tools)
as the glossary for game terms; eight frFR lines are Brainc3ll's.

## Read in game, never bundled

| Input | Used for | Licence |
|---|---|---|
| QuestieDB, if installed | Quest givers and objectives as route goals | QuestieDB carries no licence; nothing is copied |
| TomTom and RestedXP Guides, if installed | Waypoints and guide steps, through their public APIs | Their own; nothing is copied |
| TomTom's API, while TomTom is not installed | `Core/TomTom.lua` answers guide addons' TomTom calls, and `/way` reads its arguments as TomTom does | Our own code; only TomTom's public call names and `/way` syntax are followed |
| Adventure Guide Forever and Tweaks Forever, if installed | The RestedXP hand-off, and class trainers for nearby services, through their public APIs | GPL-3.0-or-later |

## Build and test only

| Input | Used for | Pin | Licence |
|---|---|---|---|
| [TrinityCore](https://github.com/TrinityCore/TrinityCore) with its vendored CascLib (MIT) and Recast/Detour (zlib) | Terrain extraction for the navigation bake, fetched and patched in `tools/baker/` | `TRINITY_REV` in `tools/baker/bake.sh` | GPL-2.0-or-later |
| [WoWDBDefs](https://github.com/wowdev/WoWDBDefs) | Reference for the Forever table layouts the baker reads | The commit linked in `tools/baker/README.md` | CC BY-SA 4.0 |
| [Blizzard UI source](https://github.com/Gethe/wow-ui-source) | The map, tracker and spinner specs, fetched into `tools/.cache/` | `revision` in `tools/fetch_blizzard_ui.sh`; `REVISION` in `tools/fetch_tracker_ui.py` | Blizzard Entertainment's; fetched, never committed |
| [Ketho's WoW API annotations](https://github.com/Ketho/vscode-wow-api) | lua-language-server types in `tools/typecheck.sh` | `revision` in `tools/typecheck.sh` | MIT |
| [forever_tools](https://github.com/cjber/skills/tree/main/wow-forever-addon/tooling/forever_tools) | Shared lints, release checks and the generated-data gate, vendored in `tools/forever_tools/` | `revision` in `tools/forever_tools/MANIFEST.json` | MIT |
| [wow-mock-screenshots](https://github.com/cjber/skills/tree/main/wow-mock-screenshots) and the client art it fetches | `tools/screenshots.py` | `WOWMOCK` (a local checkout); the art at `BUILD` in `tools/gen_routes.py` | MIT; the art is Blizzard Entertainment's, fetched at build time and committed only as it appears in `docs/screenshots/` |
| sift gate | `.sift/gate.py` and `.sift/agents.py` in CI | Vendored by `sift setup` | MIT (`.sift/LICENSE`) |

CI tools (StyLua, ruff, luacheck, shellcheck, shfmt, lua-language-server, actionlint, zizmor, gitleaks, the BigWigs
packager) are pinned in `.github/workflows/` and `tools/typecheck.sh`, except luajit and luacheck, which come from the runner's apt; they build and check the addon and are never
part of it.

## Ideas and contributors

Credit for the ideas and reports behind the addon.

| Who | What | Notes |
|---|---|---|
| [Polestar](https://github.com/fitzforge/polestar) by Fitz | The ideas for learning the Hearthstone bind point from where it lands you (#147), keeping a journey after `/reload` (#148), an eased, movable fallback arrow (#149), flights in flight master tooltips (#150), routing instance goals to the entrance (#151), stopping idle minimap updates (#152), the arrival sound (#155), the time left under the compass (#156) the goal on the minimap rim (#157), drawing the world map on frames of its own, which the map never touches (#158), and walks that keep out of the other faction's towns. From cjber/adventure-guide-forever's issues: `/path report` with its copy box and caught errors (#156), the issue forms (#157), the zip check (#158), the `Subscribe` API (#159), `tools/doctor.py` (#160), the stale-screenshot check (#161), this file (#162), the "For addon authors" changelog subsection (#163), `tests/README.md` (#164) and `.editorconfig` (#165). | GPL-3.0. Inspired only; no code was copied. Fitz is welcome to use our code. |
| Ding! by Yendi | The idea for walks that keep out of zones far above your level (round 6) | Inspired only; no code was copied. |
| Fitz | Found that drawn walks skipped the line test at their ends, with reproductions (#144); the fix is our own (#187) | |
| TRDeadbeat, tallsmartman and Sol\_Deus, on CurseForge, and other CurseForge players | Reported the gamepad interface freezing or blocking `SetPreferredGamepadInteractTarget()` (#158) | |
| Zavian | Found Shift-click on map pins blocking chat links, with the fix (#134) | |
| Osipanda | Found routes ignoring Forever's new boats (#84) | |
| Nightwind416 | Asked for a movable tracker and compass (#76) | |
| wfournier | Asked for the tracker and compass to scale (#122) | |
| The\_\_\_Fast, on CurseForge | Found the Powderfuse Port flight path that isn't there, and asked for *Minimum Hearthstone saving* (1.7.0) | |
| cidolfus27, on CurseForge | Asked for journeys to follow RestedXP's guide in place of its arrow (1.12.0) | |
| Alex21xx, on CurseForge | Asked for metres, *Resume guide*, *Complete this step*, the minimap settings button and marking a flight path as known (1.14.0), and found routes flying on through flight points the character doesn't know (1.15.0) | |
| o0saw0o, on CurseForge | Asked to hide the Journey steps and the arrow while keeping the map route (1.14.0) | |
| Merlinqt, on CurseForge | Asked for map icon sizes (1.14.0) | |
| Maggew, on CurseForge | Found the "Division by zero" error, and asked for the steps on the destination pin and the compass background (1.15.0), finer compass positioning (#160) and the arrow-key nudge (1.17.0) | |
| team\_Brigade, phear and Testvonfarkle, on CurseForge | Asked to hide the empty tracker's title (1.15.0) | |
| berserkerlxl, on CurseForge | Found guides' TomTom waypoints not reaching the addon, and asked for `/way` (1.15.0); found that Questie's tracker was covering the Journey (#214) | |
| rydoc and Joster91, on CurseForge | Found the Journey collapsing into or overlapping the quest tracker (1.15.0, 1.17.0) | |
| deathmvp1, on CurseForge | Asked to move the Journey off the quest list; detaching it is now in its right-click menu (1.17.0). Found Questie's quest list covering the Journey, which now moves clear of it (#214) | |
| GenericP, on CurseForge | Asked to plan to a spot under a Questie icon, now Alt-click on the world map (1.14.0), and for TomTom waypoints to start journeys (1.15.0); also answered other players' questions on the page | |
| [Brainc3ll](https://github.com/Brainc3ll) | Eight lines of the French translation, from his Legacy Forever translation (cjber/legacy-forever#99); the rest of `Locales/frFR.lua` and the other languages are machine translated (lines ending `-- mt` in frFR) | |

Thanks also to everyone else who reported a bug or asked for a feature, here or on CurseForge.
