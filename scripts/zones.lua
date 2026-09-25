local _, addon = ...
local HBD = LibStub("HereBeDragons-2.0")

function GatherLite:GetZoneTree()
    return addon.zoneTree
end

function GatherLite:GetNearbyZoneNodes(kind, mapID, instanceID, posX, posY, range)
    -- GetNearbyNodes can return an index bucket directly for large radii.
    -- Always copy it before appending neighbors to avoid corrupting that index.
    local current = self:GetNearbyNodes(kind, mapID, instanceID, posX, posY, range)
    local out = {}
    for i = 1, #current do out[i] = current[i] end
    if not mapID or posX == nil or posY == nil or not range then return out end
    local wx, wy, instance = HBD:GetWorldCoordinatesFromZone(posX, posY, mapID)
    if not wx or not wy or instance ~= instanceID then return out end
    local zone = self:GetZoneTree()[mapID]
    if not zone then return out end
    for _, neighbor in ipairs(zone.neighbors) do
        -- Allow positions outside the neighbor's rectangle when near a border.
        local x, y = HBD:GetZoneCoordinatesFromWorldInstance(wx, wy, instanceID, neighbor, true)
        if x and y then
            local nodes = self:GetNearbyNodes(kind, neighbor, instanceID, x, y, range)
            for i = 1, #nodes do out[#out + 1] = nodes[i] end
        end
    end
    return out
end

-- Query the selected map and its static neighbors in the visible rectangle.
-- Preserve each node's original map/coordinates for tooltips and saved history.
function GatherLite:GetWorldMapNodesForRect(kind, mapID, left, right, bottom, top)
    local out = self:GetNodesForMapRect(kind, mapID, left, right, bottom, top)
    local zone = self:GetZoneTree()[mapID]
    if not zone or #zone.neighbors == 0 then return out end
    local wx1, wy1, instance = HBD:GetWorldCoordinatesFromZone(left, bottom, mapID)
    local wx2, wy2 = HBD:GetWorldCoordinatesFromZone(right, top, mapID)
    if not wx1 or not wy1 or not wx2 or not wy2 then return out end
    for _, neighbor in ipairs(zone.neighbors) do
        local x1, y1 = HBD:GetZoneCoordinatesFromWorldInstance(wx1, wy1, instance, neighbor, true)
        local x2, y2 = HBD:GetZoneCoordinatesFromWorldInstance(wx2, wy2, instance, neighbor, true)
        if x1 and y1 and x2 and y2 then
            local nodes = self:GetNodesForMapRect(kind, neighbor, x1, x2, y1, y2)
            for i = 1, #nodes do out[#out + 1] = nodes[i] end
        end
    end
    return out
end

function GatherLite:ProjectNodeToMap(node, mapID)
    if node.mapID == mapID then return node.posX, node.posY end
    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID)
    if not x or not y then return end
    return HBD:GetZoneCoordinatesFromWorldInstance(x, y, instance, mapID)
end
