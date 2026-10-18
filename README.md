# GatherLite

Find herbs, ore, containers, fishing pools, and fish in **WoW Forever**. Includes over **26,000 gathering locations**, searchable fish catch areas, and farming routes for the world map and minimap.

[![Support me on Patreon](https://img.shields.io/badge/Support_me_on-Patreon-FF424D?style=for-the-badge&logo=patreon&logoColor=white)](https://www.patreon.com/c/Wuild)

![GatherLite's map window with resource search, profession requirements, and farming route controls](https://raw.githubusercontent.com/wuild/gatherlite/master/gatherlite-elwynn-forever.png)

![GatherLite planning a Copper Vein farming route through Elwynn Forest](https://raw.githubusercontent.com/wuild/gatherlite/master/gatherlite-farming-route.png)

## Get started

Download from [CurseForge](https://www.curseforge.com/wow/addons/gatherlite/files) and place the **GatherLite** folder in **Interface/AddOns**.

Open the window with **/gather**, **/gatherlite**, or **/gatherroutes**.

1. **Search and select a resource** in the sidebar to see its known locations and profession requirement.
2. **Browse zones** with the arrows in the lower panel.
3. **Generate zone routes** to calculate a ground circuit for each eligible zone using bundled terrain data. The recommended zone opens first; you can choose another. No additional navigation addon is required.
4. **Open world map** to view the same zone in Blizzard's map. Routes also appear on the minimap.

## Map controls

- **Scroll / + / -** to zoom, **drag** to pan.
- **Click a zone** to enter it; **right-click / back arrow** to go up a level.
- **Find** hides or shows the sidebar.
- **Hide / Show route** toggles route lines; **Clear** removes them.
- **Settings** adjusts map markers, resource filters, and other preferences. Changes save automatically.

On the game maps, **left-click the GatherLite button** to change that map's category filters. **Right-click** opens the GatherLite window. Hover markers for details and gathering history.

Minimap markers show known gathering locations. Nearby markers are hidden by default so the game's live tracking dots can show through. In Minimap settings, choose nearby hiding or empty circles; overlapping markers share one visible marker whose tooltip lists the grouped resources. Neither a resource icon nor a circle confirms an active spawn.

## Fish locations

Search **25 fish and fishing ingredients** to show reported catch areas on both maps. With no fish selected, the maps' **Fishing** filters show catches and fishing pools when the predefined database is enabled.

Nearby catches share transparent markers with fish names in their tooltips. Five fish currently have zone information only and are labeled **no precise pins**. Fish searches show catch areas rather than farming circuits.

Fish names use localized item names from your client. Uncached names temporarily use the bundled English name and update when the client supplies item data.

Known locations do not guarantee current spawns or catches. Ground routes use up to 64 representative stops and follow bundled walking terrain, with swimming where necessary. Unsupported or unreachable stops are omitted; missing terrain never falls back to straight lines. Terrain resolution and client changes still need in-game verification. Skill, competition and travel to the zone are not considered. Your selected route or fish is saved per character.

The bundled terrain and ground search code come from Shortest Path Forever under GPL-3.0-or-later. See [navigation credits, licensing and limitations](plugins/routes/navigation/README.md); those components are not covered by GatherLite's original MIT license.

## Support

[Report an issue](https://github.com/wuild/gatherlite/issues)
