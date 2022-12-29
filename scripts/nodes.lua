local name, _GatherLite = ...;

_GatherLite.iconPath = "Interface\\AddOns\\" .. _GatherLite.name .. "\\icons\\"

_GatherLite.nodeDB = {}

local function InsertObject(type, ids, name, icon, levels)
    table.insert(_GatherLite.nodeDB, {
        type = type,
        id = ids,
        name = name,
        icon = _GatherLite.iconPath .. icon,
        levels = levels
    })
end

-- Ores
-- Classic
InsertObject("ore", { 1731, 2055, 3763, 103713, 103714 }, "copper_vein", "Ore\\Copper", { 1, 25, 50, 100 })
InsertObject("ore", { 1732, 3764, 2054, 103711, 103709 }, "tin_vein", "Ore\\Tin", { 65, 90, 115, 165 })
InsertObject("ore", { 1733, 105569, 73940 }, "silver_vein", "Ore\\Silver", { 75, 100, 125, 175 })
InsertObject("ore", { 1735, 103710, 103712, 73939 }, "iron_deposit", "Ore\\Iron", { 125, 150, 175, 225 })
InsertObject("ore", { 1734, 150080, 181109, 73941 }, "gold_vein", "Ore\\Gold", { 155, 180, 205, 255 })
InsertObject("ore", { 2040, 150079, 176645, 123310 }, "mithril_deposit", "Ore\\Mithril", { 175, 200, 225, 275 })
InsertObject("ore", { 2047, 150081, 181108, 123309 }, "truesilver_deposit", "Ore\\Truesilver", { 230, 255, 280, 330 })
InsertObject("ore", { 165658 }, "dark_iron_deposit", "Ore\\DarkIron", { 230, 255, 280, 330 })
InsertObject("ore", { 324, 150082, 176643, 123848 }, "small_thorium_vein", "Ore\\Thorium", { 245, 270, 295, 345 })
InsertObject("ore", { 175404, 176644, 177388 }, "rich_thorium_vein", "Ore\\RichThorium", { 275, 290, 300, 350 })

-- TBC
InsertObject("ore", { 181555 }, "fel_iron_deposit", "Ore\\FelIron", { 300, 325, 350, 400 })
InsertObject("ore", { 181556 }, "adamantite_deposit", "Ore\\Adamantite", { 325, 350, 375, 425 })
InsertObject("ore", { 181569 }, "rich_adamantite_deposit", "Ore\\Adamantite", { 350, 375, 400, 450 })
InsertObject("ore", { 181557 }, "khorium_vein", "Ore\\Khorium", { 375, 400, 425, 475 })

-- WOTLK
InsertObject("ore", { 189980 }, "saronite_deposit", "Ore\\Saronite", { 400, 425, 450, 475 })
InsertObject("ore", { 189981 }, "rich_saronite_deposit", "Ore\\Saronite", { 425, 450, 500, 500 })
InsertObject("ore", { 189978 }, "cobalt_deposit", "Ore\\Cobalt", { 350, 375, 400, 450 })
InsertObject("ore", { 189979 }, "rich_cobalt_deposit", "Ore\\Cobalt", { 375, 400, 425, 450 })
InsertObject("ore", { 191133 }, "titanium_vein", "Ore\\Titanium", { 450, 450, 450, 450 })


-- Herbs
-- Classic
InsertObject("herb", { 1617, 3725 }, "silverleaf", "Herb\\Silverleaf", { 1, 25, 50, 100 })
InsertObject("herb", { 1618, 3724 }, "peacebloom", "Herb\\Peacebloom", { 1, 25, 50, 100 })
InsertObject("herb", { 1619, 3726 }, "earthroot", "Herb\\Earthroot", { 15, 40, 65, 115 })
InsertObject("herb", { 1620, 3727 }, "mageroyal", "Herb\\Mageroyal", { 50, 75, 100, 150 })
InsertObject("herb", { 1621, 3729 }, "briarthorn", "Herb\\Briarthorn", { 70, 95, 120, 170 })
InsertObject("herb", { 2045 }, "stranglekelp", "Herb\\Stranglekelp", { 85, 110, 135, 185 })
InsertObject("herb", { 1622, 3730 }, "bruiseweed", "Herb\\Bruiseweed", { 100, 125, 150, 200 })
InsertObject("herb", { 1623 }, "wild_steelbloom", "Herb\\WildSteelbloom", { 115, 140, 165, 215 })
InsertObject("herb", { 1628 }, "grave_moss", "Herb\\GraveMoss", { 120, 145, 170, 220 })
InsertObject("herb", { 1624 }, "kingsblood", "Herb\\Kingsblood", { 125, 150, 175, 225 })
InsertObject("herb", { 2041 }, "liferoot", "Herb\\Liferoot", { 150, 175, 200, 250 })
InsertObject("herb", { 2042 }, "fadeleaf", "Herb\\Fadeleaf", { 160, 185, 210, 260 })
InsertObject("herb", { 2046 }, "goldthorn", "Herb\\Goldthorn", { 170, 195, 220, 270 })
InsertObject("herb", { 2043 }, "khadgars_whisker", "Herb\\KhadgarsWhisker", { 185, 210, 235, 285 })
InsertObject("herb", { 2044 }, "wintersbite", "Herb\\Wintersbite", { 195, 220, 245, 295 })
InsertObject("herb", { 2866 }, "firebloom", "Herb\\Firebloom", { 205, 230, 255, 305 })
InsertObject("herb", { 142140, 180165 }, "purple_lotus", "Herb\\PurpleLotus", { 210, 235, 260, 310 })
InsertObject("herb", { 142141, 176642 }, "arthas_tears", "Herb\\ArthasTears", { 220, 245, 270, 320 })
InsertObject("herb", { 142142, 176636, 180164 }, "sungrass", "Herb\\Sungrass", { 230, 255, 280, 330 })
InsertObject("herb", { 142143, 183046 }, "blindweed", "Herb\\Blindweed", { 235, 260, 285, 335 })
InsertObject("herb", { 142144 }, "ghost_mushroom", "Herb\\GhostMushroom", { 245, 270, 295, 345 })
InsertObject("herb", { 142145, 176637 }, "gromsblood", "Herb\\Gromsblood", { 250, 275, 300, 350 })
InsertObject("herb", { 176583, 176638, 180167 }, "golden_sansam", "Herb\\GoldenSansam", { 260, 285, 310, 360 })
InsertObject("herb", { 176584, 176639, 180168 }, "dreamfoil", "Herb\\Dreamfoil", { 270, 295, 320, 370 })
InsertObject("herb", { 176586, 176640, 180166 }, "mountain_silversage", "Herb\\MountainSilversage", { 280, 305, 330, 380 })
InsertObject("herb", { 176587, 176641 }, "plaguebloom", "Herb\\Plaguebloom", { 285, 310, 335, 385 })
InsertObject("herb", { 176588 }, "icecap", "Herb\\Icecap", { 290, 315, 340, 390 })
InsertObject("herb", { 176589 }, "black_lotus", "Herb\\BlackLotus", { 300, 325, 350, 400 })

-- TBC
InsertObject("herb", { 181270 }, "felweed", "Herb\\Felweed", { 300, 325, 350, 400 })
InsertObject("herb", { 181271, 183045 }, "dreaming_glory", "Herb\\DreamingGlory", { 315, 340, 365, 415 })
InsertObject("herb", { 181275 }, "ragveil", "Herb\\Ragveil", { 325, 350, 375, 425 })
InsertObject("herb", { 181277 }, "terocone", "Herb\\Terocone", { 325, 350, 375, 425 })
InsertObject("herb", { 181278 }, "ancient_lichen", "Herb\\AncientLichen", { 340, 365, 390, 440 })
InsertObject("herb", { 181279 }, "netherbloom", "Herb\\Netherbloom", { 350, 375, 400, 450 })
InsertObject("herb", { 181280 }, "nightmare_vine", "Herb\\NightmareVine", { 365, 390, 415, 465 })
InsertObject("herb", { 181281 }, "mana_thistle", "Herb\\ManaThistle", { 375, 400, 425, 475 })
InsertObject("herb", { 181276 }, "flame_cap", "Herb\\FlameCap", { 335, 360, 385, 435 })
InsertObject("herb", { 181166 }, "bloodthistle", "Herb\\Stranglekelp", { 0, 0, 0, 0 })

-- WOTLK
InsertObject("herb", { 189973 }, "goldclover", "Herb\\GoldClover", { 350, 375, 400, 450 })
InsertObject("herb", { 191303 }, "firethorn", "Herb\\FlameCap", { 360, 385, 410, 450 })
InsertObject("herb", { 190169 }, "tiger_lily", "Herb\\TigerLily", { 375, 400, 425, 450 })
InsertObject("herb", { 190170 }, "talandras_rose", "Herb\\TalandrasRose", { 385, 410, 435, 450 })
InsertObject("herb", { 190173 }, "frozen_herb", "Herb\\FrostLotus", { 400, 425, 450, 500 })
InsertObject("herb", { 191019 }, "adders_tongue", "Herb\\AddersTongue", { 400, 425, 450, 500 })
InsertObject("herb", { 190171 }, "lichbloom", "Herb\\Lichbloom", { 425, 450, 500, 500 })
InsertObject("herb", { 190172 }, "icethorn", "Herb\\Icethorn", { 435, 450, 500, 500 })

-- Containers
InsertObject("container", { 106319, 2843, 106318, 2849 }, "battered_chest", "Open\\Chest", nil)
InsertObject("container", { 75293 }, "large_battered_chest", "Open\\Chest", nil)
InsertObject("container", { 2850, 153453, 153454, 2855, 153451, 2852, 2857, 4149 }, "solid_chest", "Open\\Chest", nil)
InsertObject("container", { 74448, 153464, 75300, 153463, 75299, 75298, 153462, 153461 }, "large_solid_chest", "Open\\Chest", nil)
InsertObject("container", { 2744, 19018, 19017 }, "giant_clam", "Open\\Clam", nil)
InsertObject("container", { 157936 }, "ungoro_dirt_pile", "Soil", nil)

-- Fishing

-- Classic
InsertObject("fishing", { 180902, 180683, 180657, 180752 }, "battered_chest", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180655 }, "fish_pool_debris", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180685, 180662, 180901, 180751 }, "fish_pool_wreckage", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180750, 180900, 180682, 180664, 180582 }, "fish_pool_oily_blackmouth", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180656, 180663 }, "fish_pool_sagefish", "Fish\\Fishhook", nil)

-- WOTLK
InsertObject("fishing", { 192046 }, "musselback_sculpin_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192048 }, "dragonfin_angelfish_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192049 }, "fangtooth_herring_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192050 }, "glacial_salmon_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192051 }, "borean_man_o_war_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192052 }, "imperial_manta_ray_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192053 }, "deep_sea_monsterbelly_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192054 }, "moonglow_cuttlefish_school", "Fish\\Fishhook", nil)
InsertObject("fishing", { 192057 }, "nettlefish_school", "Fish\\Fishhook", nil)
