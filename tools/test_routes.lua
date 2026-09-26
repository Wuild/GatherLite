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

GameTooltip={
    SetOwner=function(self,owner) self.owner=owner end,
    SetText=function(self,text) self.text=text end,
    Show=function(self) self.shown=true end,
    Hide=function(self) self.shown=false; self.owner=nil end,
    IsOwned=function(self,owner) return self.owner==owner end,
}
local methods, frames = {}, {}
local function node(kind, name, parent)
    local f = setmetatable({kind=kind,name=name,parent=parent,scripts={},shown=true,width=100,height=100}, {__index=methods})
    if name then assert(not _G[name]); _G[name]=f end
    frames[#frames+1]=f
    return f
end
for _, key in ipairs({"EnableGamePadButton","EnableGamePadStick","SetWordWrap","SetJustifyH","SetFontObject","SetHitRectInsets","SetColorTexture","SetTexture",
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
function methods:Hide()
    local changed=self.shown
    self.shown=false
    if changed and self.scripts.OnHide then self.scripts.OnHide(self) end
end
function methods:RegisterEvent(event) self.events=self.events or {}; self.events[event]=true end
function methods:UnregisterEvent(event) if self.events then self.events[event]=nil end end
function methods:SetShown(v) if v then self:Show() else self:Hide() end end
function methods:IsShown() return self.shown end
function methods:IsVisible() return self.shown and (not self.parent or self.parent:IsVisible()) end
function methods:SetEnabled(v) self.enabled=v end
function methods:IsEnabled() return self.enabled~=false end
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
function methods:GetStringHeight() return math.ceil(#(self.text or "")/110)*16 end
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
-- Forever MapCanvasMixin's inherited focus contract (including line 982).
function methods:IsMouseMotionFocus() return self.mouseMotionFocus or false end
function methods:IsCanvasMouseFocus()
    if InputUtil.IsGamepadUIEnabled() then return self:IsMapFocused() end
    return self.ScrollContainer:IsMouseMotionFocus()
end
function methods:IsCanvasMouseFocusOrPinFocus()
    if InputUtil.IsGamepadUIEnabled() then return self:IsMapFocused() end
    return self.ScrollContainer:IsMouseMotionFocus()
end
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

local templates={HelpTipTemplate=true,NavBarTemplate=true,ButtonFrameTemplate=true,PanelTabButtonTemplate=true,UIPanelButtonTemplate=true,
    CheckboxWithLabelTemplate=true,MinimalSliderWithSteppersTemplate=true,MinimalScrollBar=true,InputBoxTemplate=true,GatherLiteMapCanvasTemplate=true}
function CreateFrame(kind,name,parent,template)
    assert(not template or templates[template], tostring(template))
    local f=node(kind,name,parent)
    if template=="MinimalSliderWithSteppersTemplate" then
        f.Slider=node("Slider",nil,f); f.Back=node("Button",nil,f); f.Forward=node("Button",nil,f)
    end
    if template=="HelpTipTemplate" then
        f.OkayButton=node("Button",nil,f); f.CloseButton=node("Button",nil,f)
        function f:Reset() self.info=nil; self.OkayButton:Hide(); self.CloseButton:Hide() end
        function f:Init(owner,info,target) self.info=info; self.relativeRegion=target end
        function f:Layout() self.OkayButton:Show() end
        f:SetScript("OnHide",function() f:Close() end)
    end
    if template=="NavBarTemplate" then f.home=node("Button",nil,f); f.overflow=node("DropdownButton",nil,f) end
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

function NavBar_Initialize(bar, template, homeData, home, overflow)
    assert(template=="NavButtonTemplate" and home and overflow)
    bar.homeData=homeData; bar.buttons={}
end
function NavBar_Reset(bar) bar.buttons={} end
function NavBar_AddButton(bar, data) bar.buttons[#bar.buttons+1]=data end
function NavBar_CheckLength() end
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
UIPanelWindows={}
local nativePanel
function ShowUIPanel(f)
    if UIPanelWindows[f.name] then
        if nativePanel and nativePanel~=f then nativePanel:Hide() end
        nativePanel=f
    end
    f:Show()
end
function HideUIPanel(f)
    if nativePanel==f then nativePanel=nil end
    f:Hide()
end
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
load("scripts/maps/controller-input.lua")
load("scripts/maps/controller.lua")
load("scripts/window.lua")
HelpTip={width=226,ButtonStyle={GotIt=4,Next=5},Alignment={Center=2},
    Point={LeftEdgeCenter=11,BottomEdgeCenter=5,RightEdgeCenter=8,TopEdgeCenter=2}}
load("scripts/maps/onboarding.lua")
local W=addon.Window
W:Show()
assert(W.frame:GetWidth()==1160 and W.selectedTab==1)
assert(UIPanelWindows.GatherLiteWindow.area=="left" and nativePanel==W.frame)
assert(W.frame.useCustomNavigation and not W.frame.scripts.OnDragStart)
W.frame.CloseButton:GetScript("OnClick")()
assert(not nativePanel and not W.frame:IsShown(), "close button must release the native panel")
W:Show()
local savedMap=W.map
W.frame:Hide(); W.ready=false; W.map=nil
W:Show()
assert(not W.frame:IsShown(),"partially created windows must not open")
W.ready=true; W.map=savedMap; W:Show()
assert(W.zoneOnly and W.zoneFilter:GetChecked(), "zone filtering should default on")
W.zoneFilter:SetChecked(false); W.zoneFilter:GetScript("OnClick")(W.zoneFilter)
W.search:SetText("silverleaf"); W.search.scripts.OnTextChanged()
assert(W.rows[1].object==addon.nodeDB[2] and not W.rows[2]:IsShown())
W.rows[1].scripts.OnClick(W.rows[1])
assert(W.zoneLabel.text:find("No known locations",1,true))
addon.nodeDB[1].aliases={"weak_copper_vein"}
W.search:SetText("weak"); W.search.scripts.OnTextChanged()
assert(W.rows[1].object==addon.nodeDB[1] and not W.rows[2]:IsShown(), "variant search must return its base resource once")
addon.nodeDB[1].aliases=nil
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
    local parent=f.parent
    while parent and parent~=W.pages[2] do parent=parent.parent end
    if f.kind=="CheckButton" and parent then f:SetChecked(true); f.scripts.OnClick(f) end
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
WorldMapFrame:Hide()
local refresh=F.Refresh
local refreshes=0
F.Refresh=function(self) refreshes=refreshes+1; return refresh(self) end
F.setup()
local watcher=frames[#frames]
watcher.scripts.OnUpdate(watcher,.01)
assert(#Pins.world==0 and #Pins.mini==2 and refreshes==1,"initial fish pins waited for polling or refreshed twice")
WorldMapFrame:Show()
watcher.scripts.OnUpdate(watcher,.01)
assert(#Pins.world==2 and refreshes==2,"opening world map delayed fish pins")
watcher.scripts.OnUpdate(watcher,.01)
assert(refreshes==2,"unchanged world map rebuilt fish pins")
WorldMapFrame.mapID=2
watcher.scripts.OnUpdate(watcher,.01)
assert(#Pins.world==1 and Pins.world[1].mapID==2 and refreshes==3,"browsing zones delayed fish pins")
WorldMapFrame:Hide()
watcher.scripts.OnUpdate(watcher,.01)
assert(#Pins.world==0 and #Pins.mini==2,"closing world map left stale fish pins")
WorldMapFrame:Show()
watcher.scripts.OnUpdate(watcher,.01)
assert(#Pins.world==1 and Pins.world[1].mapID==2,"reopening world map delayed fish pins")
local beforeRefresh=refreshes
playerMap=2
watcher.scripts.OnUpdate(watcher,.3)
assert(#Pins.world==1 and #Pins.mini==1 and refreshes==beforeRefresh+1,"fish pins did not follow player-zone changes")
watcher.scripts.OnUpdate(watcher,.3)
assert(refreshes==beforeRefresh+1,"idle player polling rebuilt fish pins")
F.Refresh=refresh
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

-- Native breadcrumbs follow the full map hierarchy and offer sibling dropdowns.
do
    local originalInfo, originalChildren = C_Map.GetMapInfo, C_Map.GetMapChildrenInfo
    local maps = {
        [947]={mapID=947,name="Azeroth",mapType=1,parentMapID=0},
        [1415]={mapID=1415,name="Eastern Kingdoms",mapType=2,parentMapID=947},
        [1453]={mapID=1453,name="Stormwind City",mapType=3,parentMapID=1415},
        [1429]={mapID=1429,name="Elwynn Forest",mapType=3,parentMapID=1415},
    }
    C_Map.GetMapInfo=function(id) return maps[id] or originalInfo(id) end
    C_Map.GetMapChildrenInfo=function(id)
        local children={}; for _,info in pairs(maps) do if info.parentMapID==id then children[#children+1]=info end end
        return children
    end
    W:SetMap(1453)
    local crumbs=W.breadcrumb.buttons
    assert(#crumbs==2 and crumbs[1].id==1415 and crumbs[2].id==1453,"full breadcrumb hierarchy")
    local siblings=crumbs[2].listFunc()
    assert(#siblings==2 and siblings[1].id==1429,"sorted zone dropdown")
    siblings[1].func(nil,1429); assert(W.mapID==1429,"dropdown did not navigate")
    W.breadcrumb.buttons[1].OnClick(); assert(W.mapID==1415,"continent breadcrumb did not navigate")
    local childZones=W.breadcrumb.buttons[1].listFunc()
    assert(#childZones==2 and childZones[1].id==1429,"continent dropdown must let controller enter a zone")
    W.breadcrumb.homeData.OnClick()
    for _,pin in ipairs(W.pins) do assert(not pin:IsShown(),"overview resource pin leaked") end
    for _,line in ipairs(W.mapOverlay.lines) do assert(not line:IsShown(),"overview route leaked") end
    assert(W.mapID==947 and #W.breadcrumb.buttons==0,"world breadcrumb")
    W.sidebar:Hide(); W:LayoutMap()
    assert(W.sidebar:IsShown() and W.map.point[4]==-280,"sidebar must always reserve its width")
    for _,f in ipairs(frames) do assert(f:GetText()~="Find","sidebar toggle still exists") end
    C_Map.GetMapInfo, C_Map.GetMapChildrenInfo=originalInfo,originalChildren
    W:SetMap(1)
end

-- Controller input must never mutate Blizzard's shared binding stack.
do
    local enabled=false
    InputUtil={IsGamepadUIEnabled=function() return enabled end}
    local function forbidden() error("shared controller stack used") end
    GamepadMode={FrameControlsManager={FrameShown=forbidden,FrameHidden=forbidden,GetActiveFrame=function() return nil end},
        CreateBindingGroup=forbidden,ActivateBindingGroup=forbidden,DeactivateBindingGroup=forbidden}
    SmartNavigation=setmetatable({}, {__index=function() return forbidden end})
    GAMEPAD_STICK_LEFT="PADLSTICKAXIS"; GAMEPAD_STICK_RIGHT="PADRSTICKAXIS"
    GAMEPAD_SHOULDER_LEFT="PADLSHOULDER"; GAMEPAD_SHOULDER_RIGHT="PADRSHOULDER"
    GAMEPAD_DPAD_LEFT="PADDLEFT"; GAMEPAD_DPAD_RIGHT="PADDRIGHT"
    GAMEPAD_FACE_BOTTOM="PAD1"; GAMEPAD_FACE_RIGHT="PAD2"; GAMEPAD_BUTTON_ANY_DOWN_OR_UP={}
    W.frame.scripts.OnEvent(W.frame,"ADDON_LOADED")
    W:Show(); enabled=true
    W.frame.scripts.OnUpdate(W.frame,.02)
    local input=W.controllerInput
    GamepadMode.FrameControlsManager.GetActiveFrame=function() return W.frame end
    assert(W.controllerInput:IsShown())
    W:SetControllerTarget(W.categoryButtons[2])
    input.scripts.OnGamePadButtonDown(input,"PAD1")
    assert(W.resourceCategory=="ore", "category must activate with native panel focus")
    assert(GameTooltip.owner==W.categoryButtons[2] and GameTooltip.text=="Mining",
        "controller category focus must identify the icon")
    W.categoryButtons[1]:GetScript("OnClick")()
    W:SetControllerTarget(W.map)
    GamepadMode.FrameControlsManager.GetActiveFrame=function() return nil end
    assert(input:IsShown() and W.controllerNavigation:GetCurrentButton()==W.map and W.mapCursor:IsShown())
    W:SelectTab(2); W.settingsButtons.worldmap:GetScript("OnClick")()
    local slider
    for _,control in ipairs(W.settingsPanels.worldmap.controls) do if control.AdjustBy then slider=control; break end end
    W:SetControllerTarget(slider)
    local initial=slider.value
    input.scripts.OnGamePadButtonDown(input,"PADDRIGHT")
    input.scripts.OnGamePadButtonUp(input,"PADDRIGHT")
    assert(slider.value>initial and not W.editSlider,"D-pad must adjust without Confirm")
    local increased=slider.value
    input.scripts.OnGamePadStick(input,"Movement",-.8,0)
    input.scripts.OnGamePadStick(input,"Movement",0,0)
    assert(slider.value<increased,"left stick must adjust focused slider")
    input.scripts.OnGamePadStick(input,"Movement",.8,0)
    local beforeRepeat=slider.value
    input.scripts.OnGamePadStick(input,"Camera",0,0)
    input.scripts.OnUpdate(input,.4)
    assert(slider.value>beforeRepeat,"held left stick must repeat adjustment")
    input.scripts.OnGamePadStick(input,"Movement",0,0)
    local released=slider.value
    input.scripts.OnUpdate(input,.4)
    assert(slider.value==released,"released stick kept changing slider")
    input.scripts.OnGamePadButtonDown(input,"PAD2")
    assert(W.controllerNavigation:GetCurrentButton()==W.settingsButtons.worldmap,"Back must return to categories")
    W:SetControllerTarget(slider)
    input.scripts.OnGamePadButtonDown(input,"PAD1")
    assert(W.editSlider==slider)
    local old=slider.value
    input.scripts.OnGamePadButtonDown(input,"PADDRIGHT")
    input.scripts.OnGamePadButtonUp(input,"PADDRIGHT")
    assert(slider.value>old)
    input.scripts.OnGamePadButtonDown(input,"PAD2")
    assert(not W.editSlider and W.frame:IsShown())
    W:SelectTab(1)
    W.rows[1]:GetScript("OnClick")(W.rows[1])
    assert(W.controllerNavigation:GetCurrentButton()==W.generate or W.controllerNavigation:GetCurrentButton()==W.open)
    local oldInfoAtPosition=C_Map.GetMapInfoAtPosition
    C_Map.GetMapInfoAtPosition=function(id,x,y)
        assert(x>=0 and x<=1 and y>=0 and y<=1)
        return {mapID=2}
    end
    W:SetMap(1); W:SetControllerTarget(W.search)
    assert(not W.mapCursor:IsShown(),"map cursor should hide when navigating controls")
    input.scripts.OnGamePadStick(input,"Movement",.8,0)
    assert(W.controllerNavigation:GetCurrentButton()==W.map and W.mapCursor:IsShown(),"stick must enter map focus")
    local beforeX=W.mapCursorX
    W.frame.scripts.OnUpdate(W.frame,.02)
    assert(W.mapCursorX>beforeX,"stick must move the visible cursor")
    input.scripts.OnGamePadStick(input,"Movement",0,0)
    local pan=addon.MapZoom.Pan
    local edgePan=0
    addon.MapZoom.Pan=function(_,x,y) assert(x>0); edgePan=edgePan+1 end
    W:MoveControllerMapCursor(2,0)
    assert(edgePan==1 and W.mapCursorX<1,"cursor must pan at edge and stay visible")
    addon.MapZoom.Pan=pan
    assert(W.mapCursor:IsShown())
    input.scripts.OnGamePadButtonDown(input,"PAD1")
    assert(W.mapID==2,"controller confirm failed to enter zone")
    local originalCursor=W.map.ScrollContainer.GetNormalizedCursorPosition
    W.map.ScrollContainer.GetNormalizedCursorPosition=function() return .2,.3 end
    local x,y=W.map:GetNormalizedCursorPosition()
    assert(x==.2 and y==.3,"mouse must not use Blizzard's unrelated soft cursor")
    W.map.ScrollContainer.GetNormalizedCursorPosition=originalCursor
    C_Map.GetMapInfoAtPosition=oldInfoAtPosition
    W:SelectTab(3)
    assert(W.pages[3]:IsShown() and not W.pages[1]:IsShown() and not W.pages[2]:IsShown())
    assert(W.controllerNavigation:GetCurrentButton()==W.tabs[3] and not W.mapCursor:IsShown())
    assert(W.controllerNavigation.scroll==W.changelogScroll,"release notes must own controller scrolling")
    W.changelogScroll:SetVerticalScroll(0)
    input.scripts.OnGamePadStick(input,"Camera",0,-1)
    input.scripts.OnUpdate(input,.1)
    assert(W.changelogScroll:GetVerticalScroll()>0,"right stick must scroll release notes")
    W:SetControllerTarget(W.tabs[1])
    input.scripts.OnGamePadButtonDown(input,"PAD1")
    assert(W.selectedTab==1 and W.frame:IsShown() and W.controllerNavigation:GetCurrentButton()==W.map)
    assert(W.controllerNavigation.scrollSpeed==0,"tab switch must stop held scrolling")
    W:ShowOnboarding(); assert(W.controllerNavigation:GetCurrentButton()==W.guide.next)
    assert(W.guide.info.text:find("Search by resource",1,true) and W.guide.info.text:find("Controller",1,true),"controller tip replaced feature explanation")
    input.scripts.OnGamePadButtonDown(input,"PAD2"); assert(not W.helpStep)
    input.scripts.OnGamePadButtonDown(input,"PAD2"); assert(not W.frame:IsShown() and not input:IsShown())
    W:Show(); enabled=false; W.frame.scripts.OnUpdate(W.frame,.02); assert(not input:IsShown() and not W.mapCursor:IsShown())
end
print("Addon-owned controller input and forbidden shared-stack regression passed")

-- Auto-open only once, and allow replay without changing the saved flag.
W.frame:Hide(); GatherLite.db.global.controlsGuideSeen=nil
W:ShowFirstLogin()
assert(W.frame:IsShown() and W.helpStep==1 and GatherLite.db.global.controlsGuideSeen)
local targets={W.search,W.generate:IsShown() and W.generate or W.routeCard,W.breadcrumb,W.map.ScrollContainer,W.tabs[2]}
for i=1,5 do
    assert(W.guide.relativeRegion==targets[i],"tip must point at the explained control")
    assert(W.guide.info.targetPoint and not W.guide.info.hideArrow,"native arrow missing")
    W.guide.next:GetScript("OnClick")()
end
assert(not W.helpStep and not W.pages[1].smartNavigationIgnored)
W.frame:Hide(); W:ShowFirstLogin(); assert(not W.frame:IsShown(),"guide reopened on subsequent login")
W:Show(); W.help:GetScript("OnClick")(); assert(W.helpStep==1)
W.guide.CloseButton:GetScript("OnClick")()
assert(not W.helpStep and not W.guide:IsShown(),"native close must dismiss the tour")
W:ShowOnboarding(); W:SelectTab(2)
assert(not W.helpStep,"switching away must not leave tips on hidden map controls")
W:SelectTab(1)
print("Controller shortcuts, map input lifecycle and first-login onboarding passed")

W.frame:Hide(); GatherLite:ToggleWindow(); assert(W.frame:IsShown())
GatherLite:ToggleWindow(); assert(not W.frame:IsShown())
assert(BINDING_NAME_GATHERLITE_TOGGLE=="Toggle GatherLite window")
print("Assignable main-window key binding passed")

W:Show(); W:SelectTab(2)
W.settingsButtons.debugging:GetScript("OnClick")()
local reset=addon.SettingsOptions.args.debugging.args.resetOnboarding
assert(reset and reset.type=="execute")
reset.func()
assert(W.selectedTab==1 and W.helpStep==1 and GatherLite.db.global.controlsGuideSeen,"reset must replay onboarding")
W:CloseOnboarding()
print("Controller settings sliders, category focus and onboarding reset passed")

-- Resource switches must clear old circuits, including suspended calculations.
GatherLite.db.global.usePredefined=true
W.map.canvasScale=1; W.map.ScrollContainer.scrollX=0; W.map.ScrollContainer:SetVerticalScroll(0)
W:Show(); W:SelectObject(addon.nodeDB[1])
GatherLite.db.char.routeVisible=true
R:Generate(addon.nodeDB[1]); while R.worker do R:Tick() end
assert(W.mapOverlay.lines[1]:IsShown())
local route=R.active
W:SelectObject(addon.nodeDB[1])
assert(R.byMap and R.object==addon.nodeDB[1],"reselecting same resource discarded routes")
W:SelectObject(addon.nodeDB[2])
assert(not R.active and not R.byMap and not R.worker and not GatherLite.db.char.routeObject)
for _,line in ipairs(W.mapOverlay.lines) do assert(not line:IsShown(),"old resource route remained visible") end
R:Generate(addon.nodeDB[1])
assert(R.object==addon.nodeDB[1] and R.worker,"pending route must retain its owner")
W:SelectObject(addon.nodeDB[2]); local chosenMap=W.mapID
R:Tick()
assert(not R.worker and W.object==addon.nodeDB[2] and W.mapID==chosenMap,"cancelled generation stole selection")
-- Defend every render path even if a stale active route is supplied.
R.active=route; R.byMap=nil
W:SetMap(route.mapID)
R:DrawOnCanvas(W.mapOverlay,W.map,addon.nodeDB[2])
for _,line in ipairs(W.mapOverlay.lines) do assert(not line:IsShown(),"renderer ignored resource mismatch") end
W:SetMap(777)
R:DrawOnCanvas(W.mapOverlay,W.map)
for _,line in ipairs(W.mapOverlay.lines) do assert(not line:IsShown(),"active fallback projected into wrong map") end
W:SetMap(route.mapID)
R:DrawOnCanvas(W.mapOverlay,W.map,route.object)
assert(W.mapOverlay.lines[1]:IsShown(),"matching resource/zone route must render")
R:Clear()
print("Route ownership passed: resource switches, same-resource retention, cancellation and map isolation")

-- Category filters combine with search and preserve the selected route/resource.
do
    local nodes,fish=addon.nodeDB,addon.fishDB
    addon.nodeDB={{type="ore",name="ore",icon="ore"},{type="herb",name="herb",icon="herb"},
        {type="container",name="container",icon="container"},{type="fishing",name="pool",icon="pool"}}
    addon.fishDB={{type="fish",name="catch",icon="fish"}}
    local selected=W.object
    W.search:SetText("")
    for i,button in ipairs(W.categoryButtons) do
        button:GetScript("OnClick")()
        local count=0
        for _,row in ipairs(W.rows) do
            if row:IsShown() then
                count=count+1
                assert(i==1 or row.object.type==button.category or (i==5 and row.object.type=="fish"))
            end
        end
        assert(count==(i==1 and 5 or i==5 and 2 or 1))
        assert(button.selected:IsShown() and W.object==selected)
    end
    W.search:SetText("catch"); W:RefreshList()
    assert(W.rows[1].object.type=="fish" and not W.rows[2]:IsShown())
    W.categoryButtons[2]:GetScript("OnClick")()
    assert(W.noResults:IsShown(), "search must combine with category filtering")
    addon.nodeDB,addon.fishDB=nodes,fish
    W.search:SetText(""); W.categoryButtons[1]:GetScript("OnClick")()
end
print("Native panel lifecycle and resource category filters passed")

-- Zone-first browsing and a combined selection use one deduplicated circuit.
do
    local copper,herb=addon.nodeDB[1],addon.nodeDB[2]
    local previousHerbs=addon.predefined[3]
    addon.predefined[3]={[1]={.1,.1,.5,.5,.7,.5}}
    GatherLite.db.global.usePredefined=true
    W:SelectObject(copper)
    W.zoneFilter:SetChecked(true); W.zoneFilter:GetScript("OnClick")(W.zoneFilter)
    W:SetMap(1)
    W.categoryButtons[3]:GetScript("OnClick")()
    assert(W.rows[1].object==herb and not W.rows[2]:IsShown(),"zone and herb category must combine")
    W.rows[1]:GetScript("OnClick")(W.rows[1])
    assert(W.mapID==1 and #W.selectedObjects==2 and W.object.objects,"checking a second resource must retain the map and first selection")
    assert(W.rows[1].check:GetChecked(),"selected herb checkbox is not checked")
    assert(#W.locations[1]==6,"combined collection must deduplicate shared coordinates")
    local herbPin=false
    for _,pin in ipairs(W.pins) do if pin:IsShown() and pin.object==herb then herbPin=true end end
    assert(herbPin,"combined map lost resource-specific pins")
    W.generate:GetScript("OnClick")()
    while R.worker do R:Tick() end
    assert(R.byMap[1] and not R.byMap[2] and #R.active.points==6,"zone generation escaped the chosen zone or omitted resources")
    assert(#GatherLite.db.char.routeObjects==2 and GatherLite.db.char.routeOnlyMapID==1,"combined route was not saved")
    -- Restore the saved multi-resource route through the actual startup path.
    R.setup()
    local watcher=frames[#frames]
    watcher:GetScript("OnUpdate")(watcher,.01)
    while R.worker do R:Tick() end
    assert(R.object.objects and #R.object.objects==2 and R.byMap[1] and not R.byMap[2],"reload dropped selected resources or zone scope")
    W:SetMap(2)
    assert(W.noResults:IsShown(),"resources from a different zone leaked into the list")
    assert(#W.selectedObjects==2,"browsing a zone silently changed checked resources")
    W:SetMap(1)
    W:ToggleObject(herb)
    assert(W.object==copper and not R.byMap,"unchecking did not invalidate combined route")
    R:Generate(copper)
    W:ToggleObject(herb)
    R:Tick()
    assert(not R.worker and W.object.objects,"selection change failed to cancel pending calculation")
    W:ToggleObject(herb); W:ToggleObject(copper)
    assert(not W.object and not W.generate:IsShown(),"last unchecked resource left stale selection")
    GatherLite.db.global.usePredefined=false
    W:RefreshList()
    assert(W.noResults:IsShown(),"zone availability ignored predefined-data setting")
    addon.nodes.herbalism={{object=3,mapID=1,posX=.3,posY=.3}}
    W:RefreshList()
    assert(W.rows[1]:IsShown() and W.rows[1].object==herb,"recorded herb missing with predefined data off")
    W.search:SetText("copper"); W:RefreshList()
    assert(W.noResults:IsShown(),"search did not combine with category and zone")
    addon.nodes.herbalism=nil; addon.predefined[3]=previousHerbs
    GatherLite.db.global.usePredefined=true
    W.search:SetText(""); W.categoryButtons[1]:GetScript("OnClick")()
end
print("Combined route selection, per-resource pins, zone filtering, saved restoration and cancellation passed")
