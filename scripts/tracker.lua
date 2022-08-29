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
    if node.predefined then
        if not GatherLite.db.global.usePredefined then
            return false
        end
    end

    -- check if the node type is should be ignored.
    if GatherLite:IsIgnored(node.object) then
        return false
    end

    return true;
end

function GatherLiteTracker:ClosestNodes(type, posX, posY, instanceID, maxDist, filter)

    local t = table.filter(_GatherLite.nodes[type], function(node)

        if node.instance ~= instanceID then
            return false
        end

        if not filter(node) then
            return false
        end

        local x, y, _ = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
        local _, distance = HBD:GetWorldVector(instanceID, posX, posY, x, y)

        return distance and distance < maxDist;
    end)

    return t;
end

function GatherLiteTracker:WorldmapNodes(list, mapID, filter)
    return table.filter(list, function(node)
        return node.mapID == mapID and filter(node);
    end);
end

table.iFilter = function(t, filterIter)
    local out = {}

    for k, v in ipairs(t) do
        if filterIter(v, k, t) then
            out[k] = v;
        end
    end

    return out
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

table.length = function(T)
    local count = 0
    if T then
        for _ in pairs(T) do
            count = count + 1
        end
    end
    return count
end

local function createNodeThread(type)
    local x, y, instanceID = HBD:GetPlayerWorldPosition()

    local t = GatherLiteTracker:ClosestNodes(type, x, y, instanceID, GatherLite.db.char.minimap.range, GatherLiteTracker.MinimapFilter);

    for key, node in pairs(t) do
        if not _GatherLite.nodes[type][key].loaded then
            GatherLite:createMinimapNode(_GatherLite.nodes[type][key])
            _GatherLite.nodes[type][key].loaded = true;
        end
        --print(key)
        coroutine.yield()
    end
end

local function miningThread()
    createNodeThread("mining")
end

local function herbalismThread()
    createNodeThread("herbalism")
end

local function containerThread()
    createNodeThread("containers")
end

local function fishingThread()
    createNodeThread("fishing")
end

local function minimapIconThread()
    local x, y, instanceID = HBD:GetPlayerWorldPosition()

    local i = 0;
    local i2 = 0

    local frames = table.filter(GFrame.usedFrames, function(frame)
        return frame.type == "minimap"
    end);

    local tableCount = table.length(frames);

    for key, frame in pairs(frames) do

        if IsInInstance() then
            frame.node.loaded = false;
            frame:Unload();
            return
        end

        local x2, y2, _ = HBD:GetWorldCoordinatesFromZone(frame.node.posX, frame.node.posY, frame.node.mapID);
        local _, distance = HBD:GetWorldVector(instanceID, x, y, x2, y2)

        --if not distance then
        --    frame.node.loaded = false;
        --    frame:Unload();
        --    return
        --end
        --
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

        if distance < GatherLite.db.char.minimap.distance and frame:IsVisible() then
            frame:FakeHide();
        elseif distance >= GatherLite.db.char.minimap.distance and not frame:IsVisible() then
            frame:FakeShow();
        end

        --if (i < tableCount) then
        --    if (i2 == 10) then
        --        coroutine.yield()
        --        i2 = 0
        --    end
        --end
    end

    --for key, iframe in ipairs(GFrame.usedFrames) do
    --    local frame = GFrame.usedFrames[key]

    --    if frame.type == "minimap" then

    --    --

    --    --

    --    --

    --    --
    --    --elseif frame.type == "minimap" and not frame.node.loaded then
    --    --    frame.node.loaded = false;
    --    --    frame:Unload();
    --    --end
    --    --
    --    --i = i + 1
    --    --i2 = i2 + 1
    --    --
    --    ----GatherLite:print(i, i2, tableCount)
    --    --

    --
    --end
end

local threadMining = coroutine.create(miningThread)
local threadHerbalism = coroutine.create(herbalismThread)
local threadContainer = coroutine.create(containerThread)
local threadFishing = coroutine.create(fishingThread)

local threadIcon = coroutine.create(minimapIconThread)

function GatherLiteTracker:Minimap(timeDelta, force)

    if not GatherLite:isLoaded() then
        return
    end

    local updateIcons = false
    local updateNodes = false

    if (force) then
        updateIcons = true
        updateNodes = true

        threadMining = coroutine.create(miningThread)
        threadHerbalism = coroutine.create(herbalismThread)
        threadContainer = coroutine.create(containerThread)
        threadFishing = coroutine.create(fishingThread)

        threadIcon = coroutine.create(minimapIconThread)
    else
        checkDiff = checkDiff + timeDelta
        timeDiff = timeDiff + timeDelta
        if (checkDiff > 5) then
            updateNodes = true
            checkDiff = 0
        elseif (timeDiff > 1) then
            updateIcons = true
            timeDiff = 0
        end
    end

    if (updateNodes) then
        if coroutine.status(threadMining) == "dead" then
            threadMining = coroutine.create(miningThread)
        end

        if coroutine.status(threadHerbalism) == "dead" then
            threadHerbalism = coroutine.create(herbalismThread)
        end

        if coroutine.status(threadContainer) == "dead" then
            threadContainer = coroutine.create(containerThread)
        end

        if coroutine.status(threadFishing) == "dead" then
            threadFishing = coroutine.create(fishingThread)
        end

    end

    if coroutine.status(threadIcon) == "dead" then
        threadIcon = coroutine.create(minimapIconThread)
    end

    coroutine.resume(threadMining)
    coroutine.resume(threadHerbalism)
    coroutine.resume(threadContainer)
    coroutine.resume(threadFishing)

    coroutine.resume(threadIcon)
end

function GatherLiteTracker:Worldmap()

    if not GatherLite:isLoaded() then
        return
    end

    GatherLite:forEach(GFrame.usedFrames, function(frame)
        if frame.type == "worldmap" and frame.node.loadedWorldmap then
            frame.node.loadedWorldmap = false;
            frame:Unload()
        end
    end);

    if worldmapOpen and worldmapID then
        for key, node in pairs(GatherLiteTracker:WorldmapNodes(_GatherLite.nodes["mining"], worldmapID, GatherLiteTracker.WorldmapFilter)) do
            _GatherLite.nodes["mining"][key].loadedWorldmap = true
            GatherLite:createWorldmapNode(_GatherLite.nodes["mining"][key])
        end

        for key, node in pairs(GatherLiteTracker:WorldmapNodes(_GatherLite.nodes["herbalism"], worldmapID, GatherLiteTracker.WorldmapFilter)) do
            _GatherLite.nodes["herbalism"][key].loadedWorldmap = true
            GatherLite:createWorldmapNode(_GatherLite.nodes["herbalism"][key])
        end

        for key, node in pairs(GatherLiteTracker:WorldmapNodes(_GatherLite.nodes["containers"], worldmapID, GatherLiteTracker.WorldmapFilter)) do
            _GatherLite.nodes["containers"][key].loadedWorldmap = true
            GatherLite:createWorldmapNode(_GatherLite.nodes["containers"][key])
        end

        for key, node in pairs(GatherLiteTracker:WorldmapNodes(_GatherLite.nodes["fishing"], worldmapID, GatherLiteTracker.WorldmapFilter)) do
            _GatherLite.nodes["fishing"][key].loadedWorldmap = true
            GatherLite:createWorldmapNode(_GatherLite.nodes["fishing"][key])
        end
    end
end

function GatherLiteTracker:OnUpdate(timeDelta)
    if not GatherLite:isLoaded() then
        return
    end

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