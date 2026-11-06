local name, _GatherLite = ...;

local Frames = LibStub("GatherLiteFrame");
local Pins = LibStub("HereBeDragons-Pins-2.0");

local SourceName = "worldmap"

GatherLite.modules[SourceName] = {}
local source = GatherLite.modules[SourceName]

local worldmapOpen = false;
local worldmapID = nil;

local privateLayer, pinWidth, pinHeight, pinCanvas
local privatePins = {}

function source:UsesPrivatePins()
    return InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled()
end

local function anchorPrivatePin(pin, point)
    pin:SetPoint("CENTER", pinCanvas, "TOPLEFT", point.x * pinWidth, -point.y * pinHeight)
end

local function updatePrivatePins()
    if not privateLayer then return end
    local map = WorldMapFrame
    local canvas = map:GetCanvas()
    local openMap = _GatherLite.OpenMap
    local api = openMap and openMap:IsStitched() and OpenMapAPI
    local artLevel = api and api.ArtTopLevel and api.ArtTopLevel() or 0
    local level = math.max(map.ScrollContainer:GetFrameLevel() + 101, artLevel + 2)
    if privateLayer:GetFrameLevel() ~= level and not InCombatLockdown() then
        privateLayer:SetFrameLevel(level)
        for pin in pairs(privatePins) do pin:SetFrameLevel(level + 1) end
    end
    local scale = canvas:GetEffectiveScale() / privateLayer:GetEffectiveScale()
    local width, height = canvas:GetWidth() * scale, canvas:GetHeight() * scale
    if canvas ~= pinCanvas or width ~= pinWidth or height ~= pinHeight then
        pinCanvas, pinWidth, pinHeight = canvas, width, height
        for pin, point in pairs(privatePins) do anchorPrivatePin(pin, point) end
    end
end

function source:AddPrivatePin(pin, x, y)
    if not privateLayer then
        local viewport = WorldMapFrame.ScrollContainer
        privateLayer = CreateFrame("Frame", nil, viewport)
        privateLayer:SetAllPoints()
        privateLayer:SetClipsChildren(true)
        privateLayer:EnableMouse(false)
        privateLayer:SetFrameLevel(viewport:GetFrameLevel() + 101)
    end
    -- These pins have their own hover handling and never enter Blizzard's gamepad pin list.
    updatePrivatePins()
    local point = { x = x, y = y }
    privatePins[pin] = point
    pin:SetParent(privateLayer)
    pin:SetFrameLevel(privateLayer:GetFrameLevel() + 1)
    pin:ClearAllPoints()
    anchorPrivatePin(pin, point)
    pin:Show()
end

function source:RemovePrivatePin(pin)
    if not privatePins[pin] then return false end
    privatePins[pin] = nil
    pin:Hide()
    pin:ClearAllPoints()
    pin:SetParent(UIParent)
    return true
end

-- Filter used on the worldmap
local WorldmapFilter = function(node)
    if not GatherLite.db.char.worldmap.enabled then
        return false
    end

    -- check if this map target is tracking the type of node
    if not GatherLite:GetNodeTracking("worldmap", node.type) then
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

-- Get nodes for current map id
local function WorldmapNodes(type, mapID, filter)
    if not GatherLite.db.char.worldmap.enabled or not GatherLite:GetNodeTracking("worldmap", type) then
        return {}
    end
    -- Load the full selected zone once; the map canvas handles pan/zoom clipping.
    local nodes
    if GatherLite.db.char.worldmap.neighbors then
        nodes = GatherLite:GetWorldMapNodesForRect(type, mapID, 0, 1, 0, 1)
    else
        nodes = GatherLite:GetNodesForMapRect(type, mapID, 0, 1, 0, 1)
    end
    local out = {}

    for i = 1, #nodes do
        local node = nodes[i]
        if filter(node) then
            out[#out + 1] = node
        end
    end

    return out
end

-- Unload worldmap nodes
local function UnloadWorldmap()
    GatherLite:forEach(Frames.usedFrames, function(frame)
        if frame.type == "worldmap" then
            frame.node.loadedWorldmap = false;
            GatherLite:SendMessage("nodes:unload", frame.node)
            frame:Unload()
        end
    end)
end

-- Create worldmap node
local function CreateWorldmapNode(node)
    if not GatherLite:IsLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    local x, y = GatherLite:ProjectNodeToMap(node, worldmapID)
    if not x or not y or x < 0 or x > 1 or y < 0 or y > 1 then return nil end

    local f = Frames:getFrame("worldmap");
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    f.texture:SetTexture(object.icon)
    f.texture:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    --f:SetBackdropColor(1, 0, 0, 1);

    f.node = node;
    f.object = object
    f.type = "worldmap";
    f.TimeSinceLastUpdate = 0

    -- TOOLTIP is above the dropdown's FULLSCREEN_DIALOG layer, so pins there
    -- can intercept clicks intended for the tracking menu.
    f:SetFrameStrata(WorldMapFrame:GetFrameStrata());
    --f:SetFrameLevel(0);

    f:SetScript("OnUpdate", nil)

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
        --GatherLite:debug(_GatherLite.DEBUG_NODE, self.node.instance)
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    if source:UsesPrivatePins() then
        source:AddPrivatePin(f, x, y)
    else
        -- Register against the viewed map: HBD otherwise hides sibling-zone pins.
        Pins:AddWorldMapIconMap(_GatherLite.name, f, worldmapID, x, y)
    end
    if _GatherLite.MapHover then _GatherLite.MapHover:Register(f, true) end

    GatherLite:SendMessage("nodes:load")

    return f;
end

-- Load worldmap nodes
local function LoadWorldmap()
    if not GatherLite:IsLoaded() then
        return
    end

    GatherLite:forEach(Frames.usedFrames, function(frame)
        if frame.type == "worldmap" and frame.node.loadedWorldmap then
            frame.node.loadedWorldmap = false;
            frame:Unload()
        end
    end);

    local info = worldmapID and C_Map.GetMapInfo and C_Map.GetMapInfo(worldmapID)
    local zone = worldmapID and GatherLite:GetZoneTree()[worldmapID]
    local mapType = info and info.mapType or (zone and zone.mapType)
    -- Overview/taxi maps must never display gathering pins.
    if worldmapOpen and worldmapID and mapType == 3 and (not zone or zone.system == 0) then
        local miningNodes = WorldmapNodes("mining", worldmapID, WorldmapFilter)
        for i = 1, #miningNodes do
            local node = miningNodes[i]
            node.loadedWorldmap = CreateWorldmapNode(node) ~= nil
        end

        local herbNodes = WorldmapNodes("herbalism", worldmapID, WorldmapFilter)
        for i = 1, #herbNodes do
            local node = herbNodes[i]
            node.loadedWorldmap = CreateWorldmapNode(node) ~= nil
        end

        local containerNodes = WorldmapNodes("containers", worldmapID, WorldmapFilter)
        for i = 1, #containerNodes do
            local node = containerNodes[i]
            node.loadedWorldmap = CreateWorldmapNode(node) ~= nil
        end

        local fishingNodes = WorldmapNodes("fishing", worldmapID, WorldmapFilter)
        for i = 1, #fishingNodes do
            local node = fishingNodes[i]
            node.loadedWorldmap = CreateWorldmapNode(node) ~= nil
        end
    end
end

-- Reset worldmap nodes
local function ResetWorldmap()
    UnloadWorldmap()
    LoadWorldmap()
end

local defaultCoords = { 0, 1, 0, 1 }
local function updateCoord(self)
    local coords = defaultCoords
    local deltaX, deltaY = 0, 0
    if not self:GetParent().isMouseDown then
        deltaX = (coords[2] - coords[1]) * 0.05
        deltaY = (coords[4] - coords[3]) * 0.05
    end
    self:SetTexCoord(coords[1] + deltaX, coords[2] - deltaX, coords[3] + deltaY, coords[4] - deltaY)
end

local function getAnchors(frame)
    local x, y = frame:GetCenter()
    if not x or not y then
        return "CENTER"
    end
    local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or ""
    local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
    return vhalf .. hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
end

local tooltip = CreateFrame("GameTooltip", "GatherLiteIconTooltip", UIParent, "GameTooltipTemplate")

local function mapPinButton(map)
    local onLoad = WorldMapTrackingPinButtonMixin and WorldMapTrackingPinButtonMixin.OnLoad
    for _, frame in ipairs(map.overlayFrames or {}) do
        if onLoad and frame.OnLoad == onLoad then return frame end
    end
end

local function createButton()
    local map = WorldMapFrame
    local viewport = map.ScrollContainer or map
    local button = CreateFrame("Button", "GatherLiteWorldmapButton", map)
    button:SetFrameStrata("HIGH")
    button:SetSize(32, 32)
    -- Blizzard adds 500 to the context menu owner's level for its backdrop.
    button:SetFrameLevel(math.min(viewport:GetFrameLevel() + 9000, 9200))
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetHighlightTexture(136477) --"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
    local lastAnchor, elapsed = nil, 0
    local function placeButton()
        local anchor = mapPinButton(map)
        local stack = LibStub("Krowi_WorldMapButtons-1.4", true)
        -- Follow the visible stack, including addons that register after login.
        -- Questie can remove the native pin from the shared list on Forever.
        if stack and stack.IsForever and stack.Buttons then
            for i = #stack.Buttons, 1, -1 do
                local peer = stack.Buttons[i]
                if peer:IsShown() then anchor = peer; break end
            end
        end
        anchor = anchor or viewport
        if anchor == lastAnchor then return end
        lastAnchor = anchor
        if anchor == viewport then
            button:SetPoint("TOPLEFT", viewport, "TOPLEFT", 3, -32)
        else
            button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
        end
    end
    placeButton()
    button:SetScript("OnUpdate", function(_, delta)
        elapsed = elapsed + delta
        if elapsed >= .15 and not InCombatLockdown() then
            elapsed = 0
            placeButton()
        end
    end)

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture(136430) --"Interface\\Minimap\\MiniMap-TrackingBorder"
    overlay:SetPoint("TOPLEFT")
    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture(136467) --"Interface\\Minimap\\UI-Minimap-Background"
    background:SetPoint("TOPLEFT", 7, -5)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17)
    icon:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
    icon:SetPoint("TOPLEFT", 7, -6)

    local r, g, b = icon:GetVertexColor()
    icon:SetVertexColor(r, g, b)

    icon.UpdateCoord = updateCoord
    icon:UpdateCoord()

    button:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            local sidebar = GatherLite.modules.worldMapSidebar
            if sidebar then sidebar:Toggle() end
        elseif button == "RightButton" then
            GatherLite:OpenTrackingMenu(self, "worldmap")
        end
    end);

    button:SetScript("OnEnter", function(self)
        tooltip:SetOwner(self, "ANCHOR_NONE")
        tooltip:SetPoint(getAnchors(self))
        tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('mining'), "white"),
            GatherLite:tablelength(GatherLite.db.global.nodes.mining));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('herbalism'), "white"),
            GatherLite:tablelength(GatherLite.db.global.nodes.herbalism));

        if GatherLite.db.global.debug.enabled then
            tooltip:AddLine(" ");
            tooltip:AddLine("             -- Debugging --             ");
            tooltip:AddDoubleLine(GatherLite:Colorize("Used frames", "white"), GatherLite:tablelength(Frames.usedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("Unused frames", "white"),
                GatherLite:tablelength(Frames.unusedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("All frames", "white"), GatherLite:tablelength(Frames.allFrames));
        end

        tooltip:AddLine(" ");
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.left_click"), 'gray') ..
            ": " .. GatherLite:translate("window.worldmap.toggle_pane"));
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.right_click"), 'gray') ..
            ": " .. GatherLite:translate("settings.minimap.left_click_text"));
        tooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        tooltip:Hide()
    end)
end

-- Zone summaries use the existing per-map index and allocate only on zone changes.
local zoneList
local zoneListHeight
local hoveredZoneID
local zoneElapsed = 0
local zoneKinds = { "mining", "herbalism", "containers", "fishing" }

function source.GetZoneNodes(mapID)
    local rows, seen, objects = {}, {}, {}
    if not mapID or not GatherLite.db.char.worldmap.enabled then return rows end
    for _, kind in ipairs(zoneKinds) do
        if GatherLite:GetNodeTracking("worldmap", kind) then
            for _, node in ipairs(GatherLite:GetNodesForMap(kind, mapID)) do
                if WorldmapFilter(node) then
                    local object = objects[node.object]
                    if object == nil then
                        object = GatherLite:GetNodeObject(node.object) or false
                        objects[node.object] = object
                    end
                    if object and not seen[object.id[1]] then
                        seen[object.id[1]] = true
                        rows[#rows + 1] = {
                            name = GatherLite:translate("node." .. object.name), icon = object.icon, object = object,
                        }
                    end
                end
            end
        end
    end
    table.sort(rows, function(a, b) return a.name < b.name end)
    return rows
end

local function HideZoneList()
    hoveredZoneID = nil
    if zoneList then zoneList:Hide() end
end

function source.UpdateZoneList(elapsed)
    if not GatherLite:IsLoaded() or not GatherLite.db.char.worldmap.enabled
        or not GatherLite.db.char.worldmap.zoneTooltip or not WorldMapFrame:IsVisible() then
        HideZoneList()
        return
    end
    zoneElapsed = zoneElapsed + (elapsed or 0)
    if zoneElapsed < 0.15 then return end
    zoneElapsed = 0
    -- Require canvas focus so menus and individual pin tooltips take priority.
    if not WorldMapFrame.IsCanvasMouseFocus or not WorldMapFrame:IsCanvasMouseFocus()
        or not WorldMapFrame.GetNormalizedCursorPosition or not C_Map.GetMapInfoAtPosition then
        HideZoneList()
        return
    end
    local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID() or WorldMapFrame.mapID
    -- Neighboring zones are also hit-testable on zone maps; require a continent view.
    local mapInfo = mapID and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    if not mapInfo or mapInfo.mapType ~= 2 then
        HideZoneList()
        return
    end
    local x, y = WorldMapFrame:GetNormalizedCursorPosition()
    if not mapID or not x or not y or x < 0 or x > 1 or y < 0 or y > 1 then
        HideZoneList()
        return
    end
    local info = C_Map.GetMapInfoAtPosition(mapID, x, y)
    -- Only child zones: a zoomed-in zone keeps its normal node tooltips.
    if not info or not info.mapID or info.mapID == mapID or info.mapType ~= 3 then
        HideZoneList()
        return
    end
    local parent = WorldMapFrame.ScrollContainer or WorldMapFrame
    local height = parent.GetHeight and parent:GetHeight() or 668
    if hoveredZoneID == info.mapID and zoneListHeight == height then return end
    hoveredZoneID, zoneListHeight = info.mapID, height
    if not zoneList then
        zoneList = CreateFrame("Frame", "GatherLiteZoneList", parent)
        zoneList:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -36)
        zoneList:EnableMouse(false)
        zoneList:SetFrameStrata(WorldMapFrame:GetFrameStrata())
        if parent.GetFrameLevel then zoneList:SetFrameLevel(parent:GetFrameLevel() + 10) end
        zoneList.title = zoneList:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        zoneList.title:SetPoint("TOPLEFT", 10, -10)
        zoneList.title:SetJustifyH("LEFT")
        zoneList.subtitle = zoneList:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        zoneList.subtitle:SetPoint("TOPLEFT", 10, -30)
        zoneList.rows = {}
    end
    zoneList.title:SetText(info.name or "")
    zoneList.subtitle:SetText(GatherLite:translate("tooltip.zone_nodes"))
    local rows = source.GetZoneNodes(info.mapID)
    -- Keep the list compact even on tall maps; balance entries across columns.
    local maxRows = math.max(1, math.min(12, math.floor((height - 120) / 18)))
    local count = math.max(1, #rows)
    local columns = math.ceil(count / maxRows)
    local perColumn = math.ceil(count / columns)
    zoneList:SetSize(columns * 220 + 20, math.min(count, perColumn) * 18 + 56)
    zoneList.title:SetWidth(columns * 220)
    for index = 1, count do
        local label = zoneList.rows[index]
        if not label then
            label = zoneList:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            label:SetJustifyH("LEFT")
            label:SetWordWrap(false)
            label:SetSize(216, 18)
            zoneList.rows[index] = label
        end
        label:ClearAllPoints()
        label:SetPoint("TOPLEFT", 10 + math.floor((index - 1) / perColumn) * 220,
            -48 - ((index - 1) % perColumn) * 18)
        local row = rows[index]
        label:SetText(row and ("|T" .. row.icon .. ":16:16|t " .. row.name)
            or GatherLite:translate("tooltip.zone_empty"))
        label:Show()
    end
    for index = count + 1, #zoneList.rows do zoneList.rows[index]:Hide() end
    zoneList:Show()
end

-- Module setup
source.setup = function()
    GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Loaded worldmap module")

    local frame = CreateFrame("Frame")
    local stitchedWasOpen = false

    createButton();

    GatherLite:On("nodes:added", function(node)
        HideZoneList()
        if stitchedWasOpen then _GatherLite.OpenMap.dirty = true; return end
        if not node or node.loadedWorldmap or not worldmapOpen or not WorldmapFilter(node) then return end
        local zone = worldmapID and GatherLite:GetZoneTree()[worldmapID]
        local info = worldmapID and C_Map.GetMapInfo and C_Map.GetMapInfo(worldmapID)
        local mapType = info and info.mapType or (zone and zone.mapType)
        if mapType ~= 3 or (zone and zone.system ~= 0) then return end
        local allowed = node.mapID == worldmapID
        if not allowed and GatherLite.db.char.worldmap.neighbors and zone then
            for _, mapID in ipairs(zone.neighbors) do
                if node.mapID == mapID then allowed = true; break end
            end
        end
        if allowed then node.loadedWorldmap = CreateWorldmapNode(node) ~= nil end
    end)

    frame:SetScript("OnUpdate", function(_, elapsed)
        local openMap = _GatherLite.OpenMap
        if next(privatePins) and WorldMapFrame:IsVisible() then updatePrivatePins() end
        if openMap and WorldMapFrame:IsVisible() and openMap:IsStitched() then
            if not stitchedWasOpen then
                HideZoneList()
                if _GatherLite.MapHover then _GatherLite.MapHover:Clear() end
                if worldmapOpen then UnloadWorldmap() end
                worldmapOpen, stitchedWasOpen = false, true
            end
            openMap:Update(elapsed)
            return
        end
        if stitchedWasOpen then
            openMap:Clear()
            stitchedWasOpen = false
        end
        source.UpdateZoneList(elapsed)
        if WorldMapFrame:IsVisible() and not worldmapOpen then
            worldmapOpen = true;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "open worldmap", worldmapID)
            ResetWorldmap()
        end

        if not WorldMapFrame:IsVisible() and worldmapOpen then
            worldmapOpen = false;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "close worldmap")
            -- Clear on this addon-owned update frame, not from a WorldMapFrame
            -- OnHide hook inside Blizzard's protected controller transition.
            if _GatherLite.MapHover then _GatherLite.MapHover:Clear() end
            UnloadWorldmap()
        end

        if worldmapOpen then
            local mapID = WorldMapFrame.mapID
            if not mapID and WorldMapFrame.GetMapID then
                mapID = WorldMapFrame:GetMapID()
            end
            if not mapID then
                mapID = C_Map.GetBestMapForUnit("player")
            end
            if not mapID then
                return
            end

            if worldmapID ~= mapID then
                worldmapID = mapID;

                ResetWorldmap()
            end

        end
    end)

    GatherLite:On("settings:update", function()
        HideZoneList()
        if stitchedWasOpen then _GatherLite.OpenMap.dirty = true end
        if worldmapOpen then
            ResetWorldmap()
        end
    end);
end

source.reset = ResetWorldmap
source.load = LoadWorldmap
source.unload = UnloadWorldmap
