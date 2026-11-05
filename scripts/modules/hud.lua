local _, addon = ...
local HBD = LibStub("HereBeDragons-2.0")
local Pins = LibStub("HereBeDragons-Pins-2.0", true)
local HUD = {}
GatherLite.modules.HUD = HUD

local kinds = { "mining", "herbalism", "containers", "fishing" }
local directions = { "N", "W", "S", "E" }
local halfArc, circle = math.pi / 2, 2 * math.pi
local queryStep, queryPadding = 16, 32
local frame, bar, compass, background, moveHint, options
local ticks, borders, markers, spareMarkers, objects = {}, {}, {}, {}, {}
local candidates, projected = {}, {}
local external = {}
local pinTime, pinScan = 0, 0
local dirty, moving, dragging
local queryX, queryY, queryMap, queryInstance
local drawX, drawY, drawFacing, displayedFacing
local generation = 0
local hoveredMarker

local function angleDelta(angle, reference)
    return (angle - reference + math.pi) % circle - math.pi
end

local function refreshNodes(worldX, worldY, mapID, instance)
    dirty = false
    queryX, queryY, queryMap, queryInstance = worldX, worldY, mapID, instance
    wipe(candidates)
    if not worldX or not mapID then return end
    -- Read our nodes from the index so the HUD controls their visibility and size.
    local target = options.mirrorMinimap and "minimap" or "hud"
    if options.mirrorMinimap and (not GatherLite.db.char.minimap.enabled or IsInInstance()) then return end
    local x, y = HBD:GetZoneCoordinatesFromWorldInstance(worldX, worldY, instance, mapID, true)
    if not x or not y then return end
    local range = options.range + queryPadding
    local limit = range * range
    for _, kind in ipairs(kinds) do
        if GatherLite:GetNodeTracking(target, kind) then
            local nodes = GatherLite:GetNearbyZoneNodes(kind, mapID, instance, x, y, range)
            for _, node in ipairs(nodes) do
                if (not node.predefined or GatherLite.db.global.usePredefined) and not GatherLite:IsIgnored(node.object) then
                    if not node.worldX or not node.worldY then GatherLite:EnsureNodeWorld(node) end
                    if node.instance == instance and node.worldX and node.worldY
                        and (node.worldX - worldX)^2 + (node.worldY - worldY)^2 <= limit then
                        local object = objects[node.object]
                        if object == nil then
                            object = GatherLite:GetNodeObject(node.object) or false
                            objects[node.object] = object
                        end
                        if object then
                            candidates[#candidates + 1] = {
                                key = node, worldX = node.worldX, worldY = node.worldY,
                                object = object,
                            }
                        end
                    end
                end
            end
        end
    end
end

local function findArt(...)
    for i = 1, select("#", ...) do
        local region = select(i, ...)
        if type(region) == "table" and region.GetTexture and region:IsVisible() and region:GetAlpha() > 0 then
            local atlas = region.GetAtlas and region:GetAtlas()
            local texture = region:GetTexture()
            if not addon.API.IsSecret(atlas) and not addon.API.IsSecret(texture) and (atlas or texture) then
                local r, g, b, alpha = region:GetVertexColor()
                if alpha ~= 0 then return region, atlas, texture, r, g, b end
            end
        end
    end
end

local function pinTitle(pin, fish)
    if fish and pin.fish then
        return #pin.fish == 1 and pin.fish[1].name or GatherLite:translate("window.resource.fish_catches")
    end
    local poi, data, waypoint = pin.POI, pin.data, pin.waypoint
    local tooltip = type(poi) == "table" and poi.tooltip
    local title = (type(poi) == "table" and poi.name)
        or (type(tooltip) == "table" and tooltip.title)
        or (type(data) == "table" and data.Name)
        or (type(waypoint) == "table" and waypoint.title)
    if not addon.API.IsSecret(title) and type(title) == "string" and title ~= "" then return title end
end

local function sameCoords(a, b)
    if #a ~= #b then return false end
    for i = 1, #a do
        if a[i] ~= b[i] then return false end
    end
    return true
end

local function refreshExternal(worldX, worldY, instance)
    pinScan = pinScan + 1
    local changed = false
    local active = worldX and (options.externalPins or options.mirrorMinimap) and Pins and Pins.activeMinimapPins
    if active then
        local registry = Pins.minimapPinRegistry or {}
        local own, fish = registry[addon.name], registry[addon.Fishing]
        local limit = (options.range + queryPadding)^2
        -- Only copy the shared library's currently visible pins. Never run another addon's scripts.
        for pin, data in pairs(active) do
            local fishPin = fish and fish[pin]
            if type(data) == "table" and data.instanceID == instance
                and not (own and own[pin]) and (options.mirrorMinimap or not fishPin)
                and not pin.isFar and (not pin.IsForbidden or not pin:IsForbidden())
                and type(data.x) == "number" and type(data.y) == "number"
                and not addon.API.IsSecret(data.x) and not addon.API.IsSecret(data.y)
                and (data.x - worldX)^2 + (data.y - worldY)^2 <= limit and pin:IsVisible() and pin:GetAlpha() > 0 then
                local art, atlas, texture, r, g, b = findArt(pin.IconTexture, pin.texture, pin.icon, pin.Texture)
                if not art and pin.GetRegions then art, atlas, texture, r, g, b = findArt(pin:GetRegions()) end
                if art then
                    local title = pinTitle(pin, fishPin)
                    local coords = { art:GetTexCoord() }
                    local item = external[pin]
                    if not item or item.worldX ~= data.x or item.worldY ~= data.y or item.title ~= title
                        or item.atlas ~= atlas or item.texture ~= texture or item.r ~= r or item.g ~= g
                        or item.b ~= b or not sameCoords(item.coords, coords) then
                        item = {
                            key = pin, worldX = data.x, worldY = data.y, title = title, external = true,
                            atlas = atlas, texture = texture, r = r, g = g, b = b, coords = coords,
                        }
                        external[pin], changed = item, true
                    end
                    item.scan = pinScan
                end
            end
        end
    end
    for pin, item in pairs(external) do
        if item.scan ~= pinScan then external[pin], changed = nil, true end
    end
    return changed
end

local function hideTooltip(marker)
    if hoveredMarker == marker then hoveredMarker = nil end
    if GameTooltip:IsOwned(marker) then GameTooltip:Hide() end
end

local function renderTooltip(marker, yards)
    marker.tooltipYards = yards
    local item = marker.item
    local title = item.object and GatherLite:translate("node." .. item.object.name)
        or item.title or GatherLite:translate("settings.hud.externalPin")
    GameTooltip:ClearLines()
    GameTooltip:SetText(title, 1, .82, 0)
    GameTooltip:AddLine(GatherLite:translate("settings.hud.distance", yards), 1, 1, 1)
    if not item.external then
        GameTooltip:AddLine(GatherLite:translate("tooltip.known_location"), .8, .8, .8, true)
    end
    GameTooltip:Show()
end

local function showTooltip(marker)
    hoveredMarker = marker
    GameTooltip:SetOwner(marker, "ANCHOR_CURSOR")
    renderTooltip(marker, math.floor(marker.distance + .5))
end

local function createMarker()
    local marker = CreateFrame("Frame", nil, compass)
    marker:SetMouseClickEnabled(false)
    marker:SetMouseMotionEnabled(true)
    marker:SetScript("OnEnter", showTooltip)
    marker:SetScript("OnLeave", hideTooltip)
    marker:SetScript("OnHide", hideTooltip)
    marker.icon = marker:CreateTexture(nil, "ARTWORK")
    marker.icon:SetAllPoints()
    marker.icon:SetSnapToPixelGrid(false)
    return marker
end

local function project(items, worldX, worldY, sin, cos, limit, span)
    for _, item in pairs(items) do
        local dx, dy = item.worldX - worldX, item.worldY - worldY
        local distanceSq = dx * dx + dy * dy
        local forward = dx * sin + dy * cos
        if distanceSq <= limit and forward >= 0 then
            local angle = math.atan2(dy * sin - dx * cos, forward)
            local fade = math.min(1, (halfArc - math.abs(angle)) / .12)
            if fade > 0 then
                item.x, item.distanceSq, item.edgeAlpha = angle * span, distanceSq, fade
                projected[#projected + 1] = item
            end
        end
    end
end

local function setArt(marker, item)
    if marker.item == item then return end
    local icon = marker.icon
    if item.atlas then
        icon:SetAtlas(item.atlas)
    else
        icon:SetTexture(item.object and item.object.icon or item.texture)
    end
    if item.coords then icon:SetTexCoord(unpack(item.coords)) else icon:SetTexCoord(0, 1, 0, 1) end
    icon:SetVertexColor(item.r or 1, item.g or 1, item.b or 1)
    marker.item = item
end

local function draw(worldX, worldY, facing)
    local iconSize = options.pinSize
    local span = (frame:GetWidth() / 2 - math.max(10, iconSize / 2 + 2)) / halfArc
    local range, cos, sin = options.range, math.cos(facing), math.sin(facing)
    local limit = range * range
    wipe(projected)
    if worldX then
        project(candidates, worldX, worldY, sin, cos, limit, span)
        project(external, worldX, worldY, sin, cos, limit, span)
    end
    -- Keep the same hover target as a node moves across the compass.
    generation = generation + 1
    for _, item in ipairs(projected) do
        local marker = markers[item.key]
        if not marker then
            marker = table.remove(spareMarkers) or createMarker()
            markers[item.key] = marker
        end
        setArt(marker, item)
        if marker:GetWidth() ~= iconSize then marker:SetSize(iconSize, iconSize) end
        marker.generation, marker.distance = generation, math.sqrt(item.distanceSq)
        if marker.offset ~= item.x then
            marker:SetPoint("CENTER", compass, "CENTER", item.x, 0)
            marker.offset = item.x
        end
        if marker.edgeAlpha ~= item.edgeAlpha then
            marker:SetAlpha(item.edgeAlpha)
            marker.edgeAlpha = item.edgeAlpha
        end
        marker:Show()
    end
    for node, marker in pairs(markers) do
        if marker.generation ~= generation then
            marker:Hide()
            marker.item = nil
            markers[node] = nil
            spareMarkers[#spareMarkers + 1] = marker
        end
    end

    if hoveredMarker and GameTooltip:IsShown() and GameTooltip:IsOwned(hoveredMarker) then
        local yards = math.floor(hoveredMarker.distance + .5)
        if yards ~= hoveredMarker.tooltipYards then renderTooltip(hoveredMarker, yards) end
    end

    for i, tick in ipairs(ticks) do
        local angle = angleDelta(facing, (i - 1) * circle / #ticks)
        local visible = math.abs(angle) < halfArc
        tick:SetShown(visible)
        if visible then
            local x = angle * span
            local fade = math.min(1, (halfArc - math.abs(angle)) / .12)
            tick:SetPoint("CENTER", compass, "CENTER", x, tick.cardinal and 1 or 4 - options.height / 2)
            tick:SetAlpha(fade)
        end
    end
end

local function updateWidth()
    local screenWidth = UIParent:GetWidth()
    local width = options.fullWidth and screenWidth or math.min(options.width, screenWidth)
    if width > 20 and frame:GetWidth() ~= width then
        frame:SetWidth(width)
        drawFacing = nil
    end
end

local function update(_, elapsed)
    if options.fullWidth then updateWidth() end
    if moving then return end
    local facing = GetPlayerFacing and GetPlayerFacing()
    local hidden = (options.hideInInstances and IsInInstance())
        or (options.hideInCombat and InCombatLockdown())
        or (options.hideOnWorldMap and WorldMapFrame and WorldMapFrame:IsVisible())
    local available = not hidden and not addon.API.IsSecret(facing) and type(facing) == "number"
    bar:SetShown(available)
    if not available then
        dirty, displayedFacing, drawFacing = true, nil, nil
        return
    end

    local worldX, worldY, instance = HBD:GetPlayerWorldPosition()
    local mapID = HBD:GetPlayerZone()
    if not worldX or not worldY or not instance then worldX, worldY, instance = nil, nil, nil end
    pinTime = pinTime + elapsed
    local locationChanged = mapID ~= queryMap or instance ~= queryInstance
    local mirrorPins = options.externalPins or options.mirrorMinimap
    if dirty or locationChanged or (mirrorPins and pinTime >= .2) then
        pinTime = 0
        if refreshExternal(worldX, worldY, instance) then drawFacing = nil end
    end
    if dirty or locationChanged
        or (worldX and (not queryX or (worldX - queryX)^2 + (worldY - queryY)^2 >= queryStep^2)) then
        refreshNodes(worldX, worldY, mapID, instance)
        drawFacing = nil
    end

    -- Ease over small heading steps and take the short path across north.
    if displayedFacing then
        local delta = angleDelta(facing, displayedFacing)
        displayedFacing = math.abs(delta) < .0002 and facing
            or (displayedFacing + delta * (1 - math.exp(-elapsed / .022))) % circle
    else
        displayedFacing = facing
    end
    if displayedFacing ~= drawFacing or worldX ~= drawX or worldY ~= drawY then
        draw(worldX, worldY, displayedFacing)
        drawX, drawY, drawFacing = worldX, worldY, displayedFacing
    end
end

local function anchor()
    frame:ClearAllPoints()
    frame:SetPoint("TOP", UIParent, "TOP", options.fullWidth and 0 or options.x, options.y)
end

local function stopDrag()
    if not dragging then return end
    dragging = false
    frame:StopMovingOrSizing()
    local x, y = frame:GetCenter(), frame:GetTop()
    if x and y then
        if not options.fullWidth then options.x = x - UIParent:GetCenter() end
        options.y = y - UIParent:GetTop()
    end
    frame:SetUserPlaced(false)
    anchor()
end

function HUD:UpdateAppearance()
    if not frame then return end
    local color = options.backgroundColor
    local alpha = moving and math.max(.72, options.backgroundOpacity) or options.backgroundOpacity
    background:SetColorTexture(color.r, color.g, color.b, alpha)
    for _, border in ipairs(borders) do border:SetShown(options.showBorder) end
    frame:SetAlpha(moving and 1 or options.opacity)
end

local function create()
    frame = CreateFrame("Frame", "GatherLiteHUD", UIParent)
    frame:Hide()
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        if not moving then return end
        dragging = true
        frame:StartMoving()
    end)
    frame:SetScript("OnDragStop", stopDrag)
    frame:SetScript("OnMouseUp", function(_, button)
        if moving and button == "RightButton" then HUD:ToggleMove() end
    end)
    frame:SetScript("OnUpdate", update)
    frame:SetScript("OnShow", function() dirty = true end)
    frame:SetScript("OnHide", stopDrag)

    bar = CreateFrame("Frame", nil, frame)
    bar:SetAllPoints()
    bar:Hide()
    background = bar:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    for _, edge in ipairs({ "TOP", "BOTTOM" }) do
        local line = bar:CreateTexture(nil, "BORDER")
        line:SetPoint(edge .. "LEFT")
        line:SetPoint(edge .. "RIGHT")
        line:SetHeight(1)
        line:SetColorTexture(.65, .57, .42, .48)
        borders[#borders + 1] = line
    end

    compass = CreateFrame("Frame", nil, bar)
    compass:SetAllPoints()
    local center = compass:CreateTexture(nil, "OVERLAY")
    center:SetSize(2, 4)
    center:SetPoint("TOP", compass, "TOP", 0, 0)
    center:SetColorTexture(.92, .75, .42, 1)
    for i = 0, 23 do
        local tick
        if i % 6 == 0 then
            tick = compass:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            tick:SetText(directions[i / 6 + 1])
            tick.cardinal = true
        else
            tick = compass:CreateTexture(nil, "ARTWORK")
            tick:SetSize(1, i % 3 == 0 and 4 or 2)
            tick:SetColorTexture(.8, .72, .57, .65)
            tick:SetSnapToPixelGrid(false)
        end
        ticks[#ticks + 1] = tick
    end

    moveHint = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    moveHint:SetPoint("CENTER")
    moveHint:SetText(GatherLite:translate("settings.hud.move_hint"))
end

local function applySettings()
    options = GatherLite.db.char.hud
    if not options.enabled and not moving then
        if frame then
            stopDrag()
            frame:Hide()
        end
        return
    end

    if not frame then create() end
    if not dragging then anchor() end
    updateWidth()
    frame:SetHeight(options.height)
    HUD:UpdateAppearance()
    frame:SetFrameStrata(moving and "DIALOG" or "BACKGROUND")
    frame:EnableMouse(moving or false)
    moveHint:SetShown(moving or false)
    compass:SetShown(not moving)
    if moving then bar:Show() end
    dirty, displayedFacing, drawFacing = true, nil, nil
    frame:Show()
end

function HUD:ToggleMove()
    stopDrag()
    moving = not moving
    applySettings()
end

function HUD.setup()
    GatherLite:On("settings:update", applySettings)
    GatherLite:On("nodes:added", function() dirty = true end)
    applySettings()
end
