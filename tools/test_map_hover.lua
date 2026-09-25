local addon={}
local enabled,focused,cursorShown=true,true,true
local x,y=100,100
InputUtil={IsGamepadUIEnabled=function() return enabled end}
SoftCursor={IsVisible=function() return cursorShown end,
    GetCenter=function() return x,y end,GetEffectiveScale=function() return 1 end}
WorldMapFrame={scripts={},visible=true,currentPoIPins={},ScrollContainer={GetGamepadCursorPosition=function() return x,y end}}
function WorldMapFrame:IsVisible() return self.visible end
function WorldMapFrame:IsMapFocused() return focused end
function WorldMapFrame:HookScript(event,fn) self.scripts[event]=fn end
GameTooltip={}
function GameTooltip:IsOwned(pin) return self.owner==pin end
local entered,left=0,0
local function pin(px,py)
    local p={shown=true,x=px,y=py,type="worldmap",node={}}
    function p:IsVisible() return self.shown end
    function p:GetWidth() return 16 end
    function p:GetCenter() return self.x,self.y end
    function p:GetScript(event)
        if event=="OnEnter" then return function(self) entered=entered+1; GameTooltip.owner=self end end
        return function() left=left+1; GameTooltip.owner=nil end
    end
    return p
end
assert(loadfile("scripts/maps/hover.lua"))("GatherLite",addon)
local H=addon.MapHover
local a,b=pin(102,100),pin(110,100)
H:Register(a,true); H:Register(b,true); H:Update()
assert(H.current==a and entered==1)
H:Update(); assert(entered==1,"stationary cursor rebuilt tooltip")
x=113; H:Update(); assert(H.current==b and left==1)
b.shown=false; x=200; H:Update(); assert(not H.current and left==2)
x=100; H:Update(); assert(H.current==a)
focused=false; H:Update(); assert(not H.current)
focused=true; enabled=false; H:Update(); assert(not H.current)
enabled=true
local decoration={}
WorldMapFrame.currentPoIPins={decoration}; H:Update()
assert(H.current==a,"decorative native pin must not block gathering tooltip")
GameTooltip.owner=decoration; H:Update()
assert(not H.current and GameTooltip.owner==decoration,"native POI tooltip was stolen")
GameTooltip.owner=nil
WorldMapFrame.currentPoIPins={}; H:Update(); assert(H.current==a)
a.type="minimap"; H:Update(); assert(not H.current,"recycled minimap pin got world-map hover")
a.type="worldmap"; H:Update(); WorldMapFrame.scripts.OnHide(); assert(not H.current)
H:Register(a,false); H:Update(); assert(not H.current)
print("Controller map cursor passed: nearest visible pin, mouse transition, native POI priority, recycling and cleanup")

-- Cursor and pins at different effective scales must still hit at the same pixels.
H:Register(a,true); a.x,a.y=50,50
function a:GetEffectiveScale() return 2 end
x,y=100,100; H:Update(); assert(H.current==a,"mixed UI scale missed node")
local before=entered
GameTooltip.owner=nil; H:Update(); assert(entered==before+1,"lost tooltip never recovered")
H:Clear()
-- The GatherLite window uses a separate cursor and pin collection.
local map={}
local w={map=map,object={},pins={b},mapOverlay={},mapCursor=SoftCursor,
    controllerNavigation={GetCurrentButton=function() return map end}}
b.shown=true; b.node=nil; b.x,b.y=100,100
H:UpdateWindow(w); assert(H.windowState.current==b and GameTooltip.owner==b)
b.point={}; before=entered; H:UpdateWindow(w)
assert(entered==before+1,"reused pin must refresh tooltip data")
w.controllerNavigation.GetCurrentButton=function() return nil end
H:UpdateWindow(w); assert(not H.windowState.current and not GameTooltip.owner)
print("Both map cursors passed: decorative pins, tooltip recovery, scaled coordinates and window focus cleanup")

w.controllerNavigation.GetCurrentButton=function() return map end
w.mapOverlay.GetRect=function() return 0,0,50,50 end
H:UpdateWindow(w); assert(not H.windowState.current,"cursor outside viewport triggered tooltip")
w.mapOverlay.GetRect=nil; cursorShown=false
H:UpdateWindow(w); assert(not H.windowState.current,"hidden cursor triggered tooltip")
