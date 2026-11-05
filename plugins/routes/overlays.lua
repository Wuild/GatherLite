local _, addon = ...
local Routes, Planner = addon.Routes, addon.RoutePlanner
local HBD = LibStub("HereBeDragons-2.0")
local world, mini, elapsedTotal

local function overlay(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetAllPoints()
    frame:SetFrameLevel(parent:GetFrameLevel() + 100)
    frame:EnableMouse(false)
    frame.lines = {}
    return frame
end
local function hide(frame) if frame then frame:Hide() end end

function Routes:DrawLine(frame, index, x1, y1, x2, y2)
    local line = frame.lines[index]
    if not line then
        line = frame:CreateLine(nil, "OVERLAY")
        line:SetColorTexture(1, .78, .12, 1)
        line:SetThickness(2)
        frame.lines[index] = line
    end
    line:SetStartPoint("TOPLEFT", x1, y1)
    line:SetEndPoint("TOPLEFT", x2, y2)
    line:Show()
end

function Routes:FinishLines(frame, count)
    for i = count + 1, #frame.lines do frame.lines[i]:Hide() end
end

function Routes:Project(point, sourceMapID, targetMapID)
    if sourceMapID == targetMapID then return point.u, point.v end
    return HBD:GetZoneCoordinatesFromWorldInstance(point.x, point.y, point.instance, targetMapID, true)
end

function Routes:GetViewport(map, stitched)
    local scroll, canvas = map.ScrollContainer, map:GetCanvas()
    local width, height = canvas:GetWidth(), canvas:GetHeight()
    if stitched then
        -- OpenMap anchors the host canvas as it pans, including beyond its bounds.
        local scale = scroll:GetEffectiveScale() / canvas:GetEffectiveScale()
        local scrollLeft, scrollTop, canvasLeft, canvasTop = scroll:GetLeft(), scroll:GetTop(), canvas:GetLeft(), canvas:GetTop()
        if not (scrollLeft and scrollTop and canvasLeft and canvasTop) or width <= 0 or height <= 0 then return end
        local left = (scrollLeft * scale - canvasLeft) / width
        local top = (canvasTop - scrollTop * scale) / height
        return left, left + scroll:GetWidth() * scale / width, top, top + scroll:GetHeight() * scale / height
    end
    local scale = map:GetCanvasScale()
    if not scale or scale <= 0 or width <= 0 or height <= 0 then return end
    local left = scroll:GetHorizontalScroll() / width
    local top = scroll:GetVerticalScroll() / height
    return left, left + scroll:GetWidth() / (width * scale),
        top, top + scroll:GetHeight() / (height * scale)
end

local function stitchedProjection(api, zone, host)
    local u1, v1 = api.WorldFromMap(zone, 0, 0)
    local u2, v2 = api.WorldFromMap(zone, 1, 1)
    if not (u1 and u2) then return end
    local x1, y1 = api.MapFromWorld(host, u1, v1)
    local x2, y2 = api.MapFromWorld(host, u2, v2)
    if not (x1 and x2) then return end
    return function(point) return x1 + point.u * (x2 - x1), y1 + point.v * (y2 - y1) end
end

-- Draw in viewport coordinates above exploration art. Canvas children can be
-- buried beneath Blizzard's exploration pin, and their scale changes on zoom.
function Routes:DrawOnCanvas(frame, map, object, stitched)
    local mapID=map:GetMapID()
    local route, count = (self.byMap and self.byMap[mapID]) or self.active, 0
    local info=route and C_Map.GetMapInfo(route.mapID)
    local rendered = false
    -- A stitched view can show the active zone's route even when another zone hosts the canvas.
    if route and (stitched or route.mapID==mapID) and (object==nil or route.object==object)
        and info and info.mapType==3 and GatherLite.db.char.routeVisible ~= false then
        local left, right, top, bottom = self:GetViewport(map, stitched)
        if left and right > left and bottom > top then
            local width, height = frame:GetWidth(), frame:GetHeight()
            local geometry = route.geometry or route.points
            local state = frame.routeDrawState
            if state and state.route == route and state.geometry == geometry and state.mapID == mapID
                and state.stitched == stitched and state.left == left and state.right == right
                and state.top == top and state.bottom == bottom and state.width == width and state.height == height then return end
            local project
            if stitched and route.mapID ~= mapID then
                project = stitchedProjection(stitched, route.mapID, mapID)
            else
                project = function(point) return point.u, point.v end
            end
            if project then
                state = state or {}
                state.route, state.geometry, state.mapID, state.stitched = route, geometry, mapID, stitched
                state.left, state.right, state.top, state.bottom = left, right, top, bottom
                state.width, state.height = width, height
                frame.routeDrawState, rendered = state, true
                local sx, sy = width / (right - left), height / (bottom - top)
                local segments = route.geometry and #geometry - 1 or #geometry
                local x1, y1 = project(geometry[1])
                for i = 1, segments do
                    local x2, y2 = project(geometry[i % #geometry + 1])
                    local a, b, c, d = Planner.ClipRect(x1, y1, x2, y2, left, right, top, bottom)
                    if a then
                        count = count + 1
                        self:DrawLine(frame, count, (a - left) * sx, -(b - top) * sy, (c - left) * sx, -(d - top) * sy)
                    end
                    x1, y1 = x2, y2
                end
            end
        end
    end
    if not rendered then frame.routeDrawState = nil end
    self:FinishLines(frame, count)
end

local outdoor = { [0] = 466 + 2/3, 400, 333 + 1/3, 266 + 2/6, 200, 133 + 1/3 }
local indoor = { [0] = 300, 240, 180, 120, 80, 50 }

function Routes:Draw(elapsed)
    local route = self.active or (self.byMap and self.byMap[self.bestMapID])
    if not route or GatherLite.db.char.routeVisible == false then hide(world); hide(mini); return end
    if WorldMapFrame:IsShown() then
        local scroll, api = WorldMapFrame.ScrollContainer, OpenMapAPI
        local stitched = api and api.major == 1 and api.IsStitched() and api or nil
        world = world or overlay(scroll)
        local art = stitched and stitched.ArtTopLevel and stitched.ArtTopLevel()
        local level = math.max(scroll:GetFrameLevel() + 100, (art or 0) + 1)
        if world:GetFrameLevel() ~= level and not InCombatLockdown() then world:SetFrameLevel(level) end
        world:Show()
        self:DrawOnCanvas(world, WorldMapFrame, nil, stitched)
    else hide(world) end

    -- The world map follows the canvas every frame. Keep the minimap's slower cadence.
    elapsedTotal = (elapsedTotal or 0) + elapsed
    if elapsedTotal < .03 then return end
    elapsedTotal = 0
    local px, py, instance = HBD:GetPlayerWorldPosition()
    local _, _, mapID = HBD:GetPlayerZonePosition()
    route = (self.byMap and self.byMap[mapID]) or route
    if not Minimap:IsVisible() or not px or not py or instance ~= route.points[1].instance
        or mapID ~= route.mapID or IsInInstance() then hide(mini); return end
    local radius
    if C_Minimap and C_Minimap.GetViewRadius then radius = C_Minimap.GetViewRadius() end
    if not radius or radius <= 0 then
        local sizes = tonumber(GetCVar("minimapZoom")) == Minimap:GetZoom() and outdoor or indoor
        radius = (sizes[Minimap:GetZoom()] or sizes[0]) / 2
    end
    local facing = 0
    if GetCVar("rotateMinimap") == "1" then
        facing = GetPlayerFacing()
        if not facing then hide(mini); return end
    end
    local cos, sin = math.cos(facing), math.sin(facing)
    local function project(point)
        local dx, dy = (px - point.x) / radius, (py - point.y) / radius
        return dx * cos - dy * sin, dx * sin + dy * cos
    end
    mini = mini or overlay(Minimap)
    mini:Show()
    local width, height, count = Minimap:GetWidth()/2, Minimap:GetHeight()/2, 0
    local clip = GetMinimapShape and GetMinimapShape() == "SQUARE" and Planner.ClipSquare or Planner.ClipCircle
    local geometry = route.geometry or route.points
    local segments = route.geometry and #geometry - 1 or #geometry
    for i = 1, segments do
        local point = geometry[i]
        local x1, y1 = project(point)
        local x2, y2 = project(geometry[i % #geometry + 1])
        x1, y1, x2, y2 = clip(x1, y1, x2, y2)
        if x1 then
            count = count + 1
            self:DrawLine(mini, count, width*(1+x1), -height*(1+y1), width*(1+x2), -height*(1+y2))
        end
    end
    self:FinishLines(mini, count)
end
