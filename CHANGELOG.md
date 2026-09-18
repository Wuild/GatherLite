### Changelog

#### 8.0.0-forever.1 — 2026-09-18

First Forever-only release for WoW 1.60.1 (interface 16001). The addon name and saved-variable names remain GatherLite. Other WoW clients should continue using the existing 7.x releases.

* Replace nearby minimap pin hiding with hollow circles at known locations; retain the adjustable distance and hover tooltips.

* Track rogue practice lockboxes, Buccaneer's Strongboxes and outdoor footlockers under Containers, including successful Pick Lock casts.

* Group nearby-node tooltips into icon/name/count rows, with the hovered type first and combined gathering history per type.

* Use Forever's native checkbox menus for both map buttons; let gathering pins pass clicks through while retaining hover tooltips.

* Keep world-map pins below dropdown menus so overlapping pins cannot intercept tracking-menu clicks.

* Synchronize map-menu checkboxes and per-map tracking settings; load newly enabled predefined categories before redrawing either map.

* Target WoW: Forever only, interface 16001; remove other client manifests, expansion datasets, catalog entries, icons, and unused libraries.
* Consolidate supported original-world locations and Wowhead imports into a single compact object/map/coordinate database.
* Load enabled gathering types lazily, share runtime metadata, and release consumed coordinate arrays.
* Allocate loot and visit history only for gathered nodes; preserve that history when gathering a predefined pin.
* Use spatial indexes for node lookups and distinguish object IDs at the same position.
* Provide a cached Wowhead Forever updater and offline generation from committed import state.
* Add Cold Iron, Fool's Gold, Starsilver, Greater Moonstone, Nightmare Moss, Dreamroot, Moonroot, and Star Lotus, plus six previously missing mining types.
* Discover gathering IDs from Wowhead's complete mineral-vein and herb listings, import known aliases, and report unmapped objects for catalog updates.
* Import 768 additional locations; preserve native skill colors when Wowhead only supplies a minimum gathering skill.
* Use Forever spell/skill APIs, match player cast events, and handle restricted tooltip values.
* Update bundled Ace3 and HereBeDragons libraries; add automated Lua and importer checks.
