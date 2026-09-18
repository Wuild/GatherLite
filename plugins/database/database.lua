local _, addon = ...
local GatherLite = LibStub("AceAddon-3.0"):GetAddon("GatherLite", true)
if not GatherLite then return end

local source = {}
GatherLite.plugins.Database = source
local kinds = { ore = "mining", herb = "herbalism", container = "containers", fishing = "fishing" }

local function loadEnabled()
    if not GatherLite.db.global.usePredefined or not addon.predefined then return end

    for objectID, maps in pairs(addon.predefined) do
        local object = GatherLite:GetNodeObject(objectID)
        local kind = object and kinds[object.type]
        if kind and (GatherLite:GetNodeTracking("minimap", kind) or GatherLite:GetNodeTracking("worldmap", kind)) then
            for mapID, coords in pairs(maps) do
                -- Share immutable metadata across every point on this object/map.
                -- No empty loot tables, coins, dates, or instance IDs in the data.
                local defaults = { __index = { object = objectID, mapID = mapID, type = kind, predefined = true } }
                local nodes = {}
                for i = 1, #coords, 2 do
                    local x, y = coords[i], coords[i + 1]
                    -- A saved gathered node already represents this position.
                    if not GatherLite:FindExistingNode(kind, mapID, x, y, objectID) then
                        local node = setmetatable({ posX = x, posY = y }, defaults)
                        GatherLite:EnsureNodeWorld(node)
                        nodes[#nodes + 1] = node
                    end
                end
                GatherLite:LoadTable(kind, nodes)
            end
            -- Release compressed coordinates once their runtime nodes are indexed.
            addon.predefined[objectID] = nil
        end
    end
    if not next(addon.predefined) then addon.predefined = nil end
end

function source.setup()
    loadEnabled()
    GatherLite:On("settings:update", loadEnabled, true)
end
