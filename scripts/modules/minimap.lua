local name, _GatherLite = ...;

local Frames = LibStub("GatherLiteFrame");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local HBD = LibStub("HereBeDragons-2.0");

local SourceName = "Minimap"

local timeDiff = 0
local checkDiff = 0

local threadMining
local threadHerbalism
local threadContainer
local threadFishing

local threadIcon

GatherLite.modules[SourceName] = {}
local source = GatherLite.modules[SourceName]

local MinimapFilter = function(node)
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

local function ClosestNodes(type, posX, posY, instanceID, maxDist, filter)

    local t = GatherLite:Filter(_GatherLite.nodes[type], function(node)

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

-- Create minimap node
local function CreateMinimapNode(node)
    if not GatherLite:IsLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    GatherLite:debug(_GatherLite.DEBUG_NODE, "Create node of type", node.type);

    local f = Frames:getFrame("minimap");
    f:SetAlpha(GatherLite.db.char.minimap.opacity);
    f:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)

    f.texture:SetTexture(object.icon)
    f.node = node;
    f.object = object
    f.type = "minimap";

    f:SetFrameStrata(Minimap:GetFrameStrata());
    --f:SetFrameLevel(Minimap:GetFrameLevel() + 5);

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID)
    Pins:AddMinimapIconWorld(_GatherLite.name, f, instance, x, y, GatherLite.db.char.minimap.edge)
    return f;
end

-- Reset minimap nodes
local function ResetMinimap()
    if not GatherLite:IsLoaded() then
        return
    end

    GatherLite:forEach(Frames.usedFrames, function(frame)
        if frame.type == "minimap" then
            frame.node.loaded = false;
            frame:Unload()
        end
    end)
end

local function createNodeThread(type)
    local x, y, instanceID = HBD:GetPlayerWorldPosition()
    local t = ClosestNodes(type, x, y, instanceID, GatherLite.db.char.minimap.range, MinimapFilter);

    for key, node in pairs(t) do
        if not _GatherLite.nodes[type][key].loaded then
            CreateMinimapNode(_GatherLite.nodes[type][key])
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

    local usedFrames = GatherLite:Filter(Frames.usedFrames, function(frame)
        return frame.type == "minimap"
    end);

    for key, frame in pairs(usedFrames) do

        if IsInInstance() then
            frame.node.loaded = false;
            frame:Unload();
            return
        end

        local x2, y2, _ = HBD:GetWorldCoordinatesFromZone(frame.node.posX, frame.node.posY, frame.node.mapID);
        local _, distance = HBD:GetWorldVector(instanceID, x, y, x2, y2)

        if distance >= GatherLite.db.char.minimap.range then
            frame.node.loaded = false;
            frame:Unload();
            return
        end

        if not MinimapFilter(frame.node) then
            frame.node.loaded = false;
            frame:Unload();
            return
        end

        if distance < GatherLite.db.char.minimap.distance and frame:IsVisible() then
            frame:FakeHide();
        elseif distance >= GatherLite.db.char.minimap.distance and not frame:IsVisible() then
            frame:FakeShow();
        end
    end
end

local function Update(timeDelta, force)
    if not GatherLite:IsLoaded() then
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

    if threadIcon ~= nil and coroutine.status(threadIcon) == "dead" then
        threadIcon = coroutine.create(minimapIconThread)
    end

    coroutine.resume(threadMining)
    coroutine.resume(threadHerbalism)
    coroutine.resume(threadContainer)
    coroutine.resume(threadFishing)

    coroutine.resume(threadIcon)
end

local function LoadMinimap()
    Update(0, true)
end

-- Module setup
source.setup = function()
    GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Loaded minimap module")

    threadMining = coroutine.create(miningThread)
    threadHerbalism = coroutine.create(herbalismThread)
    threadContainer = coroutine.create(containerThread)
    threadFishing = coroutine.create(fishingThread)

    threadIcon = coroutine.create(minimapIconThread)

    LoadMinimap();

    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function(self, elapsed)
        Update(elapsed)
    end)

    GatherLite:On("settings:update", function()

        print("Update settings")

        ResetMinimap()
        Update(0, true)
    end);
end