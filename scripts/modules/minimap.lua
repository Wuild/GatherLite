local name, _GatherLite = ...;

local Frames = LibStub("GatherLiteFrame");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local HBD = LibStub("HereBeDragons-2.0");
local nearbyIcon = "Interface\\AddOns\\" .. name .. "\\icons\\track_circle"

local SourceName = "Minimap"

local timeDiff = 0
local checkDiff = 0
local lastMapID, lastInstanceID

local threadMining
local threadHerbalism
local threadContainer
local threadFishing

local debugState = {
    lastNodesUpdate = 0,
    lastIconsUpdate = 0,
    lastForceUpdate = 0,
    lastNodesTick = 0,
    lastIconsTick = 0,
}

GatherLite.modules[SourceName] = {}
local source = GatherLite.modules[SourceName]

local MinimapFilter = function(node)
    if not GatherLite.db.profile.minimap.enabled then
        return false
    end

    -- check if this map target is tracking the type of node
    if not GatherLite:GetNodeTracking("minimap", node.type) then
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

local function HideNearbyNode(distance)
    local settings = GatherLite.db.profile.minimap
    return settings.hideNearbyNodes == true and distance < settings.distance
end

local function GetPlayerLocation()
    local worldX, worldY, instanceID = HBD:GetPlayerWorldPosition()
    local zoneX, zoneY, mapID = HBD:GetPlayerZonePosition(true)
    if (worldX == nil or worldY == nil or instanceID == nil) and zoneX and zoneY and mapID then
        worldX, worldY, instanceID = HBD:GetWorldCoordinatesFromZone(zoneX, zoneY, mapID)
    end
    return worldX, worldY, instanceID, zoneX, zoneY, mapID
end

local function ClosestNodes(type, worldX, worldY, instanceID, mapID, zoneX, zoneY, maxDist, filter)
    local nodes = GatherLite:GetNearbyZoneNodes(type, mapID, instanceID, zoneX, zoneY, maxDist)
    local out = {}

    for i = 1, #nodes do
        local node = nodes[i]
        if not node.instance or not node.worldX or not node.worldY then
            GatherLite:EnsureNodeWorld(node)
        end

        if node.instance == instanceID and node.worldX and node.worldY and filter(node) then
            local _, distance = HBD:GetWorldVector(instanceID, worldX, worldY, node.worldX, node.worldY)
            if distance and distance < maxDist and not HideNearbyNode(distance) then
                out[#out + 1] = node
            end
        end
    end

    return out
end

-- Ring tint per node type, so the resource kind reads even at small icon sizes.
local ringColors = {
    mining = { 1, 0.55, 0.1 },
    herbalism = { 0.35, 1, 0.35 },
    containers = { 1, 0.85, 0.2 },
    fishing = { 0.35, 0.7, 1 },
}
local RING_GAP = 1
local DEFAULT_RING_SIZE = 18

-- Gathering difficulty colours, matching the game's skill-up colours.
local difficultyColors = {
    red = { 1, 0.1, 0.1 },
    orange = { 1, 0.5, 0.25 },
    yellow = { 1, 1, 0 },
    green = { 0.25, 0.75, 0.25 },
    grey = { 0.5, 0.5, 0.5 },
}
local professionSkillLines = { mining = 186, herbalism = 182 }

local function ProfessionRank(nodeType)
    local skillLine = professionSkillLines[nodeType]
    if not skillLine or not C_SkillInfo or not C_SkillInfo.GetSkillLineInfoByID then return nil end
    local info = C_SkillInfo.GetSkillLineInfoByID(skillLine)
    return info and info.rank or 0
end

-- levels = { orange, yellow, green, grey } minimum skills. Some nodes publish only
-- the minimum; for those report "can gather" as yellow rather than invent tiers.
local function DifficultyColor(frame)
    local levels = frame.object and frame.object.levels
    if not levels or not levels[1] then return nil end
    local rank = ProfessionRank(frame.node and frame.node.type)
    if rank == nil then return nil end
    if rank < levels[1] then return difficultyColors.red end
    if #levels < 4 then return difficultyColors.yellow end
    if rank < levels[2] then return difficultyColors.orange end
    if rank < levels[3] then return difficultyColors.yellow end
    if rank < levels[4] then return difficultyColors.green end
    return difficultyColors.grey
end

local function RingColor(frame)
    if GatherLite.db.profile.minimap.ringDifficultyColors == true then
        local color = DifficultyColor(frame)
        if color then return color end
    end
    return ringColors[frame.node and frame.node.type] or { 1, 1, 1 }
end

-- Show the parts of a pin that its layout and overlap state allow.
local function UpdatePinVisibility(frame)
    if frame.clustered then
        frame.texture:Hide()
        frame.ring:Hide()
    elseif frame.ringLayout then
        frame.ring:Show()
        if GatherLite.db.profile.minimap.ringShowIcon ~= false then frame.texture:Show() else frame.texture:Hide() end
    else
        frame.texture:Show()
        frame.ring:Hide()
    end
end

local function MinimapViewRadius()
    local radius = C_Minimap and C_Minimap.GetViewRadius and C_Minimap.GetViewRadius() or 233.333
    if not radius or radius <= 0 then radius = 233.333 end
    return radius
end

-- A node beyond the minimap's radius is drawn on the rim (edge mode). No live
-- tracking dot can be there, so the ring would be meaningless.
local function IsOnEdge(distance)
    return GatherLite.db.profile.minimap.edge == true and distance ~= nil and distance > MinimapViewRadius()
end

local function RingSize()
    return GatherLite.db.profile.minimap.ringSize or DEFAULT_RING_SIZE
end

-- Lay out a minimap pin. In ring mode the pin frame (which HereBeDragons centres
-- on the node) holds a hollow ring, and the resource icon hangs below it.
local function ApplyMinimapLayout(frame, onEdge)
    local settings = GatherLite.db.profile.minimap
    local size = settings.size
    if onEdge == nil then onEdge = frame.onEdge end
    frame.onEdge = onEdge
    frame.ringLayout = settings.ringMarkers == true and not onEdge

    frame.texture:ClearAllPoints()
    if frame.ringLayout then
        local ringSize = RingSize()
        frame:SetSize(ringSize, ringSize)
        frame.ring:SetTexture(nearbyIcon)
        local color = RingColor(frame)
        frame.ring:SetVertexColor(color[1], color[2], color[3], 1)
        frame.texture:SetSize(size, size)
        frame.texture:SetPoint("TOP", frame, "BOTTOM", 0, -RING_GAP)
        frame.texture:SetTexture(frame.object.icon)
        if settings.ringShowIcon ~= false then
            -- Stretch the hover area down over the icon so either part shows the tooltip.
            frame:SetHitRectInsets(0, 0, 0, -(size + RING_GAP))
        else
            frame:SetHitRectInsets(0, 0, 0, 0)
        end
    else
        frame:SetSize(size, size)
        frame.texture:SetAllPoints(frame)
        frame.texture:SetTexture(frame.nearby and nearbyIcon or frame.object.icon)
        frame:SetHitRectInsets(0, 0, 0, 0)
    end
    UpdatePinVisibility(frame)
end
source.ApplyLayout = ApplyMinimapLayout

-- Create minimap node
local function CreateMinimapNode(node, worldX, worldY, instanceID)
    if not GatherLite:IsLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    GatherLite:debug(_GatherLite.DEBUG_NODE, "Create node of type", node.type);

    local f = Frames:getFrame("minimap");
    f:SetAlpha(GatherLite.db.profile.minimap.opacity);

    local _, distance = HBD:GetWorldVector(instanceID, worldX, worldY, node.worldX, node.worldY)
    f.nearby = GatherLite.db.profile.minimap.ringMarkers ~= true
        and GatherLite.db.profile.minimap.nearbyCircles == true
        and distance and distance < GatherLite.db.profile.minimap.distance or false
    f.node = node;
    f.object = object
    f.type = "minimap";
    ApplyMinimapLayout(f, IsOnEdge(distance))

    f:SetFrameStrata(Minimap:GetFrameStrata());
    --f:SetFrameLevel(Minimap:GetFrameLevel() + 5);

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    Pins:AddMinimapIconWorld(_GatherLite.name, f, node.instance, node.worldX, node.worldY, GatherLite.db.profile.minimap.edge)
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
    if not GatherLite.db.profile.minimap.enabled or not GatherLite:GetNodeTracking("minimap", type)
        or IsInInstance() then return end
    local worldX, worldY, instanceID, zoneX, zoneY, mapID = GetPlayerLocation()

    if worldX == nil or worldY == nil or instanceID == nil or zoneX == nil or zoneY == nil or not mapID then
        return
    end
    local t = ClosestNodes(type, worldX, worldY, instanceID, mapID, zoneX, zoneY,
        GatherLite.db.profile.minimap.range, MinimapFilter);

    for i = 1, #t do
        local node = t[i]
        if not node.loaded then
            if CreateMinimapNode(node, worldX, worldY, instanceID) then node.loaded = true end
        end
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

local function RestartNodeWorkers()
    threadMining = coroutine.create(miningThread)
    threadHerbalism = coroutine.create(herbalismThread)
    threadContainer = coroutine.create(containerThread)
    threadFishing = coroutine.create(fishingThread)
end

local function UpdateMinimapIcons(x, y, instanceID)
    if x == nil or y == nil or instanceID == nil then
        return
    end

    local inInstance = IsInInstance()
    local visible = {}
    -- Removing the current entry during pairs is safe; no snapshot is needed.
    for _, frame in pairs(Frames.usedFrames) do
        if frame.type == "minimap" then
            local node = frame.node
            if not node.worldX or not node.worldY then
                GatherLite:EnsureNodeWorld(node)
            end
            local distance
            if node.instance == instanceID and node.worldX and node.worldY then
                local _
                _, distance = HBD:GetWorldVector(instanceID, x, y, node.worldX, node.worldY)
            end
            if inInstance or not distance or distance >= GatherLite.db.profile.minimap.range
                or not MinimapFilter(node) or HideNearbyNode(distance) then
                frame:Unload()
            else
                local nearby = GatherLite.db.profile.minimap.ringMarkers ~= true
                    and GatherLite.db.profile.minimap.nearbyCircles == true
                    and distance < GatherLite.db.profile.minimap.distance
                local onEdge = IsOnEdge(distance)
                if frame.nearby ~= nearby or frame.onEdge ~= onEdge then
                    frame.nearby = nearby
                    ApplyMinimapLayout(frame, onEdge)
                end
                visible[#visible + 1] = {frame=frame, distance=distance}
            end
        end
    end
    -- Spawn alternatives and different resource types can occupy the same
    -- minimap pixels. Keep the closest representative without changing history
    -- or hiding the client's live tracking dots. Hide only our texture so HBD
    -- continues to own pin visibility, clipping and edge placement.
    table.sort(visible,function(a,b)
        return a.distance < b.distance or (a.distance == b.distance and a.frame.frameId < b.frame.frameId)
    end)
    local radius=MinimapViewRadius()
    if Minimap:GetWidth()<=0 then return end
    -- Ring markers are taller (ring plus icon below), so give them more room.
    local footprint=GatherLite.db.profile.minimap.size
    if GatherLite.db.profile.minimap.ringMarkers == true then footprint=math.max(footprint, RingSize()) end
    local spacing=2 * radius * (footprint + 2) / Minimap:GetWidth()
    local cells={}
    for _,entry in ipairs(visible) do
        local frame=entry.frame
        frame.clusterNodes={}
        local cx,cy=math.floor(frame.node.worldX/spacing),math.floor(frame.node.worldY/spacing)
        local overlap=false
        for dx=-1,1 do
            for dy=-1,1 do
                for _,other in ipairs(cells[(cx+dx)..":"..(cy+dy)] or {}) do
                    if (other.node.worldX-frame.node.worldX)^2+(other.node.worldY-frame.node.worldY)^2 < spacing^2 then
                        overlap=overlap or other
                    end
                end
            end
        end
        frame:SetMouseMotionEnabled(not overlap)
        frame.clustered = overlap and true or false
        UpdatePinVisibility(frame)
        if overlap then
            overlap.clusterNodes[#overlap.clusterNodes+1]=frame.node
        else
            local key=cx..":"..cy
            cells[key]=cells[key] or {}
            if frame:IsShown() then cells[key][#cells[key]+1]=frame end
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
        debugState.lastForceUpdate = GetTime()

        RestartNodeWorkers()

        checkDiff, timeDiff = 0, 0
    else
        checkDiff = checkDiff + timeDelta
        timeDiff = timeDiff + timeDelta
        if (checkDiff > 5) then
            updateNodes = true
            checkDiff = 0
        end
        if (timeDiff >= 1) then
            updateIcons = true
            timeDiff = 0
        end
    end

    local worldX, worldY, instanceID
    if updateIcons then
        local zoneX, zoneY, mapID
        worldX, worldY, instanceID, zoneX, zoneY, mapID = GetPlayerLocation()
        if not worldX or not worldY or not instanceID or not zoneX or not zoneY or IsInInstance() then
            mapID = nil
        end
        local mapInstance = mapID and instanceID
        if mapID ~= lastMapID or mapInstance ~= lastInstanceID then
            lastMapID, lastInstanceID = mapID, mapInstance
            if mapID then
                -- Recover from loading screens and discard unfinished scans of the previous zone.
                if not force then RestartNodeWorkers() end
                updateNodes = true
                checkDiff = 0
            end
        end
        debugState.lastIconsUpdate = GetTime()
        debugState.lastIconsTick = timeDelta or 0
    end

    if (updateNodes) then
        debugState.lastNodesUpdate = GetTime()
        debugState.lastNodesTick = timeDelta or 0
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

    -- Only active node workers need resuming between their five-second scans.
    if coroutine.status(threadMining) ~= "dead" then coroutine.resume(threadMining) end
    if coroutine.status(threadHerbalism) ~= "dead" then coroutine.resume(threadHerbalism) end
    if coroutine.status(threadContainer) ~= "dead" then coroutine.resume(threadContainer) end
    if coroutine.status(threadFishing) ~= "dead" then coroutine.resume(threadFishing) end

    if updateIcons then UpdateMinimapIcons(worldX, worldY, instanceID) end
end

-- Module setup
source.setup = function()
    GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Loaded minimap module")
    GatherLite.minimapDebug = debugState

    RestartNodeWorkers()

    GatherLite:On("nodes:added", function(node)
        if not node or node.loaded or not MinimapFilter(node) or IsInInstance() then return end
        local worldX, worldY, instanceID, _, _, mapID = GetPlayerLocation()
        if worldX == nil or worldY == nil or instanceID == nil or not mapID then return end
        local allowed = node.mapID == mapID
        local zone = GatherLite:GetZoneTree()[mapID]
        if not allowed and zone then
            for _, neighbor in ipairs(zone.neighbors) do
                if node.mapID == neighbor then allowed = true; break end
            end
        end
        if not allowed then return end
        GatherLite:EnsureNodeWorld(node)
        if node.instance ~= instanceID or not node.worldX or not node.worldY then return end
        local _, distance = HBD:GetWorldVector(instanceID, worldX, worldY, node.worldX, node.worldY)
        if not distance or distance >= GatherLite.db.profile.minimap.range or HideNearbyNode(distance) then return end
        node.loaded = CreateMinimapNode(node, worldX, worldY, instanceID) ~= nil
        -- Recluster visible icons, retaining the existing discovery workers and timers.
        if node.loaded then UpdateMinimapIcons(worldX, worldY, instanceID) end
    end)

    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function(self, elapsed)
        Update(elapsed)
    end)
    -- Recolour difficulty rings as gathering skill rises.
    frame:RegisterEvent("SKILL_LINES_CHANGED")
    frame:SetScript("OnEvent", function()
        local settings = GatherLite.db.profile.minimap
        if settings.ringMarkers ~= true or settings.ringDifficultyColors ~= true then return end
        for _, pin in pairs(Frames.usedFrames) do
            if pin.type == "minimap" then ApplyMinimapLayout(pin) end
        end
    end)

    GatherLite:On("settings:update", function()
        GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Update settings")

        ResetMinimap()
        Update(0, true)
    end);
end
