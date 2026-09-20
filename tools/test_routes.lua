-- Run with Lua 5.1 from the repository root.
local addon = { DEBUG_NODE=2, DEBUG_FRAME=3, DEBUG_P2P=4 }
local function load(path) assert(loadfile(path))("GatherLite", addon) end
load("plugins/routes/planner.lua")
local P = addon.RoutePlanner
local square = {{x=0,y=0}, {x=1000,y=1000}, {x=0,y=1000}, {x=1000,y=0}}
local route = assert(P.Build(square))
assert(#route.points == 4 and math.abs(route.length - 4000) < .01, "circuit crosses or fails to close")
assert(not P.Build({{x=0,y=0},{x=1,y=1},{x=2,y=2}}), "dense alternatives must collapse")
local cloud, checkpoints = {}, 0
for i=1,1000 do cloud[i] = {x=(i%40)*100,y=math.floor(i/40)*100} end
route = assert(P.Build(cloud, function() checkpoints=checkpoints+1 end))
assert(#route.points <= 250 and checkpoints > 1000)
local a,b,c,d = P.ClipCircle(-2,0,2,0)
assert(math.abs(a+.96)<.001 and math.abs(c-.96)<.001 and b==0 and d==0)
assert(not P.ClipCircle(-2,2,2,2))
assert(not P.ClipCircle(0,0,0,0))
a,b,c,d = P.ClipSquare(-2,.9,2,.9)
assert(math.abs(a+.96)<.001 and math.abs(c-.96)<.001 and b==.9)
assert(not P.ClipSquare(2,-2,2,2))

local methods, frames = {}, {}
local function node(kind, name, parent)
    local f = setmetatable({kind=kind,name=name,parent=parent,scripts={},shown=true,width=100,height=100}, {__index=methods})
    if name then assert(not _G[name]); _G[name]=f end
    frames[#frames+1]=f
    return f
end
for _, key in ipairs({"SetJustifyH","SetFontObject","SetHitRectInsets","SetColorTexture","SetTexture",
    "SetAllPoints","SetTexCoord","SetHorizTile","SetVertTile","SetVertexColor","SetHighlightTexture","SetThickness","SetScale","SetFrameStrata",
    "SetShadowOffset","SetShadowColor","SetAlpha","SetClampRectInsets","SetToplevel","EnableMouse","SetTitle","SetPortraitToAsset","SetMovable","SetClampedToScreen",
    "RegisterForDrag","StartMoving","StopMovingOrSizing","SetAutoFocus","SetMaxLetters","ClearFocus",
    "SetAtlas","SetTextColor","SetStatusBarTexture","SetStatusBarColor","SetMinMaxValues","EnableMouseWheel","SetMouseMotionEnabled","SetMouseClickEnabled"}) do methods[key]=function() end end
function methods:SetSize(w,h) self.width,self.height=w,h end
function methods:SetWidth(w) self.width=w end
function methods:SetHeight(h) self.height=h end
function methods:GetWidth() return self.width end
function methods:GetHeight() return self.height end
function methods:SetPoint(...) self.point={...} end
function methods:ClearAllPoints() self.point=nil end
function methods:SetText(v) self.text=v end
function methods:GetText() return self.text or "" end
function methods:SetScript(k,v) self.scripts[k]=v end
function methods:GetScript(k) return self.scripts[k] end
function methods:Show()
    local changed=not self.shown
    self.shown=true
    if changed and self.scripts.OnShow then self.scripts.OnShow(self) end
end
function methods:Hide() self.shown=false end
function methods:SetShown(v) if v then self:Show() else self:Hide() end end
function methods:IsShown() return self.shown end
function methods:IsVisible() return self.shown and (not self.parent or self.parent:IsVisible()) end
function methods:SetEnabled(v) self.enabled=v end
function methods:SetChecked(v) self.checked=v end
function methods:GetChecked() return self.checked end
function methods:SetID(v) self.id=v end
function methods:CreateFontString() return node("FontString",nil,self) end
function methods:CreateTexture() return node("Texture",nil,self) end
function methods:CreateLine() return node("Line",nil,self) end
function methods:SetStartPoint(_,x,y) self.start={x,y} end
function methods:SetEndPoint(_,x,y) self.finish={x,y} end
function methods:SetScrollChild(child) self.content=child end
function methods:SetVerticalScroll(v) self.scroll=v end
function methods:GetVerticalScroll() return self.scroll or 0 end
function methods:GetVerticalScrollRange() return math.max(0,self.content.height-self.height) end
function methods:Init(v) self.value=v end
function methods:SetValue(v) self.value=v; if self.callback then self.callback(self,v) end end
function methods:RegisterCallback(_,fn) self.callback=fn end
function methods:GetZoom() return 0 end
function methods:GetFrameLevel() return self.level or 1 end
function methods:SetFrameLevel(level) self.level=level end
function methods:GetFrameStrata() return "DIALOG" end
function methods:GetCanvas() return self.ScrollContainer.Child end
function methods:GetCanvasScale() return self.canvasScale or 1 end
function methods:GetHorizontalScroll() return self.scrollX or 0 end
function methods:OnMapChanged() end
function methods:GetMapID() return self.mapID end
function methods:SetMapID(id) self.mapID=id; self:OnMapChanged() end
function methods:OnFrameSizeChanged() end
function methods:GetPinFrameLevelsManager() return {AddFrameLevel=function() end} end
function methods:AddDataProvider(provider) self.providers=self.providers or {}; table.insert(self.providers,provider) end
function methods:SetShouldNavigateOnClick(v) self.navigate=v end
function methods:SetShouldZoomInOnClick() end
function methods:SetShouldPanOnClick() end
function methods:SetShouldZoomInstantly() end
function methods:SetMouseWheelZoomMode(v) self.zoomMode=v end
function methods:ZoomIn() self.zoomed=true end
function methods:ZoomOut() self.zoomed=false end
function methods:HookScript(key,fn)
 local old=self.scripts[key]
 self.scripts[key]=function(...) if old then old(...) end; fn(...) end
end
function hooksecurefunc(obj,key,fn)
 local old=obj[key]
 obj[key]=function(...) local result=old(...); fn(...); return result end
end
function CreateFromMixins(mixin) return mixin end
MapExplorationDataProviderMixin={}
MapHighlightDataProviderMixin={}
MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_SMOOTH=1

local templates={ButtonFrameTemplate=true,PanelTabButtonTemplate=true,UIPanelButtonTemplate=true,
    CheckboxWithLabelTemplate=true,MinimalSliderWithSteppersTemplate=true,MinimalScrollBar=true,InputBoxTemplate=true,GatherLiteMapCanvasTemplate=true}
function CreateFrame(kind,name,parent,template)
    assert(not template or templates[template], tostring(template))
    local f=node(kind,name,parent)
    if template=="ButtonFrameTemplate" then f.Inset=node("Frame",nil,f); f.CloseButton=node("Button",nil,f) end
    if template=="CheckboxWithLabelTemplate" then f.Text=node("FontString",nil,f) end
    if template=="GatherLiteMapCanvasTemplate" then
        f.ScrollContainer=node("ScrollFrame",nil,f)
        f.ScrollContainer:SetSize(1000,1000)
        f.ScrollContainer.Child=node("Frame",nil,f.ScrollContainer)
        f.ScrollContainer.Child:SetSize(1000,1000)
    end
    return f
end
UIParent=node("Frame"); UIParent:SetSize(1920,1080)
UISpecialFrames={}
Minimap=node("Frame",nil,UIParent); Minimap:SetSize(140,140)
WorldMapFrame=node("Frame",nil,UIParent); WorldMapFrame.mapID=1
function WorldMapFrame:GetMapID() return self.mapID end
function WorldMapFrame:SetMapID(id) self.mapID=id end
WorldMapFrame.ScrollContainer=node("ScrollFrame",nil,WorldMapFrame)
WorldMapFrame.ScrollContainer:SetSize(1000,1000)
WorldMapFrame.ScrollContainer.Child=node("Frame",nil,WorldMapFrame.ScrollContainer)
WorldMapFrame.ScrollContainer.Child:SetSize(1000,1000)

function ButtonFrameTemplate_HideButtonBar() end
function PanelTemplates_SetNumTabs() end
function PanelTemplates_TabResize() end
function PanelTemplates_SetTab(f,i) f.tab=i end
-- Model the native binding contract; callback registration needs EventFrame.
ScrollUtil={InitScrollFrameWithScrollBar=function(scroll,bar)
    assert(bar.kind=="EventFrame","MinimalScrollBar needs EventFrame callback initialization")
    scroll.SetPanExtent=function(self,value) self.panExtent=value end
    scroll:SetScript("OnScrollRangeChanged",function() end)
end}
function ShowUIPanel(f) f:Show() end
MinimalSliderWithSteppersMixin={Label={Right=1}}
C_Texture={GetAtlasInfo=function() return true end}
local playerMap, facing, rotation, shape=1,0,"0","ROUND"
function GetCVar(key) return key=="rotateMinimap" and rotation or "0" end
function GetPlayerFacing() return facing end
function GetMinimapShape() return shape end
function IsInInstance() return false end
C_Minimap={GetViewRadius=function() return 500 end}
C_Map={
    GetMapInfo=function(id) return {name="Zone "..id,mapType=id==99 and 4 or 3,parentMapID=0} end,
    GetBestMapForUnit=function() return playerMap end,
    GetMapArtLayers=function() return {{layerWidth=1002,layerHeight=668,tileWidth=256,tileHeight=256}} end,
    GetMapArtLayerTextures=function() return {1,2,3,4,5,6,7,8,9,10,11,12} end,
}
local HBD={
    GetWorldCoordinatesFromZone=function(_,u,v,id) return -u*1000,-v*1000,0 end,
    GetZoneCoordinatesFromWorldInstance=function(_,x,y,instance,target)
        if target==99 then return nil end
        return -x/1000,-y/1000
    end,
    GetPlayerWorldPosition=function() return -500,-500,0 end,
    GetPlayerZonePosition=function() return .5,.5,playerMap end,
}
LibStub=function(key) if key=="HereBeDragons-2.0" then return HBD end; return {allFrames={}} end
local events={}
GatherLite={plugins={},db={global={usePredefined=true,debug={types={}}},char={
    minimap={enabled=true,range=400,size=12,opacity=1,distance=70,loot=true},
    worldmap={enabled=true,size=12,opacity=1,loot=true,zoneTooltip=true},
},profile={minimap={}}}}
function GatherLite:On(event,fn) events[event]=events[event] or {}; table.insert(events[event],fn) end
function GatherLite:Trigger(event) for _,fn in ipairs(events[event] or {}) do fn() end end
function GatherLite:IsLoaded() return true end
function GatherLite:RegisterChatCommand() end
function GatherLite:translate(key) return key end
function GatherLite:GetNodeTracking(target,kind) return self.db.char[target][kind]~=false end
function GatherLite:SetNodeTracking(target,kind,v) self.db.char[target][kind]=v; self:Trigger("settings:update") end
function GatherLite:IsIgnored(id) return self.db.char[id]==true end
function GatherLite:SetIgnored(object,v) self.db.char[object.id[1]]=v end
GatherLite.minimap={Show=function() end,Hide=function() end}
function geterrorhandler() return function(err) error(err) end end
addon.nodeDB={{id={1,2},name="copper",type="ore",icon="copper"},{id={3},name="silverleaf",type="herb",icon="herb"}}
function GatherLite:GetNodeObject(id)
    for _,obj in ipairs(addon.nodeDB) do for _,alias in ipairs(obj.id) do if alias==id then return obj end end end
end
addon.nodes={mining={{object=1,mapID=1,posX=.1,posY=.1},{object=2,mapID=1,posX=.1,posY=.1},
    {object=1,mapID=99,posX=.5,posY=.5},{object=1,mapID=1,posX=0/0,posY=.1}}}
addon.predefined={[2]={[1]={.1,.1,.9,.1,.9,.9,.1,.9},[2]={.4,.4,.6,.4,.6,.6,.4,.6}}}
load("plugins/routes/routes.lua")
load("plugins/routes/overlays.lua")
local R=addon.Routes
local maps=R:Collect(addon.nodeDB[1])
assert(#maps[1]==4 and #maps[2]==4 and not maps[99], "aliases, duplicates, invalid positions or dungeons leaked")
GatherLite.db.global.usePredefined=false
maps=R:Collect(addon.nodeDB[1])
assert(#maps[1]==1 and not maps[2])
GatherLite.db.global.usePredefined=true
R:Generate(addon.nodeDB[1])
while R.worker do R:Tick() end
assert(R.active.mapID==2, "denser circuit should win")
assert(GatherLite.db.char.routeObject==1)
assert(R.byMap[1] and R.byMap[2] and R.bestMapID==2,"non-winning zone route discarded")
R:SelectMap(1)
assert(R.active.mapID==1 and GatherLite.db.char.routeMapID==1,"manual farming zone not retained")
R:Generate(addon.nodeDB[1],1)
while R.worker do R:Tick() end
assert(R.active.mapID==1 and R.bestMapID==2,"regeneration replaced the chosen zone with the recommendation")
R:Generate(addon.nodeDB[1]); R:Clear(); R:Tick()
assert(not R.active and not R.worker and not GatherLite.db.char.routeObject)
-- A substantial route must yield, report monotonic progress, and finish.
local originalPredefined=addon.predefined
local coords={}
for x=1,10 do for y=1,10 do coords[#coords+1]=x*.08; coords[#coords+1]=y*.08 end end
addon.predefined={[2]={[1]=coords}}
R:Generate(addon.nodeDB[1])
local ticks,previousProgress=0,0
while R.worker do
    R:Tick(); ticks=ticks+1
    if R.progress then
        assert(R.progress>=previousProgress and R.progress<=100)
        previousProgress=R.progress
    end
    assert(ticks<1000,"route work failed to complete")
end
assert(ticks>1 and previousProgress>0 and R.active,"route never yielded with progress")
R:Clear(); addon.predefined=originalPredefined
load("scripts/settings.lua")
load("scripts/ui.lua")
load("scripts/maps/reveal-data.lua")
load("scripts/maps/reveal.lua")
load("scripts/maps/zoom.lua")
load("scripts/window.lua")
local W=addon.Window
W:Show()
assert(W.frame:GetWidth()==1160 and W.selectedTab==1)
local savedMap=W.map
W.frame:Hide(); W.ready=false; W.map=nil
W:Show()
assert(not W.frame:IsShown(),"partially created windows must not open")
W.ready=true; W.map=savedMap; W:Show()
W.search:SetText("silverleaf"); W.search.scripts.OnTextChanged()
assert(W.rows[1].object==addon.nodeDB[2] and not W.rows[2]:IsShown())
W.rows[1].scripts.OnClick(W.rows[1])
assert(W.zoneLabel.text:find("No known locations",1,true))
W.search:SetText("["); W.search.scripts.OnTextChanged()
assert(W.noResults:IsShown(),"search interpreted pattern syntax")
W.search:SetText(""); W.search.scripts.OnTextChanged()
W:SelectObject(addon.nodeDB[1])
assert(W.mapID==1 and #W.zones==2)
W.next.scripts.OnClick(); assert(W.mapID==2)
W.generate.scripts.OnClick()
assert(W.progress:IsShown() and R.progress==0)
while R.worker do R:Tick() end
assert(W.mapID==2 and #W.mapOverlay.lines==4)
assert(W.clear.enabled and not W.progress:IsShown())
W.previous.scripts.OnClick()
assert(W.mapID==1 and R.active.mapID==1 and GatherLite.db.char.routeMapID==1,"zone arrows did not switch routes")
W.next.scripts.OnClick()
assert(R.active.mapID==2 and GatherLite.db.char.routeMapID==2)
W.frame:Hide(); W:Show()
assert(W.mapID==2 and R.active.mapID==2,"reopening replaced the chosen farming zone")
assert(W.map.navigate and W.map.ScrollContainer.scripts.OnMouseWheel and #W.map.providers==2)
W.visibility.scripts.OnClick(); assert(not W.mapOverlay.lines[1]:IsShown())
W.visibility.scripts.OnClick(); assert(W.mapOverlay.lines[1]:IsShown())
W:SelectTab(2)
assert(W.pages[2]:IsShown() and not W.pages[1]:IsShown())
assert(W.frame:GetWidth()==1160 and W.frame:GetHeight()==710,"switching tabs must not resize the window")
-- Create every settings category and exercise each native slider/checkbox.
for _,button in pairs(W.settingsButtons) do button.scripts.OnClick() end
for _,f in ipairs(frames) do
    if f.callback then f.callback(f,f.value) end
    if f.kind=="CheckButton" then f:SetChecked(true); f.scripts.OnClick(f) end
end
W:SelectTab(1)
WorldMapFrame.mapID=2; playerMap=2
R:Draw(.1)
local lineCount=0
for _,f in ipairs(frames) do if f.kind=="Line" and f:IsVisible() then lineCount=lineCount+1 end end
assert(lineCount>=8,"world map and minimap overlays missing")
playerMap=1; R:Draw(.1)
local nearbyLines=0
for _,f in ipairs(frames) do
    if f.kind=="Line" and f.parent.parent==Minimap and f:IsVisible() then nearbyLines=nearbyLines+1 end
end
assert(nearbyLines>0,"minimap did not use the route for the player's current zone")
playerMap=2
rotation="1"; facing=math.pi/2; shape="SQUARE"; R:Draw(.1)
WorldMapFrame.canvasScale=2
WorldMapFrame.ScrollContainer.scrollX=250
WorldMapFrame.ScrollContainer:SetVerticalScroll(250)
R:Draw(.1)
for _,f in ipairs(frames) do
    if f.kind=="Line" and f:IsVisible() and f.parent.parent==WorldMapFrame.ScrollContainer then
        assert(f.start[1]>=0 and f.finish[1]>=0 and f.start[1]<=f.parent:GetWidth() and f.finish[1]<=f.parent:GetWidth())
        assert(f.parent:GetFrameLevel()>WorldMapFrame.ScrollContainer:GetFrameLevel(),"route below map artwork")
    end
end
WorldMapFrame:Hide(); R:Draw(.1)
WorldMapFrame:Show(); R:Draw(.1)

playerMap=99; WorldMapFrame.mapID=99; R:Draw(.1)
for _,f in ipairs(frames) do
    if f.kind=="Line" and f.parent~=W.mapOverlay then assert(not f:IsVisible(),"stale route on another map") end
end
W.clear.scripts.OnClick()
assert(not R.active and not W.mapOverlay.lines[1]:IsShown())
W.frame.CloseButton.scripts.OnClick()
assert(not W.frame:IsShown())
print("Route and native UI checks passed: geometry, clipping, data sources, zone selection, cancellation, search, tabs, settings and overlays")

-- Fish references are distinct from gatherable node IDs and tracking filters.
local Pins={world={},mini={}}
function Pins:RemoveAllWorldMapIcons() self.world={} end
function Pins:RemoveAllMinimapIcons() self.mini={} end
function Pins:AddWorldMapIconMap(_,frame,mapID,u,v)
    self.world[#self.world+1]={frame=frame,mapID=mapID,u=u,v=v}; frame:Show()
end
function Pins:AddMinimapIconMap(_,frame,mapID,u,v)
    self.mini[#self.mini+1]={frame=frame,mapID=mapID,u=u,v=v}; frame:Show()
end
local previousLibStub=LibStub
LibStub=function(key) return key=="HereBeDragons-Pins-2.0" and Pins or previousLibStub(key) end
load("plugins/fishing/data.lua")
assert(#addon.fishDB==25)
local fish={type="fish",id={},itemID=6291,name="Raw Brilliant Smallfish",icon="fish",
    maps={[1]={.2,.2,.201,.201,.8,.8},[2]={},[99]={.5,.5}}}
addon.fishDB={fish}
playerMap=1; WorldMapFrame.mapID=1
load("plugins/fishing/maps.lua")
local F=addon.Fishing
GatherLite.db.global.usePredefined=false
GatherLite.db.char.worldmap.enabled=true; GatherLite.db.char.minimap.enabled=true
GatherLite.db.char.worldmap.fishing=false; GatherLite.db.char.minimap.fishing=false
local collected=R:Collect(fish)
assert(#collected[1]==3 and #collected[2]==0 and not collected[99])
W:Show(); W.search:SetText("smallfish"); W:RefreshList()
assert(W.rows[1].object==fish and not W.rows[2]:IsShown())
W:SelectObject(fish)
assert(F.object==fish and GatherLite.db.char.fishItem==6291)
assert(#Pins.world==2 and #Pins.mini==2,"catch pins depend on gather tracking or fail to group close reports")
assert(W.generate.enabled==false and not R.worker and not R.active,"fish search generated a land circuit")
assert(W.requirement:GetText()=="Fishing | Reported catches")
W:SetMap(2)
assert(W.zoneLabel:GetText()=="Fishing zone (no precise pins)" and W.generate:GetText()=="Zone information only")
assert(#Pins.world==2,"browsing a zone erased catch points in other zones")
W.visibility.scripts.OnClick()
assert(#Pins.world==0 and #Pins.mini==0 and not F.visible)
W.visibility.scripts.OnClick()
assert(#Pins.world==2 and #Pins.mini==2 and F.visible)
GatherLite.db.char.minimap.enabled=false; F:Refresh()
assert(#Pins.world==2 and #Pins.mini==0,"minimap master toggle ignored")
W.clear.scripts.OnClick()
assert(#Pins.world==0 and not W.object and not GatherLite.db.char.fishItem)
W:SelectObject(fish); W:SelectObject(addon.nodeDB[1])
assert(#Pins.world==0 and not F.object,"stale fish selection after choosing a gathering node")
assert(addon.UI.Requirement({type="herb",levels={70,95}})=="Herbalism 70")
assert(addon.UI.Requirement({type="ore",levels={220}})=="Mining 220")
assert(addon.UI.Requirement({type="container"})=="No skill requirement recorded")
addon.nodeDB[1].levels={65}
W:SelectObject(addon.nodeDB[1])
assert(W.requirement:GetText()=="Mining 65")
print("Fish search, zone-only data, pin lifecycle, map toggles and profession requirements passed")

-- Unselected catch references follow the separate Fishing filters on BOTH maps.
local otherFish={type="fish",id={},itemID=6289,name="Raw Longjaw Mud Snapper",icon="snapper",
    maps={[1]={.21,.21},[2]={.5,.5}}}
addon.fishDB={fish,otherFish}
F:Select(nil)
GatherLite.db.global.usePredefined=true
GatherLite.db.char.worldmap.enabled=true; GatherLite.db.char.minimap.enabled=true
GatherLite.db.char.worldmap.fishing=true; GatherLite.db.char.minimap.fishing=true
WorldMapFrame.mapID=1; WorldMapFrame.canvasScale=1; playerMap=1
F:Refresh()
assert(#Pins.world==2 and #Pins.mini==2,"Fishing filters did not enable catch references on both maps")
local combined=false
for _,pin in ipairs(Pins.world) do if #pin.frame.fish==2 then combined=true end end
assert(combined,"nearby fish species were discarded instead of combined in the tooltip")
GatherLite.db.char.worldmap.fishing=false; F:Refresh()
assert(#Pins.world==0 and #Pins.mini==2,"world-map Fishing filter affected the minimap")
GatherLite.db.char.minimap.fishing=false; F:Refresh()
assert(#Pins.world==0 and #Pins.mini==0)
GatherLite.db.char.worldmap.fishing=true; GatherLite.db.char.minimap.fishing=true
F.setup()
local watcher=frames[#frames]
watcher.scripts.OnUpdate(watcher,.3)
playerMap=2; WorldMapFrame.mapID=2
watcher.scripts.OnUpdate(watcher,.3)
assert(#Pins.world==1 and #Pins.mini==1 and Pins.world[1].mapID==2,"fish pins did not follow map/zone changes")
GatherLite.db.global.usePredefined=false; F:Refresh()
assert(#Pins.world==0 and #Pins.mini==0,"automatic reference pins ignored predefined-data toggle")
-- A dense shoreline stays readable and keeps the same geographic anchors at every zoom.
local dense={type="fish",id={},itemID=999,name="Test Fish",icon="fish",maps={[1]={}}}
for i=1,80 do
    dense.maps[1][#dense.maps[1]+1]=.2+i*.002
    dense.maps[1][#dense.maps[1]+1]=.4
end
playerMap=1; WorldMapFrame.mapID=1
W.mapOverlay:SetSize(1000,1000)
W:SelectObject(dense)
local visible={}
for _,pin in ipairs(W.pins) do if pin:IsShown() then visible[#visible+1]=pin end end
assert(#visible>1 and #visible<10,"farming map still shows an icon for every catch report")
for i,a in ipairs(visible) do
    for j=i+1,#visible do
        local b=visible[j]
        assert((a.point[4]-b.point[4])^2+(a.point[5]-b.point[5])^2>=34^2-.01,"fish icons overlap")
    end
end
local function coordinates(pins)
    local result={}
    for _,pin in ipairs(pins) do result[#result+1]=string.format("%d:%.6f:%.6f",pin.mapID,pin.u,pin.v) end
    table.sort(result); return table.concat(result,";")
end
local before=coordinates(Pins.world)
for _,scale in ipairs({.6,1,2,4,1}) do
    WorldMapFrame.canvasScale=scale; F:Refresh()
    assert(coordinates(Pins.world)==before,"native fish anchors moved when zoom changed")
end
local anchors=W.displayLocations
for _,scale in ipairs({1,2,3,1}) do
    W.map.canvasScale=scale
    W.map.ScrollContainer.scrollX=scale==1 and 0 or 100
    W:DrawMap()
    assert(W.displayLocations==anchors,"farming map rebuilt catch areas while zooming or panning")
end
-- Native map pins and the farming map use identical representative coordinates.
local native={}
for _,pin in ipairs(Pins.world) do native[string.format("%.6f:%.6f",pin.u,pin.v)]=true end
for _,point in ipairs(anchors[1]) do assert(native[string.format("%.6f:%.6f",point.u,point.v)]) end
assert(#Pins.mini<10,"minimap catch markers remain overcrowded")
print("Fishing filters on both maps, grouped species, zone refresh and marker-density checks passed")
