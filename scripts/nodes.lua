local name, _GatherLite = ...;

_GatherLite.iconPath = "Interface\\AddOns\\" .. _GatherLite.name .. "\\icons\\"

_GatherLite.nodeDB = {

    -- Ores

    -- Copper
    {
        type = "ore",
        id = { 1731, 2055, 3763, 103713, 103714 },
        name = "copper_vein",
        icon = _GatherLite.iconPath .. "Ore\\Copper",
        levels = { 1, 25, 50, 100 }
    },

    -- Tin
    {
        type = "ore",
        id = { 1732, 3764, 2054, 103711, 103709 },
        name = "tin_vein",
        icon = _GatherLite.iconPath .. "Ore\\Tin",
        levels = { 65, 90, 115, 165 }
    },

    -- Silver
    {
        type = "ore",
        id = { 1733, 105569, 73940 },
        name = "silver_vein",
        icon = _GatherLite.iconPath .. "Ore\\Silver",
        levels = { 75, 100, 125, 175 }
    },

    -- Iron
    {
        type = "ore",
        id = { 1735, 103710, 103712, 73939 },
        name = "iron_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Iron",
        levels = { 125, 150, 175, 225 }
    },

    -- Gold
    {
        type = "ore",
        id = { 1734, 150080, 181109, 73941 },
        name = "gold_vein",
        icon = _GatherLite.iconPath .. "Ore\\Gold",
        levels = { 155, 180, 205, 255 }
    },

    -- Mithril
    {
        type = "ore",
        id = { 2040, 150079, 176645, 123310 },
        name = "mithril_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Mithril",
        levels = { 175, 200, 225, 275 }
    },

    -- Truesilver
    {
        type = "ore",
        id = { 2047, 150081, 181108, 123309 },
        name = "truesilver_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Truesilver",
        levels = { 230, 255, 280, 330 }
    },

    -- Dark Iron
    {
        type = "ore",
        id = { 165658 },
        name = "dark_iron_deposit",
        icon = _GatherLite.iconPath .. "Ore\\DarkIron",
        levels = { 230, 255, 280, 330 }
    },

    -- Small Thorium
    {
        type = "ore",
        id = { 324, 150082, 176643, 123848 },
        name = "small_thorium_vein",
        icon = _GatherLite.iconPath .. "Ore\\Thorium",
        levels = { 245, 270, 295, 345 }
    },

    -- Rich Thorium
    {
        type = "ore",
        id = { 175404, 176644, 177388 },
        name = "rich_thorium_vein",
        icon = _GatherLite.iconPath .. "Ore\\RichThorium",
        levels = { 275, 290, 300, 350 }
    },


    -- The burning crusade

    {
        type = "ore",
        id = { 181555 },
        name = "fel_iron_deposit",
        icon = _GatherLite.iconPath .. "Ore\\FelIron",
        levels = { 300, 325, 350, 400 }
    },

    {
        type = "ore",
        id = { 181556 },
        name = "adamantite_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Adamantite",
        levels = { 325, 350, 375, 425 }
    },

    {
        type = "ore",
        id = { 181569 },
        name = "rich_adamantite_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Adamantite",
        levels = { 350, 375, 400, 450 }
    },


    {
        type = "ore",
        id = { 181557 },
        name = "khorium_vein",
        icon = _GatherLite.iconPath .. "Ore\\Khorium",
        levels = { 375, 400, 425, 475 }
    },

    -- Wrath of the lich king
    {
        type = "ore",
        id = { 189980 },
        name = "saronite_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Saronite",
        levels = { 400, 400, 400, 400 }
    },
    {
        type = "ore",
        id = { 189981 },
        name = "rich_saronite_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Saronite",
        levels = { 425, 425, 425, 425 }
    },
    {
        type = "ore",
        id = { 189978 },
        name = "cobalt_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Cobalt",
        levels = { 350, 400, 400, 400 }
    },

    {
        type = "ore",
        id = { 189979 },
        name = "rich_cobalt_deposit",
        icon = _GatherLite.iconPath .. "Ore\\Cobalt",
        levels = { 375, 400, 400, 400 }
    },

   {
       type = "ore",
         id = {191133},
           name = "titanium_vein",
           icon = _GatherLite.iconPath .. "Ore\\Titanium",
           levels = { 450, 450, 450, 450  }
   },


    -- Herbalism

    {
        type = "herb",
        id = { 1617, 3725 },
        name = "silverleaf",
        icon = _GatherLite.iconPath .. "Herb\\Silverleaf",
        levels = { 1, 25, 50, 100 }
    },
    {
        type = "herb",
        id = { 1618, 3724 },
        name = "peacebloom",
        icon = _GatherLite.iconPath .. "Herb\\Peacebloom",
        levels = { 1, 25, 50, 100 }
    },
    {
        type = "herb",
        id = { 1619, 3726 },
        name = "earthroot",
        icon = _GatherLite.iconPath .. "Herb\\Earthroot",
        levels = { 15, 40, 65, 115 }
    },
    {
        type = "herb",
        id = { 1620, 3727 },
        name = "mageroyal",
        icon = _GatherLite.iconPath .. "Herb\\Mageroyal",
        levels = { 50, 75, 100, 150 }
    },
    {
        type = "herb",
        id = { 1621, 3729 },
        name = "briarthorn",
        icon = _GatherLite.iconPath .. "Herb\\Briarthorn",
        levels = { 70, 95, 120, 170 }
    },
    {
        type = "herb",
        id = { 2045 },
        name = "stranglekelp",
        icon = _GatherLite.iconPath .. "Herb\\Stranglekelp",
        levels = { 85, 110, 135, 185 }
    },
    {
        type = "herb",
        id = { 1622, 3730 },
        name = "bruiseweed",
        icon = _GatherLite.iconPath .. "Herb\\Bruiseweed",
        levels = { 100, 125, 150, 200 }
    },
    {
        type = "herb",
        id = { 1623 },
        name = "wild_steelbloom",
        icon = _GatherLite.iconPath .. "Herb\\WildSteelbloom",
        levels = { 115, 140, 165, 215 }
    },
    {
        type = "herb",
        id = { 1628 },
        name = "grave_moss",
        icon = _GatherLite.iconPath .. "Herb\\GraveMoss",
        levels = { 120, 145, 170, 220 }
    },
    {
        type = "herb",
        id = { 1624 },
        name = "kingsblood",
        icon = _GatherLite.iconPath .. "Herb\\Kingsblood",
        levels = { 125, 150, 175, 225 }
    },
    {
        type = "herb",
        id = { 2041 },
        name = "liferoot",
        icon = _GatherLite.iconPath .. "Herb\\Liferoot",
        levels = { 150, 175, 200, 250 }
    },
    {
        type = "herb",
        id = { 2042 },
        name = "fadeleaf",
        icon = _GatherLite.iconPath .. "Herb\\Fadeleaf",
        levels = { 160, 185, 210, 260 }
    },
    {
        type = "herb",
        id = { 2046 },
        name = "goldthorn",
        icon = _GatherLite.iconPath .. "Herb\\Goldthorn",
        levels = { 170, 195, 220, 270 }
    },
    {
        type = "herb",
        id = { 2043 },
        name = "khadgars_whisker",
        icon = _GatherLite.iconPath .. "Herb\\KhadgarsWhisker",
        levels = { 185, 210, 235, 285 }
    },
    {
        type = "herb",
        id = { 2044 },
        name = "wintersbite",
        icon = _GatherLite.iconPath .. "Herb\\Wintersbite",
        levels = { 195, 220, 245, 295 }
    },
    {
        type = "herb",
        id = { 2866 },
        name = "firebloom",
        icon = _GatherLite.iconPath .. "Herb\\Firebloom",
        levels = { 205, 230, 255, 305 }
    },
    {
        type = "herb",
        id = { 142140, 180165 },
        name = "purple_lotus",
        icon = _GatherLite.iconPath .. "Herb\\PurpleLotus",
        levels = { 210, 235, 260, 310 }
    },
    {
        type = "herb",
        id = { 142141, 176642 },
        name = "arthas_tears",
        icon = _GatherLite.iconPath .. "Herb\\ArthasTears",
        levels = { 220, 245, 270, 320 }
    },
    {
        type = "herb",
        id = { 142142, 176636, 180164 },
        name = "sungrass",
        icon = _GatherLite.iconPath .. "Herb\\Sungrass",
        levels = { 230, 255, 280, 330 }
    },
    {
        type = "herb",
        id = { 142143, 183046 },
        name = "blindweed",
        icon = _GatherLite.iconPath .. "Herb\\Blindweed",
        levels = { 235, 260, 285, 335 }
    },
    {
        type = "herb",
        id = { 142144 },
        name = "ghost_mushroom",
        icon = _GatherLite.iconPath .. "Herb\\GhostMushroom",
        levels = { 245, 270, 295, 345 }
    },
    {
        type = "herb",
        id = { 142145, 176637 },
        name = "gromsblood",
        icon = _GatherLite.iconPath .. "Herb\\Gromsblood",
        levels = { 250, 275, 300, 350 }
    },
    {
        type = "herb",
        id = { 176583, 176638, 180167 },
        name = "golden_sansam",
        icon = _GatherLite.iconPath .. "Herb\\GoldenSansam",
        levels = { 260, 285, 310, 360 }
    },
    {
        type = "herb",
        id = { 176584, 176639, 180168 },
        name = "dreamfoil",
        icon = _GatherLite.iconPath .. "Herb\\Dreamfoil",
        levels = { 270, 295, 320, 370 }
    },
    {
        type = "herb",
        id = { 176586, 176640, 180166 },
        name = "mountain_silversage",
        icon = _GatherLite.iconPath .. "Herb\\MountainSilversage",
        levels = { 280, 305, 330, 380 }
    },
    {
        type = "herb",
        id = { 176587, 176641 },
        name = "plaguebloom",
        icon = _GatherLite.iconPath .. "Herb\\Plaguebloom",
        levels = { 285, 310, 335, 385 }
    },
    {
        type = "herb",
        id = { 176588 },
        name = "icecap",
        icon = _GatherLite.iconPath .. "Herb\\Icecap",
        levels = { 290, 315, 340, 390 }
    },
    {
        type = "herb",
        id = { 176589 },
        name = "black_lotus",
        icon = _GatherLite.iconPath .. "Herb\\BlackLotus",
        levels = { 300, 325, 350, 400 }
    },


    -- TBC Herbs

    {
        type = "herb",
        id = { 181270 },
        name = "felweed",
        icon = _GatherLite.iconPath .. "Herb\\Felweed",
        levels = { 300, 325, 350, 400 }
    },

    {
        type = "herb",
        id = { 181271, 183045 },
        name = "dreaming_glory",
        icon = _GatherLite.iconPath .. "Herb\\DreamingGlory",
        levels = { 315, 340, 365, 415 }
    },

    {
        type = "herb",
        id = { 181275 },
        name = "ragveil",
        icon = _GatherLite.iconPath .. "Herb\\Ragveil",
        levels = { 325, 350, 375, 425 }
    },

    {
        type = "herb",
        id = { 181277 },
        name = "terocone",
        icon = _GatherLite.iconPath .. "Herb\\Terocone",
        levels = { 325, 350, 375, 425 }
    },

    {
        type = "herb",
        id = { 181278 },
        name = "ancient_lichen",
        icon = _GatherLite.iconPath .. "Herb\\AncientLichen",
        levels = { 340, 365, 390, 440 }
    },

    {
        type = "herb",
        id = { 181279 },
        name = "netherbloom",
        icon = _GatherLite.iconPath .. "Herb\\Netherbloom",
        levels = { 350, 375, 400, 450 }
    },

    {
        type = "herb",
        id = { 181280 },
        name = "nightmare_vine",
        icon = _GatherLite.iconPath .. "Herb\\NightmareVine",
        levels = { 365, 390, 415, 465 }
    },

    {
        type = "herb",
        id = { 181281 },
        name = "mana_thistle",
        icon = _GatherLite.iconPath .. "Herb\\ManaThistle",
        levels = { 375, 400, 425, 475 }
    },

    {
        type = "herb",
        id = { 181276 },
        name = "flame_cap",
        icon = _GatherLite.iconPath .. "Herb\\FlameCap",
        levels = { 335, 360, 385, 435 }
    },


    {
        type = "herb",
        id = { 181166 },
        name = "bloodthistle",
        icon = _GatherLite.iconPath .. "Herb\\Stranglekelp",
        levels = { 0, 0, 0, 0 }
    },

    -- WOTLK
    {
        type = "herb",
        id = { 189973 },
        name = "goldclover",
        icon = _GatherLite.iconPath .. "Herb\\GoldClover",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 191303 },
        name = "firethorn",
        icon = _GatherLite.iconPath .. "Herb\\FlameCap",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 190169 },
        name = "tiger_lily",
        icon = _GatherLite.iconPath .. "Herb\\TigerLily",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 190170 },
        name = "talandras_rose",
        icon = _GatherLite.iconPath .. "Herb\\TalandrasRose",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 190173 },
        name = "frozen_herb",
        icon = _GatherLite.iconPath .. "Herb\\FrostLotus",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 191019 },
        name = "adders_tongue",
        icon = _GatherLite.iconPath .. "Herb\\AddersTongue",
        levels = { 335, 360, 385, 435 }
    },

    {
        type = "herb",
        id = { 190171 },
        name = "lichbloom",
        icon = _GatherLite.iconPath .. "Herb\\Lichbloom",
        levels = { 335, 360, 385, 435 }
    },
    {
        type = "herb",
        id = { 190172 },
        name = "icethorn",
        icon = _GatherLite.iconPath .. "Herb\\Icethorn",
        levels = { 335, 360, 385, 435 }
    },




    -- containers
    {
        type = "container",
        id = { 106319, 2843, 106318, 2849 },
        icon = _GatherLite.iconPath .. "Open\\Chest",
        name = "battered_chest"
    },
    {
        type = "container",
        id = { 75293 },
        icon = _GatherLite.iconPath .. "Open\\Chest",
        name = "large_battered_chest"
    },
    {
        type = "container",
        id = { 2850, 153453, 153454, 2855, 153451, 2852, 2857, 4149 },
        icon = _GatherLite.iconPath .. "Open\\Chest",
        name = "solid_chest"
    },
    {
        type = "container",
        id = { 74448, 153464, 75300, 153463, 75299, 75298, 153462, 153461 },
        icon = _GatherLite.iconPath .. "Open\\Chest",
        name = "large_solid_chest"
    },
    {
        type = "container",
        id = { 2744, 19018, 19017 },
        icon = _GatherLite.iconPath .. "Open\\Clam",
        name = "giant_clam"
    },
    {
        type = "container",
        id = { 157936 },
        icon = _GatherLite.iconPath .. "Soil",
        name = "ungoro_dirt_pile"
    },

    -- Fishing
    {
        type = "fishing",
        id = { 180902, 180683, 180657, 180752 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "fish_pool_firefin"
    },
    {
        type = "fishing",
        id = { 180655 },
        icon = _GatherLite.iconPath .. "Fish\\Treasure",
        name = "fish_pool_debris"
    },
    {
        type = "fishing",
        id = { 180685, 180662, 180901, 180751 },
        icon = _GatherLite.iconPath .. "Fish\\Treasure",
        name = "fish_pool_wreckage"
    },
    {
        type = "fishing",
        id = { 180750, 180900, 180682, 180664, 180582 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "fish_pool_oily_blackmouth"
    },
    {
        type = "fishing",
        id = { 180656, 180663 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "fish_pool_sagefish"
    },


-- WOTLK Fishing
    {
        type = "fishing",
        id = { 192046 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "musselback_sculpin_school"
    },
    {
        type = "fishing",
        id = { 192048 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "dragonfin_angelfish_school"
    },
    {
        type = "fishing",
        id = { 192049 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "fangtooth_herring_school"
    },
    {
        type = "fishing",
        id = { 192050 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "glacial_salmon_school"
    },
    {
        type = "fishing",
        id = { 192051 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "borean_man_o_war_school"
    },
    {
        type = "fishing",
        id = { 192052 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "imperial_manta_ray_school"
    },
    {
        type = "fishing",
        id = { 192053 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "deep_sea_monsterbelly_school"
    },
    {
        type = "fishing",
        id = { 192054 },
        icon = _GatherLite.iconPath .. "Fish\\Fishhook",
        name = "moonglow_cuttlefish_school"
    },
     {
         type = "fishing",
         id = { 192057 },
         icon = _GatherLite.iconPath .. "Fish\\Fishhook",
         name = "nettlefish_school"
     },




}
