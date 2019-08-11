local name, GatherLite = ...
local iconPath = "Interface\\AddOns\\" .. name .. "\\Icons\\";
local orePath = iconPath .. "Ore\\";
local herbPath = iconPath .. "Herb\\";
local treasurePath = iconPath .. "Treasure\\";

GatherLite.icons = {
    -- Default icon if selected not exists
    ["default"] = iconPath .. "Ore.tga",

    -- Ore icons
    [GatherLite.locale.CAT_ORE] = {
        ["default"] = iconPath .. "Ore.tga",
        [GatherLite.locale.ORE_COPPER] = orePath .. "Copper.tga",
        [GatherLite.locale.ORE_DARKIRON] = orePath .. "DarkIron.tga",
        [GatherLite.locale.ORE_GOLD] = orePath .. "Gold.tga",
        [GatherLite.locale.ORE_IRON] = orePath .. "Iron.tga",
        [GatherLite.locale.ORE_MITHRIL] = orePath .. "Mithril.tga",
        [GatherLite.locale.ORE_RTHORIUM] = orePath .. "RThorium.tga",
        [GatherLite.locale.ORE_SILVER] = orePath .. "Silver.tga",
        [GatherLite.locale.ORE_THORIUM] = orePath .. "Thorium.tga",
        [GatherLite.locale.ORE_TIN] = orePath .. "Tin.tga",
        [GatherLite.locale.ORE_TRUESILVER] = orePath .. "Truesilver.tga"
    },
    -- Herb icons
    [GatherLite.locale.CAT_HERB] = {
        ["default"] = iconPath .. "Herb.tga",
        [GatherLite.locale.HERB_ARTHASTEAR] = herbPath .. "ArthasTears.tga",
        [GatherLite.locale.HERB_BLACKLOTUS] = herbPath .. "BlackLotus.tga",
        [GatherLite.locale.HERB_BLINDWEED] = herbPath .. "Blindweed.tga",
        [GatherLite.locale.HERB_BRIARTHORN] = herbPath .. "Briarthorn.tga",
        [GatherLite.locale.HERB_BRUISEWEED] = herbPath .. "Bruiseweed.tga",
        [GatherLite.locale.HERB_DREAMFOIL] = herbPath .. "Dreamfoil.tga",
        [GatherLite.locale.HERB_EARTHROOT] = herbPath .. "Earthroot.tga",
        [GatherLite.locale.HERB_FADELEAF] = herbPath .. "Fadeleaf.tga",
        [GatherLite.locale.HERB_FIREBLOOM] = herbPath .. "Firebloom.tga",
        [GatherLite.locale.HERB_GHOSTMUSHROOM] = herbPath .. "GhostMushroom.tga",
        [GatherLite.locale.HERB_GOLDENSANSAM] = herbPath .. "GoldenSansam.tga",
        [GatherLite.locale.HERB_GOLDTHORN] = herbPath .. "Goldthorn.tga",
        [GatherLite.locale.HERB_GRAVEMOSS] = herbPath .. "GraveMoss.tga",
        [GatherLite.locale.HERB_GROMSBLOOD] = herbPath .. "Gromsblood.tga",
        [GatherLite.locale.HERB_ICECAP] = herbPath .. "Icecap.tga",
        [GatherLite.locale.HERB_KHADGARSWHISKER] = herbPath .. "KhadgarsWhisker.tga",
        [GatherLite.locale.HERB_KINGSBLOOD] = herbPath .. "Kingsblood.tga",
        [GatherLite.locale.HERB_LIFEROOT] = herbPath .. "Liferoot.tga",
        [GatherLite.locale.HERB_MAGEROYAL] = herbPath .. "Mageroyal.tga",
        [GatherLite.locale.HERB_MOUNTAINSILVERSAGE] = herbPath .. "MountainSilversage.tga",
        [GatherLite.locale.HERB_PEACEBLOOM] = herbPath .. "Peacebloom.tga",
        [GatherLite.locale.HERB_PLAGUEBLOOM] = herbPath .. "Plaguebloom.tga",
        [GatherLite.locale.HERB_PURPLELOTUS] = herbPath .. "PurpleLotus.tga",
        [GatherLite.locale.HERB_SILVERLEAF] = herbPath .. "Silverleaf.tga",
        [GatherLite.locale.HERB_STRANGLEKELP] = herbPath .. "Stranglekelp.tga",
        [GatherLite.locale.HERB_SUNGRASS] = herbPath .. "Sungrass.tga",
        [GatherLite.locale.HERB_SWIFTTHISTLE] = herbPath .. "Swiftthistle.tga",
        [GatherLite.locale.HERB_WILDSTEELBLOOM] = herbPath .. "WildSteelbloom.tga",
        [GatherLite.locale.HERB_WINTERSBITE] = herbPath .. "Wintersbite.tga"
    },
    [GatherLite.locale.CAT_TREASURE] = {
        ["default"] = treasurePath .. "Chest.tga"
    }
};