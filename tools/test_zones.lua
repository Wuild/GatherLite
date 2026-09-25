-- Run from the repository root with Lua 5.1.
local addon = { name = "GatherLite" }
local hbd = { mapData = {} }
local function map(id, left, top, width, height, instance, mapType)
    hbd.mapData[id] = { width, height, left, top, instance = instance or 0,
        mapType = mapType or 3, name = "Zone " .. id }
end
map(1, 1000, 1000, 1000, 500)
map(2, 0, 1000, 1000, 500) -- touching west border
map(3, 1000, 480, 1000, 500) -- 20-yard gap south
map(4, 1000, 1000, 1000, 500, 1) -- same rectangle, different instance
map(5, -5000, 1000, 1000, 500) -- distant
map(6, 900, 900, 100, 100) -- overlapping city/micro map
map(7, 10000, 10000, 20000, 20000, 0, 2) -- continent excluded
map(8, 0, 0, 0, 0) -- unavailable geometry
function hbd:GetWorldCoordinatesFromZone(x, y, id)
    local m = self.mapData[id]
    if not m or m[1] == 0 or m[2] == 0 then return end
    return m[3] - x * m[1], m[4] - y * m[2], m.instance
end
function hbd:GetZoneCoordinatesFromWorldInstance(x, y, instance, id, allow)
    local m = self.mapData[id]
    if m.instance ~= instance then return end
    x, y = (m[3] - x) / m[1], (m[4] - y) / m[2]
    if allow or (x >= 0 and x <= 1 and y >= 0 and y <= 1) then return x, y end
end
function hbd:GetZoneSize(id) local m = self.mapData[id]; return m[1], m[2] end
function hbd:GetWorldVector(_, x1, y1, x2, y2) return 0, math.sqrt((x2-x1)^2 + (y2-y1)^2) end
LibStub = function(name)
    if name == "HereBeDragons-2.0" then return hbd end
    if name == "AceLocale-3.0" then return { GetLocale = function() return {} end } end
    return {}
end
GatherLite = {}
assert(loadfile("scripts/methods.lua"))("GatherLite", addon)
assert(loadfile("scripts/maps/zone-neighbors.lua"))("GatherLite", addon)
assert(loadfile("scripts/zones.lua"))("GatherLite", addon)
local tree, count = GatherLite:GetZoneTree(), 0
for id, zone in pairs(tree) do
    count = count + 1
    assert(type(zone.name) == "string" and #zone.name > 0)
    local seen = {}
    for _, neighbor in ipairs(zone.neighbors) do
        assert(neighbor ~= id and not seen[neighbor], "self/duplicate neighbor")
        seen[neighbor] = true
        local other, reciprocal = assert(tree[neighbor], "unknown neighbor ID"), false
        for _, reverse in ipairs(other.neighbors) do if reverse == id then reciprocal = true end end
        assert(reciprocal, "neighbor link must be reciprocal")
    end
end
assert(count == 60, "expected every UI map in build 1.60.1.70009")
assert(addon.zoneTreeBuild == "1.60.1.70009" and addon.zoneTreeRange == 1000)
local function linked(a, b)
    for _, id in ipairs(tree[a].neighbors) do if id == b then return true end end
    return false
end
assert(linked(1427, 1432), "Searing Gorge / Loch Modan rectangle overlap was missing")
assert(linked(1429, 1430), "Elwynn / Deadwind range candidate was missing")
assert(linked(2652, 1456), "Shen'dralas / Thunder Bluff range candidate was missing")
assert(tree[2482].name == "Mount Hyjal", "client map name")
for _, id in ipairs({ 947, 1414, 1415, 1459, 1460, 1461, 1463, 1464, 2524, 2665 }) do
    assert(tree[id] and #tree[id].neighbors == 0, "overview or isolated-instance map")
end
assert(#tree[2521].neighbors == 0, "isolated island must not link boat destinations")
local database = {}
assert(loadfile("plugins/database/data/forever.lua"))("GatherLite", database)
for _, maps in pairs(database.predefined) do
    for id in pairs(maps) do assert(tree[id], "database map missing: " .. id) end
end
-- Synthetic geometry tests exercise queries independently of client map layouts.
addon.zoneTree = {
    [1] = { neighbors = { 2, 3, 4, 6 } },
    [2] = { neighbors = { 1 } },
}
local function node(id, x, y)
    return { mapID = id, posX = x, posY = y, type = "mining", instance = hbd.mapData[id].instance }
end
local own, border, vertical, distant = node(1, .995, .5), node(2, .005, .5), node(1, .5, .95), node(5, .5, .5)
GatherLite:LoadTable("mining", { own, border, vertical, distant, node(4, .995, .5) })
local function contains(nodes, wanted)
    for _, n in ipairs(nodes) do if n == wanted then return true end end
    return false
end
local nodes = GatherLite:GetNearbyZoneNodes("mining", 1, 0, .995, .5, 20)
assert(contains(nodes, own) and contains(nodes, border), "current and neighboring zone nodes returned")
assert(not contains(nodes, distant), "distant nodes excluded")
for _, n in ipairs(nodes) do assert(n.mapID ~= 4, "other instance must be excluded") end
assert(contains(GatherLite:GetNearbyZoneNodes("mining", 2, 0, -.005, .5, 20), own), "reverse border query")
assert(contains(GatherLite:GetNearbyNodes("mining", 1, 0, .5, .90, 30), vertical), "height needs its own cell radius")
local bucket = GatherLite:GetNodesForMap("mining", 1)
local size = #bucket
GatherLite:GetNearbyZoneNodes("mining", 1, 0, .5, .5, 2000)
assert(#bucket == size and #GatherLite:GetNodesForMapInstance("mining", 1, 0) == size, "large query must not mutate index")
assert(#GatherLite:GetNearbyZoneNodes("mining", nil, 0, nil, nil, 20) == 0)
local unknown = node(5, .5, .5)
GatherLite:LoadTable("mining", { unknown })
assert(contains(GatherLite:GetNearbyZoneNodes("mining", 5, 0, .5, .5, 20), unknown), "unlisted map still queries itself")
print("Zone neighbors passed: 60-map coverage, reciprocal links, borders, instances, rectangular maps and index isolation")
local overlap = node(6, .5, .5)
GatherLite:LoadTable("mining", { overlap })
local visible = GatherLite:GetWorldMapNodesForRect("mining", 1, .1, .2, .2, .4)
assert(contains(visible, overlap), "neighbor rectangle must be projected into viewport")
for _, n in ipairs(visible) do assert(n.mapID ~= 4, "world map leaked different instance") end
assert(not contains(GatherLite:GetWorldMapNodesForRect("mining", 1, .7, .8, .2, .4), overlap), "offscreen neighbor returned")
local x, y = GatherLite:ProjectNodeToMap(overlap, 1)
assert(math.abs(x - .15) < .000001 and math.abs(y - .3) < .000001)
assert(overlap.mapID == 6 and overlap.posX == .5, "source node changed during projection")
assert(not GatherLite:ProjectNodeToMap(node(4, .5, .5), 1), "projection must reject another instance")
print("World-map rectangle queries passed")
