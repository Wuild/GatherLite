local name, _GatherLite = ...;

_GatherLite.iconPath = "Interface\\AddOns\\" .. _GatherLite.name .. "\\icons\\"

_GatherLite.nodeDB = {}

local function InsertObject(type, ids, name, icon, levels)
    table.insert(_GatherLite.nodeDB, {
        type = type,
        id = ids,
        name = name,
        icon = icon:match("^Interface\\") and icon or (_GatherLite.iconPath .. icon),
        levels = levels
    })
end

-- Ores
-- Forever
InsertObject("ore", { 1731, 2055, 3763, 103713, 103714 }, "copper_vein", "Ore\\copper", { 1, 25, 50, 100 })
InsertObject("ore", { 1732, 3764, 2054, 103711, 103709 }, "tin_vein", "Ore\\tin", { 65, 90, 115, 165 })
InsertObject("ore", { 1733, 105569, 73940 }, "silver_vein", "Ore\\silver", { 75, 100, 125, 175 })
InsertObject("ore", { 1735, 103710, 103712, 73939 }, "iron_deposit", "Ore\\iron", { 125, 150, 175, 225 })
InsertObject("ore", { 1734, 150080, 181109, 73941 }, "gold_vein", "Ore\\gold", { 155, 180, 205, 255 })
InsertObject("ore", { 2040, 150079, 176645, 123310 }, "mithril_deposit", "Ore\\mithril", { 175, 200, 225, 275 })
InsertObject("ore", { 2047, 150081, 181108, 123309 }, "truesilver_deposit", "Ore\\truesilver", { 230, 255, 280, 330 })
InsertObject("ore", { 165658 }, "dark_iron_deposit", "Ore\\darkiron", { 230, 255, 280, 330 })
InsertObject("ore", { 324, 150082, 176643, 123848 }, "small_thorium_vein", "Ore\\thorium", { 245, 270, 295, 345 })
InsertObject("ore", { 175404, 176644, 177388 }, "rich_thorium_vein", "Ore\\rich_thorium", { 275, 290, 300, 350 })

-- Additional Forever objects verified against Wowhead's mineral-vein listing.
-- Only the minimum skill is published for these nodes; do not invent skill-up tiers.
InsertObject("ore", { 439558 }, "cold_iron_deposit", "Interface\\Icons\\inv_ore_mithril_01", { 125 })
InsertObject("ore", { 439628 }, "fools_gold_vein", "Interface\\Icons\\inv_misc_dust_01", { 175 })
InsertObject("ore", { 439778 }, "starsilver_vein", "Interface\\Icons\\inv_ore_platinum_01", { 245 })
InsertObject("ore", { 439815 }, "greater_moonstone_formation", "Interface\\Icons\\inv_misc_apexis_crystal", { 245 })
InsertObject("ore", { 1610, 1667 }, "incendicite_mineral_vein", "Interface\\Icons\\inv_ore_thorium_01", { 65 })
InsertObject("ore", { 2653 }, "lesser_bloodstone_deposit", "Interface\\Icons\\inv_ore_thorium_01", { 75 })
InsertObject("ore", { 19903 }, "indurium_mineral_vein", "Interface\\Icons\\inv_ore_mithril_01", { 150 })
InsertObject("ore", { 180215 }, "hakkari_thorium_vein", "Ore\\rich_thorium", { 275 })
InsertObject("ore", { 181068 }, "small_obsidian_chunk", "Interface\\Icons\\inv_misc_stonetablet_01", { 305 })
InsertObject("ore", { 181069 }, "large_obsidian_chunk", "Interface\\Icons\\inv_stone_15", { 305 })

-- Herbs
-- Forever
InsertObject("herb", { 1617, 3725 }, "silverleaf", "Herb\\silverleaf", { 1, 25, 50, 100 })
InsertObject("herb", { 1618, 3724 }, "peacebloom", "Herb\\peacebloom", { 1, 25, 50, 100 })
InsertObject("herb", { 1619, 3726 }, "earthroot", "Herb\\earthroot", { 15, 40, 65, 115 })
InsertObject("herb", { 1620, 3727 }, "mageroyal", "Herb\\mageroyal", { 50, 75, 100, 150 })
InsertObject("herb", { 1621, 3729 }, "briarthorn", "Herb\\briarthorn", { 70, 95, 120, 170 })
InsertObject("herb", { 2045 }, "stranglekelp", "Herb\\stranglekelp", { 85, 110, 135, 185 })
InsertObject("herb", { 1622, 3730 }, "bruiseweed", "Herb\\bruiseweed", { 100, 125, 150, 200 })
InsertObject("herb", { 1623 }, "wild_steelbloom", "Herb\\wild_steelbloom", { 115, 140, 165, 215 })
InsertObject("herb", { 1628 }, "grave_moss", "Herb\\grave_moss", { 120, 145, 170, 220 })
InsertObject("herb", { 1624 }, "kingsblood", "Herb\\kingsblood", { 125, 150, 175, 225 })
InsertObject("herb", { 2041 }, "liferoot", "Herb\\liferoot", { 150, 175, 200, 250 })
InsertObject("herb", { 2042 }, "fadeleaf", "Herb\\fadeleaf", { 160, 185, 210, 260 })
InsertObject("herb", { 2046 }, "goldthorn", "Herb\\goldthorn", { 170, 195, 220, 270 })
InsertObject("herb", { 2043 }, "khadgars_whisker", "Herb\\khadgars_whisker", { 185, 210, 235, 285 })
InsertObject("herb", { 2044 }, "wintersbite", "Herb\\wintersbite", { 195, 220, 245, 295 })
InsertObject("herb", { 2866 }, "firebloom", "Herb\\firebloom", { 205, 230, 255, 305 })
InsertObject("herb", { 142140, 180165 }, "purple_lotus", "Herb\\purple_lotus", { 210, 235, 260, 310 })
InsertObject("herb", { 142141, 176642 }, "arthas_tears", "Herb\\arthas_tears", { 220, 245, 270, 320 })
InsertObject("herb", { 142142, 176636, 180164 }, "sungrass", "Herb\\sungrass", { 230, 255, 280, 330 })
InsertObject("herb", { 142143, 183046 }, "blindweed", "Herb\\blindweed", { 235, 260, 285, 335 })
InsertObject("herb", { 142144 }, "ghost_mushroom", "Herb\\ghost_mushroom", { 245, 270, 295, 345 })
InsertObject("herb", { 142145, 176637 }, "gromsblood", "Herb\\gromsblood", { 250, 275, 300, 350 })
InsertObject("herb", { 176583, 176638, 180167 }, "golden_sansam", "Herb\\golden_sansam", { 260, 285, 310, 360 })
InsertObject("herb", { 176584, 176639, 180168 }, "dreamfoil", "Herb\\dreamfoil", { 270, 295, 320, 370 })
InsertObject("herb", { 176586, 176640, 180166 }, "mountain_silversage", "Herb\\mountain_silversage",
    { 280, 305, 330, 380 })
InsertObject("herb", { 176587, 176641 }, "plaguebloom", "Herb\\plaguebloom", { 285, 310, 335, 385 })
InsertObject("herb", { 176588 }, "icecap", "Herb\\icecap", { 290, 315, 340, 390 })
InsertObject("herb", { 176589 }, "black_lotus", "Herb\\black_lotus", { 300, 325, 350, 400 })
InsertObject("herb", { 439557 }, "nightmare_moss", "Interface\\Icons\\inv_misc_dust_05", { 125 })
InsertObject("herb", { 439627 }, "dreamroot", "Interface\\Icons\\ability_creature_poison_04", { 205 })
InsertObject("herb", { 439810 }, "moonroot", "Interface\\Icons\\inv_misc_herb_06", { 250 })
InsertObject("herb", { 439762 }, "star_lotus", "Interface\\Icons\\inv_misc_herb_fellotus", { 250 })

-- Containers
InsertObject("container", { 106319, 2843, 106318, 2849 }, "battered_chest", "Open\\Chest", nil)
InsertObject("container", { 75293 }, "large_battered_chest", "Open\\Chest", nil)
InsertObject("container", { 2850, 153453, 153454, 2855, 153451, 2852, 2857, 4149 }, "solid_chest", "Open\\Chest", nil)
InsertObject("container", { 74448, 153464, 75300, 153463, 75299, 75298, 153462, 153461 }, "large_solid_chest",
    "Open\\Chest", nil)
InsertObject("container", { 2744, 19018, 19017 }, "giant_clam", "Open\\Clam", nil)
InsertObject("container", { 157936 }, "ungoro_dirt_pile", "Open\\Soil", nil)

-- Rogue lockpicking practice chests and outdoor training footlockers.
InsertObject("container", { 178244, 178245, 178246 }, "practice_lockbox", "Open\\Chest", nil)
InsertObject("container", { 123330, 123331, 123332, 123333 }, "buccaneers_strongbox", "Open\\Chest", nil)
InsertObject("container", { 179486, 179488, 179490 }, "battered_footlocker", "Open\\Chest", nil)
InsertObject("container", { 179487, 179489, 179491 }, "waterlogged_footlocker", "Open\\Chest", nil)
InsertObject("container", { 179492, 179494, 179496 }, "dented_footlocker", "Open\\Chest", nil)
InsertObject("container", { 179493, 179497 }, "mossy_footlocker", "Open\\Chest", nil)
InsertObject("container", { 179498 }, "scarlet_footlocker", "Open\\Chest", nil)

-- Fishing

-- Forever
InsertObject("fishing", { 180902, 180683, 180657, 180752 }, "battered_chest", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180655 }, "fish_pool_debris", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180685, 180662, 180901, 180751 }, "fish_pool_wreckage", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180750, 180900, 180682, 180664, 180582 }, "fish_pool_oily_blackmouth", "Fish\\Fishhook", nil)
InsertObject("fishing", { 180656, 180663 }, "fish_pool_sagefish", "Fish\\Fishhook", nil)
