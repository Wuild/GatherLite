-- Lua 5.1: exercise the real world-map module, frame pool and spatial index.
local addon = { name = "GatherLite", API = {}, zoneTree = {} }
local libraries, frames, events = {}, {}, {}
local widgetCreates, textureAnchors, objectLookups = 0, 0, 0
local function noop() end
local function frame(parent)
    local f = { parent=parent, shown=true, scripts={}, width=1000, height=500, scale=1, left=0, top=500, level=10 }
    for _, method in ipairs({ "RegisterForClicks", "RegisterForDrag", "SetHighlightTexture",
        "SetMouseClickEnabled", "SetMouseMotionEnabled", "SetTexelSnappingBias", "SetSnapToPixelGrid",
        "SetVertexColor", "SetTexCoord", "EnableMouse" }) do f[method]=noop end
    function f:SetSize(w,h) self.width,self.height=w,h end
    function f:SetWidth(w) self.width=w end
    function f:SetHeight(h) self.height=h end
    function f:GetWidth() return self.width end
    function f:GetHeight() return self.height end
    function f:GetLeft() return self.left end
    function f:GetTop() return self.top end
    function f:GetEffectiveScale() return self.scale end
    function f:GetFrameLevel() return self.level end
    function f:SetFrameLevel(v) self.level=v end
    function f:SetFrameStrata(v) self.strata=v end
    function f:GetFrameStrata() return self.strata or "HIGH" end
    function f:SetParent(p) self.parent=p end
    function f:GetParent() return self.parent end
    function f:SetPoint(...)
        self.point={...}
        if self.isTexture then textureAnchors=textureAnchors+1 end
    end
    function f:ClearAllPoints() self.point=nil end
    function f:SetAllPoints(p) self.anchor=p end
    function f:SetClipsChildren(v) self.clips=v end
    function f:SetTexture(v) self.path=v end
    function f:SetAlpha(v) self.alpha=v end
    function f:GetAlpha() return self.alpha or 1 end
    function f:GetVertexColor() return 1,1,1 end
    function f:Show() self.shown=true end
    function f:Hide() self.shown=false end
    function f:IsShown() return self.shown end
    f.IsVisible=f.IsShown
    function f:SetScript(event,fn) self.scripts[event]=fn end
    function f:CreateTexture() local t=frame(self); t.isTexture=true; return t end
    frames[#frames+1]=f
    return f
end
CreateFrame=function(_,name,parent)
    widgetCreates=widgetCreates+1
    local f=frame(parent); if name then _G[name]=f end; return f
end
UIParent=frame()
WorldMapFrame=frame(UIParent)
local canvas,scroll=frame(),frame()
WorldMapFrame.ScrollContainer=scroll
WorldMapFrame.mapID=1
function WorldMapFrame:GetMapID() return self.mapID end
function WorldMapFrame:GetCanvas() return canvas end
local stitched,zoom,combat=true,6,false
InCombatLockdown=function() return combat end
local rects={ [1]={0,.1,0,.1}, [2]={.1,.2,0,.1}, [3]={.7,.8,0,.1}, [4]={0,.1,0,.1} }
local function world(id,x,y)
    local r=rects[id]; if r then return r[1]+x*(r[2]-r[1]),r[3]+y*(r[4]-r[3]) end
end
OpenMapAPI={major=1,version=4,IsStitched=function() return stitched end,
    GetView=function() return .1,.05,zoom end,WorldFromMap=world,ArtTopLevel=function() return 200 end}
C_Map={GetMapInfo=function(id) return {mapType=id==99 and 2 or 3} end}
local hbd={}
function hbd:GetWorldCoordinatesFromZone(x,y,id) return x,y,0 end
function hbd:GetZoneCoordinatesFromWorldInstance(x,y) return x,y end
local native={worldmap={},removes=0}
function native:AddWorldMapIconMap(_,pin) self.worldmap[pin]=true; pin:Show() end
function native:RemoveWorldMapIcon(_,pin) self.removes=self.removes+1; self.worldmap[pin]=nil end
native.RemoveMinimapIcon=noop
libraries["HereBeDragons-2.0"]=hbd
libraries["HereBeDragons-Pins-2.0"]=native
libraries["AceLocale-3.0"]={GetLocale=function() return {} end}
LibStub=setmetatable({NewLibrary=function(_,name) libraries[name]={}; return libraries[name] end},
    {__call=function(_,name) return libraries[name] or {} end})
tinsert,tremove=table.insert,table.remove
GameTooltip={IsOwned=function(self,pin) return self.owner==pin end}
GatherLite={modules={},plugins={},db={char={worldmap={enabled=true,size=16,opacity=.8,
    tracking={mining=true,herbalism=true,containers=true,fishing=true}}},global={usePredefined=true}}}
function GatherLite:SendMessage() end
function GatherLite:On(event,fn) events[event]=fn end
function GatherLite:hideTooltip() GameTooltip.owner=nil end
function GatherLite:showTooltip(pin) GameTooltip.owner=pin end
function GatherLite:GetNodeTracking(_,kind) return self.db.char.worldmap.tracking[kind] end
function GatherLite:IsIgnored(id) return id==999 end
local function load(path) assert(loadfile(path))("GatherLite",addon) end
load("scripts/frame.lua")
load("scripts/methods.lua")
load("scripts/zones.lua")
GatherLite.IsLoaded=function() return true end
GatherLite.debug=noop
GatherLite.GetNodeObject=function(_,id) objectLookups=objectLookups+1; return {icon=id} end
GatherLite.IsIgnored=function(_,id) return id==999 end
GatherLite.showTooltip=function(_,pin) GameTooltip.owner=pin end
GatherLite.hideTooltip=function() GameTooltip.owner=nil end
load("scripts/modules/worldmap.lua")
load("plugins/openmap/openmap.lua")
local O=addon.OpenMap
local module=GatherLite.modules.worldmap
module.setup()
local function tick(dt)
    for _,f in ipairs(frames) do if f.scripts.OnUpdate then f.scripts.OnUpdate(f,dt or .11) end end
end
local function node(map,x,kind,object)
    return {mapID=map,posX=x,posY=.5,type=kind or "mining",object=object or 1731}
end
local own,neighbor,far,edge=node(1,.5),node(2,.5),node(3,.5),node(2,.95)
local ignored,reference,herb,chest,fish=node(1,.4,nil,999),node(1,.6),node(1,.5,"herbalism"),
    node(1,.5,"containers"),node(1,.5,"fishing")
reference.predefined=true
addon.zoneTree[4]={system=1}
local dungeon,overview=node(4,.5),node(99,.5)
GatherLite:LoadTable("mining",{own,neighbor,far,edge,ignored,reference,dungeon,overview})
GatherLite:LoadTable("herbalism",{herb})
GatherLite:LoadTable("containers",{chest})
GatherLite:LoadTable("fishing",{fish})
local query=GatherLite.GetNodesForMapRect
local queries=0
function GatherLite:GetNodesForMapRect(...) queries=queries+1; return query(self,...) end
tick()
assert(next(O.pins)==nil and queries==0 and not O.layer,"zoomed-out map must allocate/query no pins")
zoom=7
-- View covers the first zone and half its neighbor, with the first as host.
canvas.width=1000; scroll.width=1500
tick()
local ownPin,neighborPin=assert(O.pins[own]),assert(O.pins[neighbor])
assert(not O.pins[far] and not O.pins[edge] and not O.pins[ignored] and not O.pins[dungeon] and not O.pins[overview])
assert(O.pins[herb] and O.pins[chest] and O.pins[fish],"all categories must use viewport pins")
assert(O.layer.clips and ownPin.texture.parent==O.content and ownPin.texture.alpha==.8)
assert(ownPin.x+O.content.point[4]==500 and ownPin.y+O.content.point[5]==-250,"pin screen projection")
assert(next(native.worldmap)==nil,"stitched view must never register HBD/faded pins")
-- Different effective scales and nonzero window offsets use physical positions.
canvas.scale,canvas.left,canvas.top=2,-100,300
scroll.left,scroll.top=50,250
local g=O:GetGeometry()
assert(math.abs(g.x+250)<.00001 and math.abs(g.y-350)<.00001)
assert(math.abs(g.x+(.05-g.u)*g.sx-750)<.00001)
assert(math.abs(g.y-(.05-g.v)*g.sy+150)<.00001)
canvas.scale,canvas.left,canvas.top=1,0,500
scroll.left,scroll.top=0,500
local artLevel=OpenMapAPI.ArtTopLevel
OpenMapAPI.ArtTopLevel=function() return 300 end
combat=true; tick(); assert(O.layer.level==202,"layer changes must wait out combat")
combat=false; tick(); assert(O.layer.level==302,"layer must recover above the art after combat")
OpenMapAPI.ArtTopLevel=artLevel
local count=queries
for _=1,10 do tick() end
assert(queries==count and O.pins[own]==ownPin,"idle map must reuse frames and skip queries")
-- Moving the host to zone 2 must preserve the same world view and pin frames.
WorldMapFrame.mapID=2; canvas.left=1000
tick()
assert(O.pins[own]==ownPin and O.pins[neighbor]==neighborPin and ownPin.x+O.content.point[4]==500,
    "host-zone changes must retain pins in the same stitched view")
-- Pan into the next zone; source coordinates and node identity stay intact.
canvas.left=0
tick()
assert(not O.pins[own] and not own.loadedWorldmap and O.pins[neighbor]==neighborPin and O.pins[edge])
assert(neighbor.mapID==2 and neighbor.posX==.5)
-- Only visible pins are repositioned during zoom, at a constant icon size/opacity.
canvas.width=2000; canvas.scale=.75; scroll.scale=.75
tick()
assert(O.pins[neighbor]==neighborPin and neighborPin.texture.width==16 and neighborPin.texture.alpha==.8)
GetCursorPosition=function() return 750,187.5 end
tick()
assert(GameTooltip.owner==O.hoverFrame and O.hoverFrame.node==neighbor,"texture hover uses one tooltip owner")
local nativeOwner=frame()
WorldMapFrame.currentPoIPins={nativeOwner}; GameTooltip.owner=nativeOwner
tick(); assert(GameTooltip.owner==nativeOwner and not O.hovered,"native tooltips retain priority")
WorldMapFrame.currentPoIPins={}; GameTooltip.owner=nil
GetCursorPosition=nil
InputUtil={IsGamepadUIEnabled=function() return true end}
function WorldMapFrame:IsMapFocused() return true end
function scroll:GetGamepadCursorPosition() return 1000,250 end
tick(); assert(O.hoverFrame.node==neighbor,"controller hover uses texture spatial buckets")
InputUtil=nil
zoom=6.99; tick()
assert(next(O.pins)==nil and not neighbor.loadedWorldmap and not GameTooltip.owner,"zoom-out cleanup/tooltip")
count=queries; tick(); assert(queries==count,"overview must not query nodes")
-- Filters, reference setting, and newly gathered nodes refresh in the same view.
zoom=9; WorldMapFrame.mapID=1; canvas.left=0; canvas.width=1000
tick()
GatherLite.db.global.usePredefined=false
GatherLite.db.char.worldmap.tracking.herbalism=false
events["settings:update"](); tick()
assert(not O.pins[reference] and not O.pins[herb] and O.pins[own])
local fresh=node(2,.2)
GatherLite:LoadTable("mining",{fresh}); events["nodes:added"](fresh); tick()
assert(O.pins[fresh],"new visible gathers must appear without reopening/panning")
GatherLite.db.char.worldmap.openMapPinZoom=10
tick(); assert(next(O.pins)==nil,"raising the saved cutoff must hide pins at the current zoom")
zoom=10; tick()
assert(O.pins[own],"pins must appear at the configured zoom")
zoom=9
GatherLite.db.char.worldmap.openMapPinZoom=8
tick(); assert(O.pins[own],"lowering the saved cutoff must show pins without reopening the map")
-- Invalid geometry and closed maps release pooled frames.
canvas.width=0; tick(); assert(next(O.pins)==nil)
canvas.width=1000; tick(); assert(O.pins[own])
WorldMapFrame:Hide(); tick(); assert(next(O.pins)==nil and not O.layer:IsShown())
WorldMapFrame:Show(); tick(); assert(O.pins[own])
stitched=false; tick()
assert(next(O.pins)==nil and next(native.worldmap),"leaving stitched mode must restore native pins")
stitched=true; tick()
assert(O.pins[own] and next(native.worldmap)==nil,"return to stitched mode must clear native pins")
local api=OpenMapAPI
OpenMapAPI.major=2; tick()
assert(next(O.pins)==nil and next(native.worldmap),"unsupported API must fall back safely")
OpenMapAPI=nil; tick()
print("OpenMap checks passed: zoom cutoff, viewport/neighbor queries, persistent pins, host switches, filters, cleanup and native fallback")

-- Dense small-rectangle queries must use buckets without changing results.
local dense={}
for i=0,99 do for j=0,99 do dense[#dense+1]=node(5,i/100); dense[#dense].posY=j/100 end end
GatherLite:LoadTable("mining",dense)
local cells=addon.nodeIndex.mining.byCell[5]
local probes=0
addon.nodeIndex.mining.byCell[5]=setmetatable({}, {__index=function(_,key) probes=probes+1; return cells[key] end})
local matches=query(GatherLite,"mining",5,.499,.501,.499,.501)
assert(#matches==1 and matches[1].posX==.5 and matches[1].posY==.5)
assert(probes>0 and probes<10,"tiny view must probe a few cells instead of scanning 10,000 nodes")
assert(#query(GatherLite,"mining",5,2,3,2,3)==0)
probes=0
assert(#query(GatherLite,"mining",5,1,0,1,0)==10000,"wide/reversed rectangle must preserve all nodes")
assert(probes==0,"full-zone query must scan the node list rather than every spatial cell")
print("Adaptive rectangle index checks passed")

-- Realistic work regression: dragging a dense view must not update 10,000
-- anchors, allocate 10,000 interactive frames, or scan the resource catalog.
addon.nodeIndex.mining.byCell[5]=cells
rects[5]={0,.1,0,.1}
api.major=1; OpenMapAPI=api
WorldMapFrame.mapID=5
canvas.width,canvas.height,canvas.left,canvas.top,canvas.scale=1000,500,0,500,1
scroll.width,scroll.height,scroll.left,scroll.top,scroll.scale=1000,500,0,500,1
GatherLite.db.char.worldmap.tracking={mining=true}
local widgetsBefore=widgetCreates
tick()
local visible=0
for _ in pairs(O.pins) do visible=visible+1 end
assert(visible>=10000 and widgetCreates==widgetsBefore,"dense maps must use textures, not one frame per node")
textureAnchors,objectLookups=0,0
local queriesBefore=queries
local started=os.clock()
for i=1,120 do canvas.left=-20*math.sin(i/10); O:Update(1/120) end
local duration=os.clock()-started
assert(textureAnchors==0 and objectLookups==0 and queries==queriesBefore,
    "covered pans must move only the parent, without texture/catalog/query work")
local retained=assert(O.pins[dense[5051]])
local anchor=retained.texture.point
canvas.left=-200; O:Update(.11)
assert(O.pins[dense[5051]]==retained and retained.texture.point==anchor,
    "viewport refill must not reanchor retained textures")
textureAnchors=0
canvas.width=4000; O:Update(.11)
visible=0; for _ in pairs(O.pins) do visible=visible+1 end
assert(visible<4000 and textureAnchors==visible,"zoom must cull before updating texture positions")
assert(widgetCreates==widgetsBefore,"zoom must not allocate interactive node frames")
local removesBefore=native.removes
O:Clear()
assert(native.removes==removesBefore,"texture cleanup must not scan HBD pin pools")
print(string.format("Dense pan: 10,000 locations, 120 frames in %.3fs; zero texture anchors, catalog lookups, viewport queries or node-frame allocations",duration))
