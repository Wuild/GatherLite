-- Run with Lua 5.1 from the repository root.
local addon = { name = "GatherLite" }
assert(loadfile("scripts/nodes.lua"))("GatherLite", addon)
assert(loadfile("plugins/database/data/forever.lua"))("GatherLite", addon)
local byID, kinds = {}, { ore = "mining", herb = "herbalism", container = "containers", fishing = "fishing" }
for _, object in ipairs(addon.nodeDB) do
    for _, id in ipairs(object.id) do byID[id] = object end
end
local expected, total, saved = {}, 0, nil
for objectID, maps in pairs(addon.predefined) do
    local object = assert(byID[objectID], "uncatalogued predefined object")
    local kind = assert(kinds[object.type])
    for mapID, coords in pairs(maps) do
        assert(type(mapID) == "number" and #coords % 2 == 0, "invalid map/coordinate list")
        for i = 1, #coords, 2 do
            local x, y = coords[i], coords[i + 1]
            assert(type(x) == "number" and x >= 0 and x <= 1 and type(y) == "number" and y >= 0 and y <= 1)
            expected[kind] = (expected[kind] or 0) + 1
            total = total + 1
            if kind == "mining" and not saved then saved = { mapID, x, y, objectID } end
        end
    end
end
assert(total > 25000, "database lost locations")
local loaded, callbacks = {}, {}
local enabled = { mining = true }
local gather = {
    plugins = {}, db = { global = { usePredefined = false } },
    GetNodeObject = function(_, id) return byID[id] end,
    GetNodeTracking = function(_, target, kind) return target == "minimap" and enabled[kind] end,
    FindExistingNode = function(_, kind, map, x, y, objectID)
        assert(objectID, "saved merge must distinguish nearby object IDs")
        return kind == "mining" and map == saved[1] and x == saved[2] and y == saved[3] and objectID == saved[4]
    end,
    On = function(_, event, fn) callbacks[event] = fn end,
    EnsureNodeWorld = function(_, node)
        assert(node.mapID and node.posX and node.posY)
        node.instance = 0
    end,
    LoadTable = function(_, kind, nodes)
        loaded[kind] = loaded[kind] or {}
        for _, node in ipairs(nodes) do
            assert(node.type == kind and node.object and node.mapID and node.predefined)
            assert(rawget(node, "type") == nil and rawget(node, "object") == nil, "metadata must be shared")
            assert(node.loot == nil and node.coins == nil and node.date == nil, "eager history allocated")
            assert(node.instance ~= nil, "resolve instance before indexing")
            loaded[kind][#loaded[kind] + 1] = node
        end
    end,
}
LibStub = function() return { GetAddon = function() return gather end } end
assert(loadfile("plugins/database/database.lua"))("GatherLite", addon)
gather.plugins.Database.setup()
assert(next(loaded) == nil, "disabled database allocated nodes")
gather.db.global.usePredefined = true
callbacks["settings:update"]()
assert(#loaded.mining == expected.mining - 1, "saved point not skipped")
assert(not loaded.herbalism and addon.predefined, "disabled types loaded eagerly")
for id in pairs(addon.predefined) do assert(byID[id].type ~= "ore", "loaded coordinate arrays retained") end
callbacks["settings:update"]()
assert(#loaded.mining == expected.mining - 1, "nodes loaded twice")
enabled.herbalism, enabled.containers, enabled.fishing = true, true, true
callbacks["settings:update"]()
for kind, count in pairs(expected) do
    assert(#loaded[kind] == count - (kind == "mining" and 1 or 0), "missing points for " .. kind)
end
assert(addon.predefined == nil, "compressed database was not released")
callbacks["settings:update"]()
-- Defaults are shared only within an object/map; runtime updates stay local.
local groups, a, b = {}, nil, nil
for _, node in ipairs(loaded.mining) do
    local key = node.object .. ":" .. node.mapID
    if groups[key] then a, b = groups[key], node; break end
    groups[key] = node
end
assert(a and b, "expected multiple points for an object/map")
assert(getmetatable(a) == getmetatable(b), "metadata is allocated per node")
a.predefined = false
assert(b.predefined == true, "promoting one point changed its neighbors")
print("Compact database integration passed: " .. total .. " locations; lazy loading, saved-node merge, metadata sharing")
