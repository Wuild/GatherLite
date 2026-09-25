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

function Routes:GetViewport(map)
    local scroll, canvas = map.ScrollContainer, map:GetCanvas()
    local scale = map:GetCanvasScale()
    local width, height = canvas:GetWidth(), canvas:GetHeight()
    if not scale or scale <= 0 or width <= 0 or height <= 0 then return end
    local left = scroll:GetHorizontalScroll() / width
    local top = scroll:GetVerticalScroll() / height
    return left, left + scroll:GetWidth() / (width * scale),
        top, top + scroll:GetHeight() / (height * scale)
end

-- Draw in viewport coordinates above exploration art. Canvas children can be
-- buried beneath Blizzard's exploration pin, and their scale changes on zoom.
function Routes:DrawOnCanvas(frame, map, object)
    local mapID=map:GetMapID()
    local route, count = (self.byMap and self.byMap[mapID]) or self.active, 0
    local info=mapID and C_Map.GetMapInfo(mapID)
    -- Routes belong to one resource in one zone. Never project a fallback
    -- circuit into another map, including adjacent zones with overlapping art.
    if route and route.mapID==mapID and (object==nil or route.object==object)
        and info and info.mapType==3 and GatherLite.db.char.routeVisible ~= false then
        local scroll = map.ScrollContainer
        local left, right, top, bottom = self:GetViewport(map)
        if left and right and top and bottom then
            left, right = math.min(left, right), math.max(left, right)
            top, bottom = math.min(top, bottom), math.max(top, bottom)
            local width, height = frame:GetWidth(), frame:GetHeight()
            if right > left and bottom > top then
                for i, a in ipairs(route.points) do
                    local b = route.points[i % #route.points + 1]
                    local x1, y1 = self:Project(a, route.mapID, map:GetMapID())
                    local x2, y2 = self:Project(b, route.mapID, map:GetMapID())
                    if x1 and y1 and x2 and y2 then
                        x1, y1, x2, y2 = Planner.ClipRect(x1, y1, x2, y2, left, right, top, bottom)
                        if x1 then
                            count = count + 1
                            self:DrawLine(frame, count,
                                (x1-left)/(right-left)*width, -(y1-top)/(bottom-top)*height,
                                (x2-left)/(right-left)*width, -(y2-top)/(bottom-top)*height)
                        end
                    end
                end
            end
        end
    end
    self:FinishLines(frame, count)
end

local outdoor = { [0] = 466 + 2/3, 400, 333 + 1/3, 266 + 2/6, 200, 133 + 1/3 }
local indoor = { [0] = 300, 240, 180, 120, 80, 50 }

function Routes:Draw(elapsed)
    elapsedTotal = (elapsedTotal or 0) + elapsed
    if elapsedTotal < .03 then return end
    elapsedTotal = 0
    local route = self.active or (self.byMap and self.byMap[self.bestMapID])
    if not route or GatherLite.db.char.routeVisible == false then hide(world); hide(mini); return end
    if WorldMapFrame:IsShown() then
        world = world or overlay(WorldMapFrame.ScrollContainer)
        world:Show()
        self:DrawOnCanvas(world, WorldMapFrame)
    else hide(world) end

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
    for i, point in ipairs(route.points) do
        local x1, y1 = project(point)
        local x2, y2 = project(route.points[i % #route.points + 1])
        x1, y1, x2, y2 = clip(x1, y1, x2, y2)
        if x1 then
            count = count + 1
            self:DrawLine(mini, count, width*(1+x1), -height*(1+y1), width*(1+x2), -height*(1+y2))
        end
    end
    self:FinishLines(mini, count)
end
