local name, _GatherLite = ...;

GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")

_GatherLite.name = name;
_GatherLite.version = GetAddOnMetadata(name, "version");

_GatherLite.configsDefaults = {
    global = {
        nodes = {
            mining = {},
            herbalism = {}
        },
        predefined = true
    },
    char = {
        debugging = false,
        tracking = {
            mining = true,
            herbalism = true
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

_GatherLite.nodes.names = {
    -- Ores
    ["Small Thorium Vein"] = 324,
    ["Incendicite Mineral Vein"] = 1610,
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

    -- Herbs
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
    ["Dragon's Teeth"] = 2044, -- Wintersbite
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
    ["Sorrowmoss"] = 176587, -- Plaguebloom
    ["Plaguebloom"] = 176641, -- Plaguebloom
    ["Icecap"] = 176588,
    ["Black Lotus"] = 176589,
    ["Bloodthistle"] = 181166,
    ["Felweed"] = 181270,
    ["Dreaming Glory"] = 181271,
    ["Ragveil"] = 181275,
    ["Flame Cap"] = 181276,
    ["Terocone"] = 181277,
    ["Ancient Lichen"] = 181278,
    ["Netherbloom"] = 181279,
    ["Nightmare Vine"] = 181280,
    ["Mana Thistle"] = 181281,
    ["Netherdust Bush"] = 185881,
    ["Goldclover"] = 189973,
    ["Tiger Lily"] = 190169,
    ["Talandra's Rose"] = 190170,
    ["Lichbloom"] = 190171,
    ["Icethorn"] = 190172,
    ["Frozen Herb"] = 190175,
    ["Frost Lotus"] = 190176,
    ["Adder's Tongue"] = 191019,
    ["Firethorn"] = 191303,
    ["Cinderbloom"] = 202747,
    ["Stormvine"] = 202748,
    ["Azshara's Veil"] = 202749,
    ["Heartblossom"] = 202750,
    ["Twilight Jasmine"] = 202751,
    ["Whiptail"] = 202752,
};

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