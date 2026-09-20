local addon={}
assert(loadfile("scripts/maps/zoom.lua"))("GatherLite",addon)
local Z=addon.MapZoom
local function close(a,b) assert(math.abs(a-b)<.000001,tostring(a).." ~= "..tostring(b)) end

-- Off-center cursor remains over the same map point, including reverse zoom.
local x,y=Z.Position(1,1.2,.5,.5,.4,.35,800,500,1000,668)
close((.4-.5)*1000,(.4-x)*1000*1.2)
close((.35-.5)*668,(.35-y)*668*1.2)
x,y=Z.Position(1.2,1,x,y,.4,.35,800,500,1000,668)
close(x,.5); close(y,.5)
-- Fully zoomed out: center both axes, including the one with letterboxing.
x,y=Z.Position(2,.5,.8,.2,.95,.01,800,500,1000,668)
close(x,.5); close(y,.5)
-- At an edge, keep the viewport inside the artwork.
x,y=Z.Position(2,1,.9,.1,1,0,800,500,1000,668)
close(x,.6); close(y,250/668)

local child={GetWidth=function() return 1000 end,GetHeight=function() return 668 end}
local scroll={scale=1,cx=.5,cy=.5,scripts={}}
function scroll:HasZoomLevels() return true end
function scroll:GetCanvasScale() return self.scale end
function scroll:GetScaleForMinZoom() return .8 end
function scroll:GetScaleForMaxZoom() return 3 end
function scroll:GetNormalizedHorizontalScroll() return self.cx end
function scroll:GetNormalizedVerticalScroll() return self.cy end
function scroll:GetNormalizedCursorPosition() return .4,.35 end
function scroll:GetWidth() return 800 end
function scroll:GetHeight() return 500 end
function scroll:CalculateScrollExtentsAtScale(scale)
    return 400/(1000*scale),1-400/(1000*scale),250/(668*scale),1-250/(668*scale)
end
function scroll:InstantPanAndZoom(scale,px,py,ignoreRatio)
    assert(ignoreRatio,"scale ratio applied twice")
    self.scale,self.cx,self.cy=scale,px,py
end
function scroll:EnableMouseWheel(v) self.wheel=v end
function scroll:SetScript(key,fn) self.scripts[key]=fn end
local map={ScrollContainer=scroll,GetCanvas=function() return child end}
Z.Attach(map)
assert(scroll.wheel)
scroll.scripts.OnMouseWheel(scroll,1)
close(scroll.scale,1.2)
scroll.scripts.OnMouseWheel(scroll,-1)
close(scroll.scale,1); close(scroll.cx,.5); close(scroll.cy,.5)
Z.Step(map,100); close(scroll.scale,3)
Z.Step(map,-100); close(scroll.scale,.8); close(scroll.cx,.5); close(scroll.cy,.5)
scroll.scale,scroll.cx,scroll.cy=2,.8,.2
scroll:ResetZoom()
close(scroll.scale,.8); close(scroll.cx,.5); close(scroll.cy,.5)
local l,r,t,b=scroll:CalculateScrollExtentsAtScale(.1)
close(l,.5); close(r,.5); close(t,.5); close(b,.5)
print("Map zoom checks passed: cursor anchoring, reverse zoom, edge clamping, bounds, wheel/buttons and resize reset")
