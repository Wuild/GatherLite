-- Grouping, map isolation, and gathering-history aggregation without a WoW client.
local addon = { name = "GatherLite" }
local locale, frames = {}, { usedFrames = {} }
local libraries = {
    ["AceLocale-3.0"] = { NewLocale = function() return locale end, GetLocale = function() return locale end },
    ["GatherLiteFrame"] = frames,
    ["HereBeDragons-2.0"] = {}, ["HereBeDragons-Pins-2.0"] = {}, Semver = {},
}
LibStub = function(name) return assert(libraries[name], name) end
GatherLite = { db = { char = { worldmap = { loot = true }, minimap = { loot = false } } } }
date, time = os.date, os.time
for _, path in ipairs({ "scripts/locales/enUS.lua", "scripts/nodes.lua", "scripts/methods.lua" }) do
    assert(loadfile(path))("GatherLite", addon)
end
local lines = {}
GameTooltip = {
    SetOwner = function() end, ClearLines = function() lines = {} end, Show = function() end,
    AddLine = function(_, text, r, g, b) lines[#lines + 1] = { text, nil, r, g, b } end,
    AddDoubleLine = function(_, left, right) lines[#lines + 1] = { left, right } end,
}
local function node(id, kind, x, map)
    return { object = id, type = kind, posX = x, posY = 0.5, mapID = map or 1429 }
end
local copper = node(1731, "mining", 0.5)
local alias = node(2055, "mining", 0.501)
local chest = node(106319, "containers", 0.502)
local elsewhere = node(1617, "herbalism", 0.5, 1431)
local hovered = { type = "worldmap", node = copper }
frames.usedFrames = { hovered, { type = "worldmap", node = alias }, { type = "worldmap", node = chest },
    { type = "worldmap", node = copper }, { type = "worldmap", node = elsewhere } }
local oreLink = "|Hitem:2770|h[Copper Ore]|h"
local history = { loot = { { link = oreLink, count = 3 } }, date = { year = 2026, month = 9, day = 18, hour = 12 } }
GatherLite.FindExistingNode = function(_, kind) return kind == "mining" and history or nil end
GatherLite:showTooltip(hovered)
assert(lines[1][1] == "3 nearby nodes", "duplicate frames or another map inflated the count")
assert(lines[3][1]:find("Copper Vein", 1, true) and lines[3][2] == "×2", "aliases must share one hovered row")
assert(lines[4][1]:find(oreLink, 1, true) and lines[4][2] == "x3", "shared saved history was counted twice")
assert(lines[5][1]:find("Last visit:", 1, true), "gathering history was lost")
assert(lines[6][1]:find("Battered chest", 1, true) and lines[6][2] == "×1", "mixed categories were merged")
assert(#lines == 6, "grouped tooltip repeated a profession or node heading")

local otherHistory = { loot = { { link = oreLink, count = 5 } }, date = { year = 2026, month = 9, day = 19, hour = 12 } }
GatherLite.FindExistingNode = function(_, kind, _, x)
    if kind == "mining" then return x == copper.posX and history or otherHistory end
end
GatherLite:showTooltip(hovered)
assert(lines[4][2] == "x8", "distinct gathering histories must be combined")
assert(lines[5][2] == date(nil, time(otherHistory.date)), "latest visit was not selected")
GatherLite.db.char.worldmap.loot = false
GatherLite:showTooltip(hovered)
for _, line in ipairs(lines) do assert(not line[1]:find(oreLink, 1, true), "disabled loot setting ignored") end

hovered.node = chest
GatherLite:showTooltip(hovered)
assert(lines[3][1]:find("Battered chest", 1, true), "hovered type must come first")
hovered.node = copper
frames.usedFrames = { hovered }
GatherLite:showTooltip(hovered)
assert(lines[1][1]:find("Copper Vein", 1, true) and lines[2][1] == "Mining", "single node lost its detailed tooltip")
assert(lines[2][3] == 0.6 and lines[2][4] == 0.6 and lines[2][5] == 0.6, "profession color must use numeric RGB")
print("Tooltip checks passed: grouping, aliases, counts, map isolation, loot, latest visit and single nodes")
