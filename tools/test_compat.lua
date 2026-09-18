-- Run from the repository root with Lua 5.1: lua tools/test_compat.lua
local tests = 0
local function check(value, message)
    assert(value, message)
    tests = tests + 1
end

local addon = { name = "GatherLite", version = "test", DEBUG_NODE = 2 }
assert(loadfile("scripts/compat.lua"))("GatherLite", addon)
local API = addon.API
local secret = setmetatable({}, {
    __tostring = function() error("secret inspected") end,
    __index = function() error("secret inspected") end,
    __concat = function() error("secret inspected") end,
})
issecretvalue = function(value) return rawequal(value, secret) end

local spellNames = { [2575] = "Mining", [2576] = "Mining", [2366] = "Herbalism", [3365] = "Opening", [1804] = "Pick Lock" }
C_Spell = { GetSpellName = function(id) return spellNames[id] end }
check(API.GetSpellName(2575) == "Mining", "modern spell API")
check(API.GetSpellName(secret) == nil, "restricted spell ignored")

C_SkillInfo = {
    GetNumSkillLines = function() return 2 end,
    GetSkillLineInfo = function(i)
        if i == 1 then return { name = "Professions", isHeader = true } end
        return { name = "Mining", rank = 50, modifier = 5 }
    end,
}
check(API.GetProfessionLevel("MINING") == 55, "Forever skill rank plus modifier")
C_SkillInfo.GetSkillLineInfoByID = function(id)
    if id == 182 then return { name = "Herbalism", rank = 75, modifier = 15 } end
end
check(API.GetProfessionLevel("Herbalism") == 90, "collapsed profession by ID")
check(API.GetProfessionLevel(secret) == 0, "restricted profession ignored")
C_SkillInfo = nil
check(API.GetProfessionLevel("Mining") == 0, "missing skill API")

local position = { 0.5, 0.5, 1429 }
local HBD = {
    GetPlayerZonePosition = function() return unpack(position) end,
    GetWorldCoordinatesFromZone = function(_, x, y) return x * 1000, y * 1000, 0 end,
}
local locale = {}
local libraries = {
    ["HereBeDragons-2.0"] = HBD,
    ["HereBeDragons-Pins-2.0"] = {},
    ["GatherLiteFrame"] = {},
    ["Semver"] = {},
    ["AceLocale-3.0"] = { GetLocale = function() return locale end, NewLocale = function() return locale end },
    ["LibDataBroker-1.1"] = { NewDataObject = function(_, _, obj) return obj end },
}
LibStub = function(name) return assert(libraries[name], name) end
CreateFrame = function() return {} end
GatherLite = { db = { global = { nodes = { mining = {}, herbalism = {}, containers = {}, fishing = {} } } } }
GatherLite.SendMessage = function() end
UIDropDownMenu_Initialize = function() end
assert(loadfile("scripts/locales/enUS.lua"))("GatherLite", addon)
assert(loadfile("scripts/nodes.lua"))("GatherLite", addon)
C_Spell = nil
assert(loadfile("scripts/methods.lua"))("GatherLite", addon)
assert(loadfile("scripts/main.lua"))("GatherLite", addon)
check(true, "addon methods load without any spell lookup API")
C_Spell = { GetSpellName = function(id) return spellNames[id] end }
check(GatherLite:findSpellType(2575) == "mining", "direct spell ID")
check(GatherLite:findSpellType(2576) == "mining", "higher gathering rank")
check(GatherLite:findSpellType(999) == nil, "uncached spell name")
check(GatherLite:findSpellType(secret) == nil, "restricted event spell")

local now, inInstance, lootItems = 100, false, 0
GetTime = function() return now end
IsInInstance = function() return inInstance end
date = os.date
GetNumLootItems = function() return lootItems end
GetLootSlotInfo = function() return 1, "Copper Ore", 2, nil, 1, false, false end
GetLootSlotType = function() return 1 end
GetLootSlotLink = function() return "item:2770" end
local function event(name, ...) GatherLite:EventHandler(name, ...) end
local function sent(guid) event("UNIT_SPELLCAST_SENT", "player", "Copper Vein", guid, 2575) end
local function succeeded(guid) event("UNIT_SPELLCAST_SUCCEEDED", "player", guid, 2575) end
local function count() return #GatherLite.db.global.nodes.mining end
sent("cast1")
check(count() == 0, "cast start does not record")
event("UNIT_SPELLCAST_SUCCEEDED", "party1", "cast1", 2575)
check(count() == 0, "another unit cannot finish cast")
succeeded("unrelated")
check(count() == 0, "unrelated cast cannot finish gathering")
event("UNIT_SPELLCAST_FAILED", "party1", "cast1", 2575)
succeeded("cast1")
check(count() == 1, "matching successful player cast records")
local node = GatherLite.db.global.nodes.mining[1]
check(#node.loot == 0, "loot is not read before LOOT_OPENED")
lootItems = 1
event("LOOT_OPENED")
check(#node.loot == 1 and node.loot[1].count == 2, "loot recorded once")
event("LOOT_OPENED")
check(node.loot[1].count == 2, "tracker consumed after loot")

position = { 0.6, 0.6, 1429 }
sent("cast2")
event("UNIT_SPELLCAST_INTERRUPTED", "player", "cast2", 2575)
succeeded("cast2")
check(count() == 1, "interrupted gathering is not recorded")
sent("cast3")
event("UNIT_SPELLCAST_FAILED", "player", "cast3", 2575)
succeeded("cast3")
check(count() == 1, "failed gathering is not recorded")
sent("cast4")
event("UNIT_SPELLCAST_SENT", "player", secret, "cast5", 2575)
succeeded("cast4")
check(count() == 1, "restricted new cast clears stale gathering")
event("UNIT_SPELLCAST_SENT", secret, secret, secret, secret)
event("UNIT_SPELLCAST_SENT", "player", "Copper Vein", secret, secret)
check(count() == 1, "restricted payloads ignored")
position = {}
sent("cast6")
succeeded("cast6")
check(count() == 1, "missing map position ignored")
position = { 0.6, 0.6, 1429 }
inInstance = true
sent("cast7")
succeeded("cast7")
check(count() == 1, "instance gathering ignored")
inInstance = false

-- The seventh loot field is the quest flag; the sixth is the lock flag.
GetLootSlotInfo = function() return 1, "Quest Ore", 1, nil, 1, false, true end
sent("cast8")
succeeded("cast8")
event("LOOT_OPENED")
check(#GatherLite.db.global.nodes.mining[2].loot == 0, "quest loot skipped")

-- Loot stays attached to the gathering location if the player moves before it opens.
GetLootSlotInfo = function() return 1, "Copper Ore", 2, nil, 1, false, false end
position = { 0.7, 0.7, 1429 }
sent("cast9")
succeeded("cast9")
position = { 0.8, 0.8, 1429 }
event("LOOT_OPENED")
check(GatherLite.db.global.nodes.mining[3].loot[1].count == 2, "loot uses captured position")
sent("cast10")
succeeded("cast10")
now = now + 2
event("LOOT_OPENED")
check(#GatherLite.db.global.nodes.mining[4].loot == 0, "expired gathering does not collect unrelated loot")

local tooltipText, skillText = secret, "Mining"
GameTooltip = { NumLines = function() return 2 end }
GameTooltipTextLeft1 = { GetText = function() return tooltipText end }
GameTooltipTextLeft2 = {
    GetText = function() return skillText end,
    SetText = function(_, text) skillText = text end,
    SetTextColor = function() end,
}
GatherLite.ModifyTooltip()
check(skillText == "Mining", "restricted tooltip title ignored")
tooltipText, skillText = "Copper Vein", secret
GatherLite.ModifyTooltip()
check(rawequal(skillText, secret), "restricted tooltip skill ignored")
skillText = "Mining"
GatherLite.ModifyTooltip()
check(skillText == "Mining 1", "gathering requirement displayed")
GatherLite.ModifyTooltip()
check(skillText == "Mining 1", "tooltip update is idempotent")
local changedColor = false
GameTooltipTextLeft2.SetTextColor = function() changedColor = true end
C_SkillInfo = {
    GetNumSkillLines = function() return 0 end,
    GetSkillLineInfo = function() end,
    GetSkillLineInfoByID = function() return { name = "Mining", rank = 300 } end,
}
tooltipText, skillText = "Cold Iron Deposit", "Mining"
GatherLite.ModifyTooltip()
check(skillText == "Mining 125" and not changedColor, "unknown skill-up tiers preserve native tooltip color")
C_SkillInfo = nil
tooltipText, skillText = "Cold Iron Deposit", "Mining"
GatherLite.ModifyTooltip()
check(changedColor, "below minimum gathering skill still turns red")
check(GatherLite:GetObject("Cold Iron Deposit").icon == "Interface\\Icons\\inv_ore_mithril_01", "native icon path is not prefixed with addon path")
local newOres = { [439558] = "Cold Iron Deposit", [439628] = "Fool's Gold Vein",
    [439778] = "Starsilver Vein", [439815] = "Greater Moonstone Formation" }
local newHerbs = { [439557] = "Nightmare Moss", [439627] = "Dreamroot",
    [439810] = "Moonroot", [439762] = "Star Lotus" }
for _, group in ipairs({ newOres, newHerbs }) do
    for id, title in pairs(group) do
        check(GatherLite:GetObject(title).id[1] == id, "new object recognized by gathering name: " .. title)
    end
end
event("UNIT_SPELLCAST_SENT", "player", "Cold Iron Deposit", "newOre", 2575)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "newOre", 2575)
check(GatherLite:FindExistingNode("mining", 1429, 0.8, 0.8, 439558) ~= nil, "new ore recorded after successful gathering")
event("UNIT_SPELLCAST_SENT", "player", "Nightmare Moss", "newHerb", 2366)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "newHerb", 2366)
check(GatherLite:FindExistingNode("herbalism", 1429, 0.8, 0.8, 439557) ~= nil, "new herb recorded after successful gathering")
GameTooltip.IsForbidden = function() return true end
GameTooltipTextLeft1.GetText = function() error("forbidden tooltip accessed") end
GatherLite.ModifyTooltip()
check(true, "forbidden tooltip ignored")

local metadata = { __index = { type = "mining", object = 1731, mapID = 1429, predefined = true } }
local compactNode = setmetatable({ posX = 0.95, posY = 0.95 }, metadata)
GatherLite:LoadTable("mining", { compactNode })
local runtimeCount = #addon.nodes.mining
local savedCount = count()
GatherLite:RegisterNode("mining", 1731, 1429, 0.95, 0.95)
GatherLite:UpdateNode("mining", 1731, 1429, 0.95, 0.95)
local history = GatherLite:FindExistingNode("mining", 1429, 0.95, 0.95)
check(count() == savedCount + 1 and #addon.nodes.mining == runtimeCount, "gathered predefined pin saved without duplicate runtime pin")
check(history.loot[1].count == 2 and history.date, "compact pin loot and visit persisted")
check(getmetatable(history) == nil and history.object == 1731, "saved record has explicit metadata")
check(not compactNode.predefined and metadata.__index.predefined, "gathered pin remains visible with predefined hidden")
GatherLite:RegisterNode("mining", 1731, 1429, 0.95, 0.95)
check(count() == savedCount + 1, "gathering same predefined pin twice does not duplicate history")
GatherLite:RegisterNode("mining", 1733, 1429, 0.95, 0.95)
check(count() == savedCount + 2, "different ore at same position keeps its own history")
check(GatherLite:FindExistingNode("mining", 1429, 0.95, 0.95, 1733).object == 1733, "saved spatial index distinguishes object IDs")
-- World-object lockpicking records a pin even when a practice chest has no loot.
position = { 0.2, 0.2, 1433 }
local chests = GatherLite.db.global.nodes.containers
local chestCount = #chests
check(GatherLite:findSpellType(1804) == "containers", "Pick Lock is a container interaction")
event("UNIT_SPELLCAST_SENT", "player", "Practice Lockbox", "pick1", 1804)
check(#chests == chestCount, "starting lockpicking does not record the chest")
event("UNIT_SPELLCAST_FAILED", "player", "pick1", 1804)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "pick1", 1804)
check(#chests == chestCount, "failed lockpicking does not create a pin")
event("UNIT_SPELLCAST_SENT", "player", "Practice Lockbox", "pick2", 1804)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "pick2", 1804)
check(#chests == chestCount + 1 and chests[#chests].object == 178244, "successful practice lock recorded by canonical object ID")
GetNumLootItems = function() return 0 end
event("LOOT_OPENED")
check(#chests[#chests].loot == 0, "empty training chest remains valid history")
event("UNIT_SPELLCAST_SENT", "player", "Practice Lockbox", "open1", 3365)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "open1", 3365)
check(#chests == chestCount + 1, "opening an unlocked training chest does not duplicate its pin")
event("UNIT_SPELLCAST_SENT", "player", "Iron Lockbox", "inventory1", 1804)
event("UNIT_SPELLCAST_SUCCEEDED", "player", "inventory1", 1804)
check(#chests == chestCount + 1, "inventory lockboxes are not mapped as world objects")
for _, id in ipairs({ 178244, 178245, 178246, 123330, 123331, 123332, 123333,
    179486, 179488, 179490, 179487, 179489, 179491, 179492, 179494, 179496, 179493, 179497, 179498 }) do
    check(GatherLite:GetNodeObject(id).type == "container", "training chest alias has a container definition")
end
print("Passed " .. tests .. " Forever checks")
