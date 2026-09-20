local _, addon = ...
local Zoom = {}
addon.MapZoom = Zoom

local function clampCenter(center, visibleFraction)
    local half = visibleFraction / 2
    -- A viewport wider/taller than the artwork must center that axis.
    if half >= .5 then return .5 end
    return math.max(half, math.min(1 - half, center))
end

-- Preserve the map point under the cursor while changing scale. Clamp both
-- axes at the NEW scale, including letterboxed axes with inverted extents.
function Zoom.Position(oldScale, newScale, centerX, centerY, anchorX, anchorY,
    viewWidth, viewHeight, canvasWidth, canvasHeight)
    local ratio = oldScale / newScale
    local x = anchorX + (centerX - anchorX) * ratio
    local y = anchorY + (centerY - anchorY) * ratio
    return clampCenter(x, viewWidth / (canvasWidth * newScale)),
        clampCenter(y, viewHeight / (canvasHeight * newScale))
end

function Zoom.Step(map, delta, atCursor)
    local scroll, canvas = map.ScrollContainer, map:GetCanvas()
    if not scroll:HasZoomLevels() then return end
    local oldScale = scroll:GetCanvasScale()
    local minScale, maxScale = scroll:GetScaleForMinZoom(), scroll:GetScaleForMaxZoom()
    local scale = math.max(minScale, math.min(maxScale, oldScale * 1.2 ^ delta))
    local width, height = canvas:GetWidth(), canvas:GetHeight()
    if oldScale <= 0 or scale <= 0 or width <= 0 or height <= 0 then return end
    local centerX, centerY = scroll:GetNormalizedHorizontalScroll(), scroll:GetNormalizedVerticalScroll()
    local anchorX, anchorY = centerX, centerY
    if atCursor then anchorX, anchorY = scroll:GetNormalizedCursorPosition() end
    local x, y = Zoom.Position(oldScale, scale, centerX, centerY, anchorX, anchorY,
        scroll:GetWidth(), scroll:GetHeight(), width, height)
    scroll.zoomTarget = scale
    -- The position above already accounts for the scale ratio.
    scroll:InstantPanAndZoom(scale, x, y, true)
end

function Zoom.Attach(map)
    local scroll = map.ScrollContainer
    local originalExtents = scroll.CalculateScrollExtentsAtScale
    function scroll:CalculateScrollExtentsAtScale(scale)
        local left, right, top, bottom = originalExtents(self, scale)
        if left > right then left, right = .5, .5 end
        if top > bottom then top, bottom = .5, .5 end
        return left, right, top, bottom
    end
    -- Native ResetZoom blends the old pan into the new center unless told not to.
    function scroll:ResetZoom()
        if not self:HasZoomLevels() then return end
        local scale = self:GetScaleForMinZoom()
        self.zoomTarget = scale
        self:InstantPanAndZoom(scale, .5, .5, true)
    end
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(_, delta) Zoom.Step(map, delta, true) end)
end
