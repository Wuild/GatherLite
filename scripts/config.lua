local name, _GatherLite = ...;

GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")

_GatherLite.name = name;
_GatherLite.version = GetAddOnMetadata(name, "version");

_GatherLite.DEBUG_DEFAULT = 1;
_GatherLite.DEBUG_NODE = 2;
_GatherLite.DEBUG_FRAME = 3;
_GatherLite.DEBUG_P2P = 4;

_GatherLite.debug = {
    [_GatherLite.DEBUG_DEFAULT] = "default",
    [_GatherLite.DEBUG_NODE] = "node",
    [_GatherLite.DEBUG_FRAME] = "frame",
    [_GatherLite.DEBUG_P2P] = "p2p",
}

_GatherLite.configsDefaults = {
    global = {
        nodes = {
            mining = {},
            herbalism = {}
        },
        usePredefined = true,
        debug = {
            enabled = false,
            types = {
                [_GatherLite.DEBUG_DEFAULT] = true,
                [_GatherLite.DEBUG_NODE] = false,
                [_GatherLite.DEBUG_FRAME] = true,
                [_GatherLite.DEBUG_P2P] = false
            }
        },
    },
    char = {
        debugging = false,
        ignoreOres = {},
        ignoreHerbs = {},
        tracking = {
            mining = true,
            herbalism = true,
        },
        minimap = {
            enabled = true,
            hide = false,
            size = 12,
            opacity = 1,
            distance = 70,
            loot = true,
            edge = false,
            neighbors = true
        },
        worldmap = {
            enabled = true,
            size = 12,
            opacity = 1,
            loot = true,
            neighbors = true,
            continent = false
        },
        p2p = {
            guild = true
        }
    },
    profile = {
        minimap = {
            hide = false
        }
    }
}

_GatherLite.nodes = {};

_GatherLite.skillLevels = {

    -- ores
    [1731] = 1,
    [1732] = 65,
    [1610] = 65,
    [1733] = 75,
    [1735] = 125,
    [19903] = 150,
    [2653] = 155,
    [1734] = 155,
    [2040] = 175,
    [2047] = 230,
    [123309] = 230,
    [324] = 245,
    [175404] = 275,

    [1617] = 1,
    [1618] = 1,
    [1619] = 15,
    [1620] = 50,
    [1621] = 70,
    [2045] = 85,
    [1622] = 100,
    [1623] = 115,
    [1628] = 120,
    [1624] = 125,
    [2041] = 150,
    [2042] = 160,
    [2046] = 170,
    [2043] = 185,
    [2044] = 195,
    [2866] = 205,
    [142140] = 210,
    [142141] = 220,
    [142142] = 230,
    [142143] = 235,
    [142144] = 245,
    [142145] = 250,
    [176583] = 260,
    [176584] = 270,
    [176586] = 280,
    [176641] = 285,
    [176588] = 290,
    [176589] = 300,
}

_GatherLite.ores = {
    ["Copper Vein"] = 1731,
    ["Tin Vein"] = 1732,
    ["Silver Vein"] = 1733,
    ["Gold Vein"] = 1734,
    ["Iron Deposit"] = 1735,
    ["Mithril Deposit"] = 2040,
    ["Truesilver Deposit"] = 2047,
    ["Lesser Bloodstone Deposit"] = 2653,
    ["Indurium Mineral Vein"] = 19903,
    ["Ooze Covered Silver Vein"] = 73940,
    ["Ooze Covered Gold Vein"] = 73941,
    ["Ooze Covered Truesilver Deposit"] = 123309,
    ["Ooze Covered Mithril Deposit"] = 123310,
    ["Dark Iron Deposit"] = 165658,
    ["Rich Thorium Vein"] = 175404,
    ["Ooze Covered Rich Thorium Vein"] = 177388,
    ["Small Thorium Vein"] = 324,
    ["Incendicite Mineral Vein"] = 1610,
}

_GatherLite.herbs = {
    ["Silverleaf"] = 1617,
    ["Peacebloom"] = 1618,
    ["Earthroot"] = 1619,
    ["Mageroyal"] = 1620,
    ["Briarthorn"] = 1621,
    ["Bruiseweed"] = 1622,
    ["Wild Steelbloom"] = 1623,
    ["Kingsblood"] = 1624,
    ["Grave Moss"] = 1628,
    ["Liferoot"] = 2041,
    ["Fadeleaf"] = 2042,
    ["Khadgar's Whisker"] = 2043,
    ["Wintersbite"] = 2044,
    ["Stranglekelp"] = 2045,
    ["Goldthorn"] = 2046,
    ["Firebloom"] = 2866,
    ["Purple Lotus"] = 142140,
    ["Arthas' Tears"] = 142141,
    ["Sungrass"] = 142142,
    ["Blindweed"] = 142143,
    ["Ghost Mushroom"] = 142144,
    ["Gromsblood"] = 142145,
    ["Golden Sansam"] = 176583,
    ["Dreamfoil"] = 176584,
    ["Mountain Silversage"] = 176586,
    ["Sorrowmoss"] = 176587,
    ["Plaguebloom"] = 176641,
    ["Icecap"] = 176588,
    ["Black Lotus"] = 176589
}

_GatherLite.nodes.names = {};

for name, id in pairs(_GatherLite.ores) do
    _GatherLite.nodes.names[name] = id
end

for name, id in pairs(_GatherLite.herbs) do
    _GatherLite.nodes.names[name] = id
end

_GatherLite.nodes.icons = {
    -- Ores
    [324] = "Ore\\Thorium", -- Small Thorium Vein
    [1731] = "Ore\\Copper", -- Copper Vein
    [1732] = "Ore\\Tin", -- Tin Vein
    [1733] = "Ore\\Silver", -- Silver Vein
    [1734] = "Ore\\Gold", -- Gold Vein
    [1735] = "Ore\\Iron", -- Iron Deposit
    [2040] = "Ore\\Mithril", -- Mithril Deposit
    [2047] = "Ore\\TrueSilver", -- Truesilver Deposit
    [2653] = "Ore\\LesserBloodstone", -- Lesser Bloodstone Deposit
    [73940] = "Ore\\Silver", -- Ooze Covered Silver Vein
    [73941] = "Ore\\Gold", -- Ooze Covered Gold Vein
    [123309] = "Ore\\TrueSilver", -- Ooze Covered Truesilver Deposit
    [123310] = "Ore\\Mithril", -- Ooze Covered Mithril Deposit
    [123848] = "Ore\\Thorium", -- Ooze Covered Thorium Vein
    [165658] = "Ore\\DarkIron", -- Dark Iron Deposit
    [175404] = "Ore\\RichThorium", -- Rich Thorium Vein
    [177388] = "Ore\\RichThorium", -- Ooze Covered Rich Thorium Vein

    -- Herbs
    [1617] = "Herb\\Silverleaf", -- Silverleaf
    [1618] = "Herb\\Peacebloom", -- Peacebloom
    [1619] = "Herb\\Earthroot", -- Earthroot
    [1620] = "Herb\\Mageroyal", -- Mageroyal
    [1621] = "Herb\\Briarthorn", -- Briarthorn
    [1622] = "Herb\\Bruiseweed", -- Bruiseweed
    [1623] = "Herb\\WildSteelbloom", -- Wild Steelbloom
    [1624] = "Herb\\Kingsblood", -- Kingsblood
    [1628] = "Herb\\GraveMoss", -- Grave Moss
    [2041] = "Herb\\Liferoot", -- Liferoot
    [2042] = "Herb\\Fadeleaf", -- Fadeleaf
    [2043] = "Herb\\KhadgarsWhisker", -- Khadgar's Whisker
    [2044] = "Herb\\Wintersbite", -- Wintersbite
    [2045] = "Herb\\Stranglekelp", -- Stranglekelp
    [2046] = "Herb\\Goldthorn", -- Goldthorn
    [2866] = "Herb\\Firebloom", -- Firebloom
    [142140] = "Herb\\PurpleLotus", -- Purple Lotus
    [142141] = "Herb\\ArthasTears", -- Arthas' Tears
    [142142] = "Herb\\Sungrass", -- Sungrass
    [142143] = "Herb\\Blindweed", -- Blindweed
    [142144] = "Herb\\GhostMushroom", -- Ghost Mushroom
    [142145] = "Herb\\Gromsblood", -- Gromsblood
    [176583] = "Herb\\GoldenSansam", -- Golden Sansam
    [176584] = "Herb\\Dreamfoil", -- Dreamfoil
    [176586] = "Herb\\MountainSilversage", -- Mountain Silversage
    [176587] = "Herb\\Plaguebloom", -- Plaguebloom
    [176588] = "Herb\\Icecap", -- Icecap
    [176589] = "Herb\\BlackLotus", -- Black Lotus
    [181166] = "Herb\\Stranglekelp", -- Bloodthistle
    [181270] = "Herb\\Felweed", -- Felweed
    [181271] = "Herb\\DreamingGlory", -- Dreaming Glory
    [181275] = "Herb\\Ragveil", -- Ragveil
    [181276] = "Herb\\FlameCap", -- Flame Cap
    [181277] = "Herb\\Terocone", -- Terocone
    [181278] = "Herb\\AncientLichen", -- Ancient Lichen
    [181279] = "Herb\\Netherbloom", -- Netherbloom
    [181280] = "Herb\\NightmareVine", -- Nightmare Vine
    [181281] = "Herb\\ManaThistle", -- Mana Thistle
    [185881] = "Herb\\Netherdust", -- Netherdust Bush
    [189973] = "Herb\\GoldClover", -- Goldclover
    [190169] = "Herb\\TigerLily", -- Tiger Lily
    [190170] = "Herb\\TalandrasRose", -- Talandra's Rose
    [190171] = "Herb\\LichBloom", -- Lichbloom
    [190172] = "Herb\\IceThorn", -- Icethorn
    [190175] = "Herb\\Icecap", -- Frozen Herb
    [190176] = "Herb\\FrostLotus", -- Frost Lotus
    [191019] = "Herb\\AddersTongue", -- Adder's Tongue
}