local _, addon = ...
local OpenMap = { pins = {}, pool = {}, rects = {}, cells = {} }
addon.OpenMap = OpenMap

function OpenMap:GetMinPinZoom()
    return GatherLite.db.profile.worldmap.openMapPinZoom or 7
end

local kinds = { "mining", "herbalism", "containers", "fishing" }
local EDGE_MARGIN, HOVER_CELL = 48, 32
-- Bound texture work even when the client profiling timer is unavailable.
local REFILL_BATCH, REFILL_MS = 128, 2
local BUSY_VIEW_PINS, DENSE_REFRESH_INTERVAL = 320, .1

function OpenMap:IsStitched()
    local api = OpenMapAPI
    return api and api.major == 1 and api.WorldFromMap and api.GetView and api.IsStitched()
end

function OpenMap:GetRect(id)
    if self.rects[id] == nil then
        local u, v = OpenMapAPI.WorldFromMap(id, 0, 0)
        local right, bottom = OpenMapAPI.WorldFromMap(id, 1, 1)
        self.rects[id] = u and right and right > u and bottom > v
            and { u = u, v = v, width = right - u, height = bottom - v } or false
    end
    return self.rects[id]
end

function OpenMap:GetGeometry()
    local map = WorldMapFrame
    local scroll, canvas = map.ScrollContainer, map:GetCanvas()
    local id = map:GetMapID()
    local rect = id and self:GetRect(id)
    if not rect or not canvas or not scroll then return end
    local width, height = scroll:GetWidth(), scroll:GetHeight()
    local cw, ch = canvas:GetWidth(), canvas:GetHeight()
    local left, top = scroll:GetLeft(), scroll:GetTop()
    local x, y = canvas:GetLeft(), canvas:GetTop()
    if not (left and top and x and y) or math.min(width, height, cw, ch) <= 0 then return end
    local scale = scroll:GetEffectiveScale()
    local ratio = canvas:GetEffectiveScale() / scale
    return { u = rect.u, v = rect.v, sx = cw * ratio / rect.width, sy = ch * ratio / rect.height,
        x = x * ratio - left, y = y * ratio - top, width = width, height = height,
        left = left, top = top, scale = scale }
end

function OpenMap:ClearHover()
    if self.hovered and GameTooltip:IsOwned(self.hoverFrame) then GatherLite:hideTooltip() end
    self.hovered = nil
end

function OpenMap:Release(node, pin)
    self.pins[node] = nil
    pin.fade:Stop()
    pin.texture:Hide()
    self.pool[#self.pool + 1] = pin
    pin.node, pin.object, pin.projection = nil, nil, nil
    node.loadedWorldmap = false
    if self.hovered == node then self:ClearHover() end
end

function OpenMap:Clear()
    self.refill = nil
    self.reprojecting = nil
    self.zoomRefill = nil
    self.dense = nil
    self.refillDelay, self.zoomQuiet = nil, nil
    self:ClearHover()
    for node, pin in pairs(self.pins) do self:Release(node, pin) end
    if self.layer then
        self.layer:Hide()
        self.origin:Show()
    end
    self.bounds, self.cells, self.sx, self.sy = nil, {}, nil, nil
    self.offsetX, self.offsetY = nil, nil
end

function OpenMap:HideLayer()
    self:ClearHover()
    if self.layer then self.layer:Hide() end
end

function OpenMap:Park()
    if self.refill or self.reprojecting then
        self:Clear()
    elseif self.layer and self.layer:IsShown() then
        self:HideLayer()
    end
end

function OpenMap:CreateLayer(scroll)
    self.layer = CreateFrame("Frame", nil, scroll)
    self.layer:SetAllPoints(scroll)
    self.layer:SetClipsChildren(true)
    self.layer:EnableMouse(false)
    -- Icon textures inherit the viewport scale. Their invisible anchors
    -- inherit the map zoom, so only their centers move when zoom changes.
    self.origin = CreateFrame("Frame", nil, self.layer)
    self.origin:SetSize(1, 1)
    self.origin:EnableMouse(false)
    self.content = CreateFrame("Frame", nil, self.origin)
    self.content:SetPoint("TOPLEFT", self.origin, "TOPLEFT")
    self.content:SetSize(1, 1)
    self.content:EnableMouse(false)
    self.hoverFrame = CreateFrame("Frame", nil, self.content)
    self.hoverFrame:SetSize(1, 1)
    self.hoverFrame:EnableMouse(false)
    self.hoverFrame.type = "worldmap"
end

function OpenMap:PlacePin(node, rect, object, options)
    local pin = self.pins[node]
    local new = not pin
    if not pin then
        pin = table.remove(self.pool)
        if not pin then
            local anchor = self.content:CreateTexture()
            anchor:SetSize(1, 1)
            anchor:Hide()
            local texture = self.origin:CreateTexture(nil, "ARTWORK")
            texture:SetPoint("CENTER", anchor, "CENTER")
            local fade = texture:CreateAnimationGroup()
            local alpha = fade:CreateAnimation("Alpha")
            alpha:SetDuration(.18)
            alpha:SetFromAlpha(0)
            pin = { texture = texture, anchor = anchor, fade = fade, fadeAlpha = alpha }
        end
        pin.object, pin.node = object, node
        self.pins[node] = pin
        node.loadedWorldmap = true
    end
    local texture = pin.texture
    if pin.icon ~= object.icon then pin.icon = object.icon; texture:SetTexture(object.icon) end
    if pin.projection ~= self.projection then
        pin.projection = self.projection
        pin.x = (rect.u + node.posX * rect.width - self.originU) * self.sx
        pin.y = -(rect.v + node.posY * rect.height - self.originV) * self.sy
        pin.anchor:SetPoint("CENTER", self.content, "TOPLEFT", pin.x, pin.y)
    end
    local size = options.size
    if pin.size ~= size then pin.size = size; texture:SetSize(size, size) end
    if pin.alpha ~= options.opacity then pin.alpha = options.opacity; texture:SetAlpha(options.opacity) end
    if new then
        pin.fadeAlpha:SetToAlpha(options.opacity)
        texture:Show()
        pin.fade:Play()
    end
    local cx, cy = math.floor(pin.x / HOVER_CELL), math.floor(pin.y / HOVER_CELL)
    local column = self.cells[cx]
    if not column then column = {}; self.cells[cx] = column end
    local cell = column[cy]
    if not cell then cell = {}; column[cy] = cell end
    cell[#cell + 1] = pin
end

function OpenMap:Refill(bounds, options, keepExisting)
    local visible, objects, batches = {}, {}, {}
    local count = 0
    local work = 0
    local started = debugprofilestop and debugprofilestop()
    local function step()
        work = work + 1
        if work >= REFILL_BATCH or (started and work % 16 == 0 and debugprofilestop() - started >= REFILL_MS) then
            coroutine.yield()
            work = 0
            started = debugprofilestop and debugprofilestop()
        end
    end
    for _, kind in ipairs(kinds) do
        local index = addon.nodeIndex[kind]
        if index and GatherLite:GetNodeTracking("worldmap", kind) then
            for id in pairs(index.byMap) do
                local rect = self:GetRect(id)
                if rect and rect.u <= bounds.right and rect.u + rect.width >= bounds.left
                    and rect.v <= bounds.bottom and rect.v + rect.height >= bounds.top then
                    local zone = addon.zoneTree and addon.zoneTree[id]
                    local info = C_Map.GetMapInfo(id)
                    if info and info.mapType == 3 and (not zone or zone.system == 0) then
                        local left, right = (bounds.left - rect.u) / rect.width, (bounds.right - rect.u) / rect.width
                        local top, bottom = (bounds.top - rect.v) / rect.height, (bounds.bottom - rect.v) / rect.height
                        -- Wide views often contain entire zones. Reuse the indexed list
                        -- instead of copying it into a temporary rectangle result.
                        local nodes = left <= 0 and right >= 1 and top <= 0 and bottom >= 1 and index.byMap[id]
                            or GatherLite:GetNodesForMapRect(kind, id, left, right, top, bottom)
                        batches[#batches + 1] = { nodes = nodes, rect = rect }
                        count = count + #nodes
                    end
                end
            end
        end
    end

    self.dense = count > BUSY_VIEW_PINS
    self.cells = {}

    for _, batch in ipairs(batches) do
        local rect = batch.rect
        for _, node in ipairs(batch.nodes) do
            if not node.predefined or GatherLite.db.global.usePredefined then
                local object = objects[node.object]
                if object == nil then
                    object = not GatherLite:IsIgnored(node.object) and GatherLite:GetNodeObject(node.object)
                    object = object and object.icon and object or false
                    objects[node.object] = object
                end
                if object then
                    visible[node] = true
                    self:PlacePin(node, rect, object, options)
                end
            end
            step()
        end
    end
    if not keepExisting then
        for node, pin in pairs(self.pins) do
            if not visible[node] then self:Release(node, pin) end
            step()
        end
    end
end

function OpenMap:UpdateHover(g, options)
    local map = WorldMapFrame
    for _, pin in ipairs(map.currentPoIPins or {}) do
        if GameTooltip:IsOwned(pin) then self:ClearHover(); return end
    end
    local x, y
    local scroll = map.ScrollContainer
    if InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled()
        and map.IsMapFocused and map:IsMapFocused() and scroll.GetGamepadCursorPosition then
        x, y = scroll:GetGamepadCursorPosition()
    elseif GetCursorPosition and (not map.IsCanvasMouseFocus or map:IsCanvasMouseFocus()) then
        x, y = GetCursorPosition()
        if x then x, y = x / g.scale, y / g.scale end
    end
    if not x then self:ClearHover(); return end
    x, y = x - g.left, y - g.top
    if x < 0 or x > g.width or y > 0 or y < -g.height then self:ClearHover(); return end
    local scale = self.contentScale
    x, y = (x - self.offsetX) / scale, (y - self.offsetY) / scale
    local radius = math.max(9, options.size / 2) / scale
    local nearest, distance = nil, radius * radius
    for cx = math.floor((x - radius) / HOVER_CELL), math.floor((x + radius) / HOVER_CELL) do
        local column = self.cells[cx]
        if column then
            for cy = math.floor((y - radius) / HOVER_CELL), math.floor((y + radius) / HOVER_CELL) do
                for _, pin in ipairs(column[cy] or {}) do
                    local d = (pin.x - x)^2 + (pin.y - y)^2
                    if d <= distance then nearest, distance = pin, d end
                end
            end
        end
    end
    if nearest and (self.hovered ~= nearest.node or not GameTooltip:IsOwned(self.hoverFrame)) then
        self.hovered = nearest.node
        self.hoverFrame.node, self.hoverFrame.object = nearest.node, nearest.object
        self.hoverFrame:SetPoint("CENTER", self.content, "TOPLEFT", nearest.x, nearest.y)
        GatherLite:showTooltip(self.hoverFrame)
    elseif not nearest then
        self:ClearHover()
    end
end

function OpenMap:Update(elapsed)
    if not WorldMapFrame:IsVisible() then self:Park(); return end
    if not self:IsStitched() then self:Clear(); return end
    if self.api ~= OpenMapAPI then
        self:Clear()
        self.api, self.rects = OpenMapAPI, {}
    end
    local options = GatherLite.db.profile.worldmap
    local _, _, zoom = OpenMapAPI.GetView()
    if not options.enabled then
        if self.bounds then self:Clear() end
        return
    end
    if not zoom or zoom < self:GetMinPinZoom() then
        -- Keep prepared pins and pause any unfinished refill while zoomed out.
        self:HideLayer()
        return
    end
    local g = self:GetGeometry()
    if not g then self:Clear(); return end
    local scroll = WorldMapFrame.ScrollContainer
    if not self.layer then self:CreateLayer(scroll) end
    local art = OpenMapAPI.ArtTopLevel and OpenMapAPI.ArtTopLevel()
    local level = math.max(scroll:GetFrameLevel() + 100, (art or 0) + 2)
    if self.layer:GetFrameLevel() ~= level and not InCombatLockdown() then self.layer:SetFrameLevel(level) end
    self.layer:Show()

    local scale = self.sx and g.sx / self.sx or 1
    local reproject = not self.sx or math.abs(g.sy / self.sy - scale) > 1e-6
    if reproject then
        if next(self.pins) then
            -- Keep the old projection offscreen until all retained pins have
            -- been reanchored and pins outside the new viewport are removed.
            self.reprojecting = true
            self:ClearHover()
            self.origin:Hide()
        end
        self.sx, self.sy, self.originU, self.originV = g.sx, g.sy, g.u, g.v
        -- A cancelled refill can leave pins from more than one projection.
        self.projection = (self.projection or 0) + 1
        scale = 1
    end
    local zoomChanged = self.contentScale ~= scale
    if zoomChanged then
        self.contentScale = scale
        self.content:SetScale(scale)
    end
    local x = g.x + (self.originU - g.u) * g.sx
    local y = g.y - (self.originV - g.v) * g.sy
    if x ~= self.offsetX or y ~= self.offsetY then
        self.offsetX, self.offsetY = x, y
        self.origin:SetPoint("TOPLEFT", self.layer, "TOPLEFT", x, y)
    end
    local left, right = g.u - g.x / g.sx, g.u + (g.width - g.x) / g.sx
    local top, bottom = g.v + g.y / g.sy, g.v + (g.height + g.y) / g.sy
    local bounds = self.bounds
    -- During a covered zoom the parent transform is enough. When the view
    -- expands, load newly exposed pins but defer pruning until zoom settles.
    elapsed = elapsed or DENSE_REFRESH_INTERVAL
    self.refillDelay = math.max(0, (self.refillDelay or 0) - elapsed)
    self.zoomQuiet = zoomChanged and DENSE_REFRESH_INTERVAL or math.max(0, (self.zoomQuiet or 0) - elapsed)
    local defer = self.dense and self.zoomQuiet > 0 and not self.dirty and not reproject and not self.reprojecting
    if defer then self.zoomRefill = true end
    local canRefill = self.dirty or reproject or not self.dense
        or (self.refillDelay == 0 and (not self.refill or self.zoomRefill))
    if not defer and canRefill and (self.dirty or reproject or (self.zoomRefill and not zoomChanged)
        or not bounds or left < bounds.left or right > bounds.right
        or top < bounds.top or bottom > bounds.bottom) then
        self.bounds = { left = left - EDGE_MARGIN / g.sx, right = right + EDGE_MARGIN / g.sx,
            top = top - EDGE_MARGIN / g.sy, bottom = bottom + EDGE_MARGIN / g.sy }
        local keepExisting = zoomChanged and not self.dirty and not reproject and not self.reprojecting
        self.dirty, self.zoomRefill = false, keepExisting
        self.refillDelay = DENSE_REFRESH_INTERVAL
        self.refill = coroutine.create(function() self:Refill(self.bounds, options, keepExisting) end)
    end
    if self.refill and not defer then
        local ok, err = coroutine.resume(self.refill)
        if not ok or coroutine.status(self.refill) == "dead" then self.refill = nil end
        if not ok then
            self:Clear()
            error(err, 0)
        end
    end
    if self.reprojecting then
        if self.refill then return end
        self.reprojecting = nil
        self.origin:Show()
    end
    self:UpdateHover(g, options)
end
