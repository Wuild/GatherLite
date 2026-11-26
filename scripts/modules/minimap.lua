local name, _GatherLite = ...;

local Frames = LibStub("GatherLiteFrame");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local HBD = LibStub("HereBeDragons-2.0");
local nearbyIcon = "Interface\\AddOns\\" .. name .. "\\icons\\track_circle"
local wipe = wipe or function(t)
    for k in pairs(t) do
        t[k] = nil
    end
    return t
end

local SourceName = "Minimap"

local timeDiff = 0
local checkDiff = 0
local lastMapID, lastInstanceID
local lastIconsX, lastIconsY, lastIconsInstanceID, lastIconsMapID, lastIconsZoom, lastIconsInInstance
local lastIconsRadius, lastIconsWidth, lastShowLabels, lastRingMarkers, lastPinSize, lastRingSize
local lastScanX, lastScanY, lastScanInstanceID, lastScanMapID
local iconsDirty = true
local scanDirty = true

local PROFESSION_REFRESH_SEC = 5
local MAX_CREATE_PER_FRAME = 16
local MAX_SCAN_PER_FRAME = 128

local professionRankCache = {}
local professionRankTime = 0
local nodeLabelCache = {}
local seenLabelObjects = {}
local defaultLabelColor = { 0.95, 0.95, 0.95 }
local defaultColor = { 1, 1, 1 }
local clusterCells = {}
local activeClusterBuckets = {}
local visibleFrames = {}
local frameDistances = {}

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

local function DistanceSq(x1, y1, x2, y2)
    local dx, dy = x1 - x2, y1 - y2
    return dx * dx + dy * dy
end

local function HasMovedEnough(x1, y1, instance1, map1, x2, y2, instance2, map2, thresholdSq)
    if x1 == nil or y1 == nil or instance1 == nil or map1 == nil then return true end
    if x2 == nil or y2 == nil or instance2 == nil or map2 == nil then return true end
    if instance1 ~= instance2 or map1 ~= map2 then return true end
    return DistanceSq(x1, y1, x2, y2) >= thresholdSq
end

local function MinimapViewRadius()
    local radius = C_Minimap and C_Minimap.GetViewRadius and C_Minimap.GetViewRadius() or 233.333
    if not radius or radius <= 0 then radius = 233.333 end
    return radius
end

local function EffectiveLoadRange()
    local settings = GatherLite.db.profile.minimap
    if settings.edge == true then
        return settings.range
    end
    return math.min(settings.range, MinimapViewRadius() + 80)
end

local function ClosestNodes(type, worldX, worldY, instanceID, mapID, zoneX, zoneY, maxDist, filter)
    local nodes = GatherLite:GetNearbyZoneNodes(type, mapID, instanceID, zoneX, zoneY, maxDist)
    local out = {}
    local maxDistSq = maxDist * maxDist

    for i = 1, #nodes do
        local node = nodes[i]
        if not node.instance or not node.worldX or not node.worldY then
            GatherLite:EnsureNodeWorld(node)
        end

        if node.instance == instanceID and node.worldX and node.worldY and filter(node) then
            local distSq = DistanceSq(worldX, worldY, node.worldX, node.worldY)
            if distSq < maxDistSq and not HideNearbyNode(math.sqrt(distSq)) then
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

local function InvalidateProfessionCache()
    wipe(professionRankCache)
    professionRankTime = 0
end

local function ProfessionRank(nodeType)
    local skillLine = professionSkillLines[nodeType]
    if not skillLine or not C_SkillInfo or not C_SkillInfo.GetSkillLineInfoByID then return nil end
    local now = GetTime()
    if now - professionRankTime > PROFESSION_REFRESH_SEC then
        wipe(professionRankCache)
        professionRankTime = now
    end
    local cached = professionRankCache[nodeType]
    if cached ~= nil then
        return cached
    end
    local info = C_SkillInfo.GetSkillLineInfoByID(skillLine)
    local rank = info and info.rank or 0
    professionRankCache[nodeType] = rank
    return rank
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
    return ringColors[frame.node and frame.node.type] or defaultColor
end

local function GetObjectLabel(object)
    if not object or not object.name then return "" end
    local label = nodeLabelCache[object]
    if label == nil then
        label = GatherLite:translate("node." .. object.name)
        nodeLabelCache[object] = label
    end
    return label
end

local function UpdatePinLabel(frame)
    if not frame.label then return end
    local settings = GatherLite.db.profile.minimap
    if settings.showLabels ~= true or frame.clustered or frame.onEdge or not frame.object then
        if frame.labelText ~= nil then
            frame.label:Hide()
            frame.labelText = nil
        end
        return
    end

    local primaryName = GetObjectLabel(frame.object)
    local text = primaryName
    local clusterNodes = frame.clusterNodes
    if clusterNodes and #clusterNodes > 0 then
        wipe(seenLabelObjects)
        seenLabelObjects[frame.object] = true
        local extraCount = 0
        local secondName
        for i = 1, #clusterNodes do
            local extraObj = GatherLite:GetNodeObject(clusterNodes[i].object)
            if extraObj and not seenLabelObjects[extraObj] then
                seenLabelObjects[extraObj] = true
                extraCount = extraCount + 1
                if extraCount == 1 then
                    secondName = GetObjectLabel(extraObj)
                end
            end
        end
        if extraCount == 1 then
            text = primaryName .. " / " .. secondName
        elseif extraCount > 1 then
            text = primaryName .. " +" .. extraCount
        end
    end

    if frame.labelText ~= text then
        frame.label:SetText(text)
        frame.labelText = text
    end

    local color = DifficultyColor(frame) or defaultLabelColor
    if frame.labelColor ~= color then
        frame.label:SetTextColor(color[1], color[2], color[3], 0.85)
        frame.labelColor = color
    end

    frame.label:Show()
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
    UpdatePinLabel(frame)
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

local function OnPinEnter(self)
    GatherLite:showTooltip(self)
end

local function OnPinLeave()
    GatherLite:hideTooltip()
end

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
    local settings = GatherLite.db.profile.minimap
    f:SetAlpha(settings.opacity);

    local distance = math.sqrt(DistanceSq(worldX, worldY, node.worldX, node.worldY))
    f.nearby = settings.ringMarkers ~= true
        and settings.nearbyCircles == true
        and distance < settings.distance or false
    f.node = node;
    f.object = object
    f.type = "minimap";
    ApplyMinimapLayout(f)

    f:SetFrameStrata(Minimap:GetFrameStrata());
    --f:SetFrameLevel(Minimap:GetFrameLevel() + 5);

    f:SetScript("OnEnter", OnPinEnter)
    f:SetScript("OnLeave", OnPinLeave)

    Pins:AddMinimapIconWorld(_GatherLite.name, f, node.instance, node.worldX, node.worldY, settings.edge)
    return f;
end

-- Reset minimap nodes
local function ResetMinimap()
    if not GatherLite:IsLoaded() then
        return
    end

    iconsDirty = true
    scanDirty = true
    wipe(clusterCells)
    wipe(activeClusterBuckets)

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
        EffectiveLoadRange(), MinimapFilter);

    local created = 0
    local scanned = 0
    for i = 1, #t do
        local node = t[i]
        if not node.loaded then
            if CreateMinimapNode(node, worldX, worldY, instanceID) then
                node.loaded = true
                created = created + 1
                iconsDirty = true
            end
        end
        scanned = scanned + 1
        if created >= MAX_CREATE_PER_FRAME or scanned >= MAX_SCAN_PER_FRAME then
            created = 0
            scanned = 0
            coroutine.yield()
        end
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

local function compareVisibleFrames(a, b)
    local da, db = frameDistances[a], frameDistances[b]
    return da < db or (da == db and a.frameId < b.frameId)
end

local function UpdateMinimapIcons(x, y, instanceID, mapID, force)
    if x == nil or y == nil or instanceID == nil then
        return
    end

    local settings = GatherLite.db.profile.minimap
    local inInstance = IsInInstance()
    local zoom = Minimap and Minimap.GetZoom and Minimap:GetZoom() or nil
    local radius = MinimapViewRadius()
    local minimapWidth = Minimap and Minimap:GetWidth() or 0
    local loadRange = EffectiveLoadRange()
    local unloadRange = settings.edge == true and settings.range or math.min(settings.range, loadRange + 20)
    local ringMarkers = settings.ringMarkers == true
    local pinSize = settings.size
    local ringSize = ringMarkers and RingSize() or 0
    local showLabels = settings.showLabels == true

    local moved = HasMovedEnough(x, y, instanceID, mapID, lastIconsX, lastIconsY, lastIconsInstanceID, lastIconsMapID, 4)
    local changed = force or iconsDirty or moved
        or lastIconsInInstance ~= inInstance
        or lastIconsZoom ~= zoom
        or lastIconsRadius ~= radius
        or lastIconsWidth ~= minimapWidth
        or lastShowLabels ~= showLabels
        or lastRingMarkers ~= ringMarkers
        or lastPinSize ~= pinSize
        or lastRingSize ~= ringSize

    wipe(visibleFrames)
    wipe(frameDistances)

    -- Removing the current entry during pairs is safe; no snapshot is needed.
    for _, frame in pairs(Frames.usedFrames) do
        if frame.type == "minimap" then
            local node = frame.node
            if not node.worldX or not node.worldY then
                GatherLite:EnsureNodeWorld(node)
            end
            local distance
            if node.instance == instanceID and node.worldX and node.worldY then
                distance = math.sqrt(DistanceSq(x, y, node.worldX, node.worldY))
            end
            if inInstance or not distance or distance >= unloadRange
                or not MinimapFilter(node) or HideNearbyNode(distance) then
                frame:Unload()
                changed = true
                scanDirty = true
            else
                local nearby = not ringMarkers
                    and settings.nearbyCircles == true
                    and distance < settings.distance
                -- Use the library's placement, which accounts for minimap shape and rotation.
                local onEdge = settings.edge == true and Pins:IsMinimapIconOnEdge(frame) == true
                if frame.nearby ~= nearby or frame.onEdge ~= onEdge then
                    frame.nearby = nearby
                    ApplyMinimapLayout(frame, onEdge)
                    changed = true
                end
                visibleFrames[#visibleFrames + 1] = frame
                frameDistances[frame] = distance
            end
        end
    end

    if moved then
        scanDirty = true
    end
    if #visibleFrames == 0 then
        lastIconsX, lastIconsY, lastIconsInstanceID, lastIconsMapID = x, y, instanceID, mapID
        lastIconsZoom, lastIconsInInstance = zoom, inInstance
        lastIconsRadius, lastIconsWidth = radius, minimapWidth
        lastShowLabels, lastRingMarkers, lastPinSize, lastRingSize = showLabels, ringMarkers, pinSize, ringSize
        iconsDirty = false
        return
    end
    if minimapWidth <= 0 then
        iconsDirty = true
        return
    end
    if not changed then
        return
    end

    iconsDirty = false
    lastIconsX, lastIconsY, lastIconsInstanceID, lastIconsMapID = x, y, instanceID, mapID
    lastIconsZoom, lastIconsInInstance = zoom, inInstance
    lastIconsRadius, lastIconsWidth = radius, minimapWidth
    lastShowLabels, lastRingMarkers, lastPinSize, lastRingSize = showLabels, ringMarkers, pinSize, ringSize

    -- Spawn alternatives and different resource types can occupy the same
    -- minimap pixels. Keep the closest representative without changing history
    -- or hiding the client's live tracking dots. Hide only our texture so HBD
    -- continues to own pin visibility, clipping and edge placement.
    table.sort(visibleFrames, compareVisibleFrames)

    for i = 1, #activeClusterBuckets do
        wipe(activeClusterBuckets[i])
    end
    wipe(activeClusterBuckets)

    -- Ring markers are taller (ring plus icon below), so give them more room.
    local footprint = pinSize
    if ringMarkers then footprint = math.max(footprint, ringSize) end
    local spacing = 2 * radius * (footprint + 2) / minimapWidth
    local spacingSq = spacing * spacing

    for i = 1, #visibleFrames do
        local frame = visibleFrames[i]
        frame.clusterNodes = frame.clusterNodes or {}
        wipe(frame.clusterNodes)
        local fx, fy = frame.node.worldX, frame.node.worldY
        local cx, cy = math.floor(fx / spacing), math.floor(fy / spacing)
        local overlap = false
        for dx = -1, 1 do
            local col = clusterCells[cx + dx]
            if col then
                for dy = -1, 1 do
                    local bucket = col[cy + dy]
                    if bucket then
                        for j = 1, #bucket do
                            local other = bucket[j]
                            if not overlap and DistanceSq(other.node.worldX, other.node.worldY, fx, fy) < spacingSq then
                                overlap = other
                            end
                        end
                    end
                end
            end
        end
        frame.clustered = overlap and true or false
        if overlap then
            overlap.clusterNodes[#overlap.clusterNodes + 1] = frame.node
        elseif frame:IsShown() then
            local col = clusterCells[cx]
            if not col then
                col = {}
                clusterCells[cx] = col
            end
            local bucket = col[cy]
            if not bucket then
                bucket = {}
                col[cy] = bucket
            end
            if #bucket == 0 then
                activeClusterBuckets[#activeClusterBuckets + 1] = bucket
            end
            bucket[#bucket + 1] = frame
        end
    end

    for i = 1, #visibleFrames do
        local frame = visibleFrames[i]
        local wantMouse = not frame.clustered
        if frame.mouseEnabled ~= wantMouse then
            frame:SetMouseMotionEnabled(wantMouse)
            frame.mouseEnabled = wantMouse
        end
        UpdatePinVisibility(frame)
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
        iconsDirty = true
        scanDirty = true
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

    local worldX, worldY, instanceID, zoneX, zoneY, mapID
    if updateIcons or updateNodes then
        worldX, worldY, instanceID, zoneX, zoneY, mapID = GetPlayerLocation()
        if not worldX or not worldY or not instanceID or not zoneX or not zoneY or IsInInstance() then
            mapID = nil
        end
        local mapInstance = mapID and instanceID
        if mapID ~= lastMapID or mapInstance ~= lastInstanceID then
            lastMapID, lastInstanceID = mapID, mapInstance
            iconsDirty = true
            scanDirty = true
            wipe(clusterCells)
            wipe(activeClusterBuckets)
            if mapID then
                -- Recover from loading screens and discard unfinished scans of the previous zone.
                if not force then RestartNodeWorkers() end
                updateNodes = true
                checkDiff = 0
            end
        end
        if updateIcons then
            debugState.lastIconsUpdate = GetTime()
            debugState.lastIconsTick = timeDelta or 0
        end
    end

    if (updateNodes) and mapID then
        if force or scanDirty or HasMovedEnough(worldX, worldY, instanceID, mapID, lastScanX, lastScanY, lastScanInstanceID, lastScanMapID, 100) then
            lastScanX, lastScanY, lastScanInstanceID, lastScanMapID = worldX, worldY, instanceID, mapID
            scanDirty = false
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
    end

    -- Only active node workers need resuming between their five-second scans.
    if coroutine.status(threadMining) ~= "dead" then coroutine.resume(threadMining) end
    if coroutine.status(threadHerbalism) ~= "dead" then coroutine.resume(threadHerbalism) end
    if coroutine.status(threadContainer) ~= "dead" then coroutine.resume(threadContainer) end
    if coroutine.status(threadFishing) ~= "dead" then coroutine.resume(threadFishing) end

    if updateIcons then UpdateMinimapIcons(worldX, worldY, instanceID, mapID, force) end
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
        local distance = math.sqrt(DistanceSq(worldX, worldY, node.worldX, node.worldY))
        if distance >= EffectiveLoadRange() or HideNearbyNode(distance) then return end
        node.loaded = CreateMinimapNode(node, worldX, worldY, instanceID) ~= nil
        -- Recluster visible icons, retaining the existing discovery workers and timers.
        if node.loaded then
            iconsDirty = true
            UpdateMinimapIcons(worldX, worldY, instanceID, mapID, true)
        end
    end)

    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function(self, elapsed)
        Update(elapsed)
    end)
    -- Recolour difficulty rings and labels as gathering skill rises.
    frame:RegisterEvent("SKILL_LINES_CHANGED")
    frame:RegisterEvent("MINIMAP_UPDATE_ZOOM")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent", function(_, event)
        if event == "SKILL_LINES_CHANGED" then
            InvalidateProfessionCache()
            local settings = GatherLite.db.profile.minimap
            if settings.ringMarkers == true and settings.ringDifficultyColors == true then
                for _, pin in pairs(Frames.usedFrames) do
                    if pin.type == "minimap" then ApplyMinimapLayout(pin) end
                end
            elseif settings.showLabels == true then
                for _, pin in pairs(Frames.usedFrames) do
                    if pin.type == "minimap" then UpdatePinLabel(pin) end
                end
            end
        elseif event == "MINIMAP_UPDATE_ZOOM" or event == "PLAYER_ENTERING_WORLD" then
            iconsDirty = true
            scanDirty = true
        end
    end)

    GatherLite:On("settings:update", function()
        GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Update settings")

        ResetMinimap()
        Update(0, true)
    end);
end
