local name, _GatherLite = ...;
local GFrame = LibStub("GatherLiteFrame");
local HBD = LibStub("HereBeDragons-2.0");
local worldmapOpen = false;
local worldmapID = nil;

local timeDiff = 0
local checkDiff = 0

GatherLiteTracker = {};

function GatherLiteTracker:OnLoad()
    GatherLite:On("worldmap:update", function()
        GatherLiteTracker:Worldmap();
    end);
end

GatherLiteTracker.WorldmapFilter = function(node)
    if not GatherLite.db.char.worldmap.enabled then
        return false
    end

    -- check if were tracking the type of node
    if not GatherLite.db.char.tracking[node.type] then
        return false
    end

    -- check if were using the predefined database
    if node.predefined and not GatherLite.db.global.usePredefined then
        return false
    end

    -- check if the node type is should be ignored.
    if GatherLite:IsIgnored(node.object) then
        return false
    end
    return true;
end

GatherLiteTracker.MinimapFilter = function(node)
    if not GatherLite.db.char.minimap.enabled then
        return false
    end

    -- check if were tracking the type of node
    if not GatherLite.db.char.tracking[node.type] then
        return false
    end

    -- check if were using the predefined database
    if node.predefined and not GatherLite.db.global.usePredefined then
        return false
    end

    -- check if the node type is should be ignored.
    if GatherLite:IsIgnored(node.object) then
        return false
    end
    return true;
end

function GatherLiteTracker:ClosestNodes(posX, posY, instanceID, maxDist, filter)
    return table.filter(_GatherLite.db, function(node)
        local x, y, _ = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
        local _, distance = HBD:GetWorldVector(instanceID, posX, posY, x, y)
        return distance and distance < maxDist and filter(node);
    end);
end

function GatherLiteTracker:WorldmapNodes(mapID, filter)
    return table.filter(_GatherLite.db, function(node)
        return node.mapID == mapID and filter(node);
    end);
end

table.filter = function(t, filterIter)
    local out = {}

    for k, v in pairs(t) do
        if filterIter(v, k, t) then
            out[k] = v;
        end
    end

    return out
end

function GatherLiteTracker:Minimap(timeDelta, force)

    local updateIcons = false
    local updateNodes = false

    if (force) then
        updateIcons = true
        updateNodes = true
    else
        checkDiff = checkDiff + timeDelta
        timeDiff = timeDiff + timeDelta
        if (checkDiff > 5) then
            updateNodes = true
            checkDiff = 0
            updateIcons = true
            timeDiff = 0

        elseif (timeDiff > 0.5) then
            updateIcons = true
            timeDiff = 0
        end
    end

    if (updateNodes) then
        local x, y, instanceID = HBD:GetPlayerWorldPosition()
        for key, node in pairs(GatherLiteTracker:ClosestNodes(x, y, instanceID, GatherLite.db.char.minimap.range, GatherLiteTracker.MinimapFilter)) do
            if not _GatherLite.db[key].loaded then
                GatherLite:createMinimapNode(_GatherLite.db[key])
                _GatherLite.db[key].loaded = true;
            end
        end
    end

    if (updateIcons or updateNodes) then
        local x, y, instanceID = HBD:GetPlayerWorldPosition()
        GatherLite:forEach(GFrame.usedFrames, function(frame)
            if frame.type == "minimap" and frame.node.loaded then
                if IsInInstance() then
                    frame.node.loaded = false;
                    frame:Unload();
                    return
                end

                local x2, y2, _ = HBD:GetWorldCoordinatesFromZone(frame.node.posX, frame.node.posY, frame.node.mapID);
                local _, distance = HBD:GetWorldVector(instanceID, x, y, x2, y2)

                if not distance then
                    frame.node.loaded = false;
                    frame:Unload();
                    return
                end

                if distance >= GatherLite.db.char.minimap.range then
                    frame.node.loaded = false;
                    frame:Unload();
                    return
                end

                if not GatherLiteTracker.MinimapFilter(frame.node) then
                    frame.node.loaded = false;
                    frame:Unload();
                    return
                end

                if frame.node.type ~= "containers" and frame.node.type ~= "fishing" then
                    if distance < GatherLite.db.char.minimap.distance and frame:IsVisible() then
                        frame:FakeHide();
                    elseif distance >= GatherLite.db.char.minimap.distance and not frame:IsVisible() then
                        frame:FakeShow();
                    end
                end

            elseif frame.type == "minimap" and not frame.node.loaded then
                frame.node.loaded = false;
                frame:Unload();
            end
        end);
        GatherLite:debug(_GatherLite.DEBUG_FRAME, GatherLite:tablelength(GFrame.usedFrames), "used,", GatherLite:tablelength(GFrame.unusedFrames), "unused")
    end
end

function GatherLiteTracker:Worldmap()
    GatherLite:forEach(GFrame.usedFrames, function(frame)
        if frame.type == "worldmap" and frame.node.loadedWorldmap then
            frame.node.loadedWorldmap = false;
            frame:Unload()
        end
    end);

    if worldmapOpen and worldmapID then
        for key, node in pairs(GatherLiteTracker:WorldmapNodes(worldmapID, GatherLiteTracker.WorldmapFilter)) do
            _GatherLite.db[key].loadedWorldmap = true
            GatherLite:createWorldmapNode(_GatherLite.db[key])
        end
    end
end

function GatherLiteTracker:OnUpdate(timeDelta)
    if _GatherLite.WorldmapOpen and not worldmapOpen then
        worldmapOpen = true;
    elseif not _GatherLite.WorldmapOpen and worldmapOpen then
        worldmapOpen = false;
        worldmapID = nil;
        GatherLite:Trigger("worldmap:update")
    end

    if worldmapOpen then
        if worldmapID ~= WorldMapFrame.mapID then
            worldmapID = WorldMapFrame.mapID;
            GatherLite:Trigger("worldmap:update")
        end
    end
    GatherLiteTracker:Minimap(timeDelta)
end