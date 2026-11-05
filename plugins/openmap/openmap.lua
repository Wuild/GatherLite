local _, addon = ...
local OpenMap = { minPinZoom = 9, pins = {}, pool = {}, rects = {}, cells = {} }
addon.OpenMap = OpenMap

local kinds = { "mining", "herbalism", "containers", "fishing" }
local EDGE_MARGIN, HOVER_CELL = 48, 32

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
    pin.texture:Hide()
    self.pool[#self.pool + 1] = pin.texture
    node.loadedWorldmap = false
    if self.hovered == node then self:ClearHover() end
end

function OpenMap:Clear()
    self:ClearHover()
    for node, pin in pairs(self.pins) do self:Release(node, pin) end
    if self.layer then self.layer:Hide() end
    self.bounds, self.cells, self.sx, self.sy = nil, {}, nil, nil
end

function OpenMap:CreateLayer(scroll)
    self.layer = CreateFrame("Frame", nil, scroll)
    self.layer:SetAllPoints(scroll)
    self.layer:SetClipsChildren(true)
    self.layer:EnableMouse(false)
    self.content = CreateFrame("Frame", nil, self.layer)
    self.content:SetSize(1, 1)
    self.content:EnableMouse(false)
    self.hoverFrame = CreateFrame("Frame", nil, self.content)
    self.hoverFrame:SetSize(1, 1)
    self.hoverFrame:EnableMouse(false)
    self.hoverFrame.type = "worldmap"
end

function OpenMap:PlacePin(node, rect, resize, options, visible)
    local pin = self.pins[node]
    if not pin then
        local object = GatherLite:GetNodeObject(node.object)
        if not object or not object.icon then return end
        local texture = table.remove(self.pool) or self.content:CreateTexture(nil, "ARTWORK")
        pin = { texture = texture, object = object, node = node }
        self.pins[node] = pin
        texture:SetTexture(object.icon)
        texture:Show()
        node.loadedWorldmap = true
    end
    local texture = pin.texture
    if not pin.x or resize then
        pin.x = (rect.u + node.posX * rect.width - self.originU) * self.sx
        pin.y = -(rect.v + node.posY * rect.height - self.originV) * self.sy
        texture:SetPoint("CENTER", self.content, "TOPLEFT", pin.x, pin.y)
    end
    if pin.size ~= options.size then pin.size = options.size; texture:SetSize(options.size, options.size) end
    if pin.alpha ~= options.opacity then pin.alpha = options.opacity; texture:SetAlpha(options.opacity) end
    visible[node] = true
    local cx, cy = math.floor(pin.x / HOVER_CELL), math.floor(pin.y / HOVER_CELL)
    local column = self.cells[cx]
    if not column then column = {}; self.cells[cx] = column end
    local cell = column[cy]
    if not cell then cell = {}; column[cy] = cell end
    cell[#cell + 1] = pin
end

function OpenMap:Refill(bounds, resize, options)
    local visible = {}
    self.cells = {}
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
                        local nodes = GatherLite:GetNodesForMapRect(kind, id,
                            (bounds.left - rect.u) / rect.width, (bounds.right - rect.u) / rect.width,
                            (bounds.top - rect.v) / rect.height, (bounds.bottom - rect.v) / rect.height)
                        for _, node in ipairs(nodes) do
                            if (not node.predefined or GatherLite.db.global.usePredefined)
                                and not GatherLite:IsIgnored(node.object) then
                                self:PlacePin(node, rect, resize, options, visible)
                            end
                        end
                    end
                end
            end
        end
    end
    for node, pin in pairs(self.pins) do
        if not visible[node] then self:Release(node, pin) end
    end
    self.bounds, self.dirty = bounds, false
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
    x, y = x - self.offsetX, y - self.offsetY
    local radius = math.max(9, options.size / 2)
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

function OpenMap:Update()
    if not self:IsStitched() or not WorldMapFrame:IsVisible() then self:Clear(); return end
    if self.api ~= OpenMapAPI then
        self:Clear()
        self.api, self.rects = OpenMapAPI, {}
    end
    local options = GatherLite.db.char.worldmap
    local _, _, zoom = OpenMapAPI.GetView()
    if not options.enabled or not zoom or zoom < self.minPinZoom then
        if self.bounds then self:Clear() end
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

    local resize = not self.sx or math.abs(self.sx - g.sx) > 1e-6 or math.abs(self.sy - g.sy) > 1e-6
    if resize then
        self.sx, self.sy, self.originU, self.originV = g.sx, g.sy, g.u, g.v
    end
    local x = g.x + (self.originU - g.u) * g.sx
    local y = g.y - (self.originV - g.v) * g.sy
    if x ~= self.offsetX or y ~= self.offsetY then
        self.offsetX, self.offsetY = x, y
        self.content:SetPoint("TOPLEFT", self.layer, "TOPLEFT", x, y)
    end
    local left, right = g.u - g.x / g.sx, g.u + (g.width - g.x) / g.sx
    local top, bottom = g.v + g.y / g.sy, g.v + (g.height + g.y) / g.sy
    local bounds = self.bounds
    if self.dirty or resize or not bounds or left < bounds.left or right > bounds.right
        or top < bounds.top or bottom > bounds.bottom then
        self:Refill({ left = left - EDGE_MARGIN / g.sx, right = right + EDGE_MARGIN / g.sx,
            top = top - EDGE_MARGIN / g.sy, bottom = bottom + EDGE_MARGIN / g.sy }, resize, options)
    end
    self:UpdateHover(g, options)
end
