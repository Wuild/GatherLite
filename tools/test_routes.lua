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
    ClearLines=function(self) self.distanceLine=nil end,
    Show=function(self) self.shown=true end,
    Hide=function(self) self.shown=false; self.owner=nil end,
    IsShown=function(self) return self.shown end,
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
    "SetAtlas","SetTextColor","SetJustifyV","SetStatusBarTexture","SetStatusBarColor","SetMinMaxValues","EnableMouseWheel","SetMouseMotionEnabled","SetMouseClickEnabled"}) do methods[key]=function() end end
function methods:SetSize(w,h) self.width,self.height=w,h end
function methods:SetWidth(w) self.width=w end
function methods:SetHeight(h) self.height=h end
function methods:GetWidth() return self.width end
function methods:GetHeight() return self.height end
function methods:SetPoint(...) self.point={...} end
function methods:SetTexture(path) self.texture=path end
function methods:SetAtlas(atlas) self.atlas=atlas end
function methods:SetTexCoord(...) self.texCoord={...} end
function methods:SetVertexColor(...) self.vertexColor={...} end
function methods:SetAlpha(alpha) self.alpha=alpha end
function methods:GetAlpha() return self.alpha or 1 end
function methods:SetColorTexture(...) self.color={...} end
function methods:SetFrameStrata(strata) self.strata=strata end
function methods:SetMouseClickEnabled(enabled) self.mouseClick=enabled end
function methods:SetMouseMotionEnabled(enabled) self.mouseMotion=enabled end
function methods:EnableMouse(enabled) self.mouseEnabled=enabled end
function methods:SetSnapToPixelGrid() end
function methods:SetUserPlaced() end
function methods:GetCenter() return self.center or self.width / 2 end
function methods:GetTop() return self.top or self.height end
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
local localeTable = {}
LibStub=function(key)
    if key=="AceLocale-3.0" then
        return {NewLocale=function() return localeTable end, GetLocale=function() return localeTable end}
    elseif key=="HereBeDragons-2.0" then
        return HBD
    end
    return {allFrames={}}
end
load("scripts/locales/enUS.lua")
local events={}
GatherLite={modules={},plugins={},db={global={usePredefined=true,debug={types={}}},char={
    minimap={enabled=true,range=400,size=12,opacity=1,distance=70,loot=true},
    worldmap={enabled=true,size=12,opacity=1,loot=true,zoneTooltip=true},
    hud={enabled=false,range=250,width=300,height=20,pinSize=14,opacity=.9,x=0,y=-72,
        backgroundColor={r=.035,g=.03,b=.025},backgroundOpacity=.8,showBorder=true,hideInInstances=true},
},profile={minimap={}}}}
function GatherLite:On(event,fn) events[event]=events[event] or {}; table.insert(events[event],fn) end
function GatherLite:Trigger(event,...) for _,fn in ipairs(events[event] or {}) do fn(...) end end
function GatherLite:IsLoaded() return true end
function GatherLite:RegisterChatCommand() end
function GatherLite:translate(key, ...)
    local val = localeTable[key] or key
    if select("#", ...) > 0 then
        return string.format(val, ...)
    end
    return val
end
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
function GatherLite:GetNodesForMap(kind,mapID)
    local nodes={}
    for _,node in ipairs(addon.nodes[kind] or {}) do
        if node.mapID==mapID then nodes[#nodes+1]=node end
    end
    return nodes
end
addon.predefined={[2]={[1]={.1,.1,.9,.1,.9,.9,.1,.9},[2]={.4,.4,.6,.4,.6,.6,.4,.6}}}
load("plugins/routes/routes.lua")
load("plugins/routes/overlays.lua")
-- UI/controller fixtures use a flat world. Actual bundled terrain and the
-- adapter are exercised separately by test_ground_routes.lua.
addon.GroundNavigation={Build=function(_,points,_,checkpoint,progress)
    local route=P.Build(points,checkpoint,progress)
    if route then
        route.terrainAware=true
        route.geometry={unpack(route.points)}
        route.geometry[#route.geometry+1]=route.points[1]
    end
    return route
end}
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
assert(W:ShowSettings() and W.frame:IsShown() and W.selectedTab == 2, "settings shortcut must open directly to Settings")
W:Show()
assert(W.frame:GetWidth()==1160 and W.selectedTab==1)
assert(not UIPanelWindows.GatherLiteWindow and not nativePanel,
    "addon window must not enter Blizzard's protected controller panel manager")
assert(UISpecialFrames[#UISpecialFrames]=="GatherLiteWindow" and not W.frame.scripts.OnDragStart)
W.frame.CloseButton:GetScript("OnClick")()
assert(not nativePanel and not W.frame:IsShown(), "close button must hide the addon window")
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
assert(W.routeSummary.text==localeTable["window.route.ground"] and
    R.status:find(localeTable["window.route.ground"],1,true),
    "terrain route status must reach the selected route card")
assert(W.clear.enabled and not W.progress:IsShown())
-- Full ground geometry must reach both overlays, including a non-straight
-- return leg. Rendering the stops again would silently reintroduce shortcuts.
do
    local active=R.active
    local p=active.points
    active.geometry={p[1],{u=.5,v=.2,x=-500,y=-200,instance=0},p[2],p[3],
        {u=.3,v=.7,x=-300,y=-700,instance=0},p[4],p[1]}
    local function assertGeometry(frame)
        local visible=0
        for _,line in ipairs(frame.lines) do if line:IsShown() then visible=visible+1 end end
        assert(visible==6,"overlay replaced ground geometry with straight stop-to-stop segments")
    end
    R:DrawOnCanvas(W.mapOverlay,W.map,W.object)
    assertGeometry(W.mapOverlay)
    WorldMapFrame.mapID=2; playerMap=2
    R:Draw(.1)
    local found=false
    for _,frame in ipairs(frames) do
        if frame.parent==Minimap and frame.lines then assertGeometry(frame); found=true end
    end
    assert(found,"terrain minimap overlay was not drawn")
    active.geometry=nil
    W:DrawMap()
end
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
do
    local firstLine
    for _, f in ipairs(frames) do
        if f.kind == "Line" and f.parent.parent == WorldMapFrame.ScrollContainer and f:IsVisible() then firstLine = f; break end
    end
    assert(firstLine, "missing world map route")
    local start = firstLine.start
    R:Draw(.005)
    assert(firstLine.start == start, "an idle route must not rewrite its line anchors")
    WorldMapFrame.ScrollContainer.scrollX = 10
    R:Draw(.005)
    assert(firstLine.start ~= start, "a pan must update route positions before the minimap throttle elapses")
    WorldMapFrame.ScrollContainer.scrollX = 0
end
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
    assert(W.controllerInput:IsShown())
    W:SetControllerTarget(W.categoryButtons[2])
    input.scripts.OnGamePadButtonDown(input,"PAD1")
    assert(W.resourceCategory=="ore", "category must activate without native panel focus")
    assert(GameTooltip.owner==W.categoryButtons[2] and GameTooltip.text=="Mining",
        "controller category focus must identify the icon")
    W.categoryButtons[1]:GetScript("OnClick")()
    W:SetControllerTarget(W.map)
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

-- Exercise the compass through its own settings category and the live draw callback.
load("scripts/compat.lua")
function wipe(t) for k in pairs(t) do t[k]=nil end end
function GameTooltip:AddLine(text)
    if text:match("^%d+ yards away$") then
        self.distanceLine=text
        self.distanceUpdates=(self.distanceUpdates or 0)+1
    end
end
local hudQueries=0
local northNode={object=1,worldX=-500,worldY=-465,instance=0}
local overlappingNode={object=1,worldX=-500,worldY=-450,instance=0}
local eastNode={object=3,worldX=-550,worldY=-490,instance=0,predefined=true}
function GatherLite:GetNearbyZoneNodes(kind)
    hudQueries=hudQueries+1
    if kind=="mining" then
        return {northNode,overlappingNode}
    elseif kind=="herbalism" then
        return {eastNode}
    end
    return {}
end
local originalPlayerPosition=HBD.GetPlayerWorldPosition
local hudPlayerX,hudPlayerY=-500,-500
function HBD:GetPlayerWorldPosition() return hudPlayerX,hudPlayerY,0 end
function HBD:GetPlayerZone() return playerMap end
local hudOptions=addon.SettingsOptions.args.hud.args
local visibility=hudOptions.visibility.args
local function setHudExternalPins(enabled)
    GatherLite.db.char.hud.externalPins=enabled
    GatherLite:Trigger("settings:update")
end
assert(not hudOptions.tracking and hudOptions.mirrorMinimap.type=="toggle")
hudOptions.enabled.set(nil,false)
hudOptions.fullWidth.set(nil,false)
setHudExternalPins(false)
hudOptions.mirrorMinimap.set(nil,false)
visibility.hideOnWorldMap.set(nil,false)
visibility.hideInCombat.set(nil,false)
load("scripts/modules/hud.lua")
GatherLite.modules.HUD.setup()
assert(not GatherLiteHUD,"disabled HUD should allocate no frames")
W:SelectTab(2)
W.settingsButtons.hud:GetScript("OnClick")()
assert(W.settingsCategory=="hud" and W.settingsPanels.hud:IsShown())
GatherLite.db.global.usePredefined=true
hudOptions.enabled.set(nil,true)
local hud=GatherLiteHUD
local function drawHud(angle,elapsed)
    facing=angle
    hud:GetScript("OnUpdate")(hud,elapsed or .5)
    local marks={}
    for _,region in ipairs(frames) do
        if region.item and region.parent and region.parent.parent and region.parent.parent.parent==hud
            and region:IsVisible() then
            marks[#marks+1]=region
        end
    end
    return marks
end
local marks=drawHud(0)
assert(#marks==3 and marks[1].point[4]==0 and marks[2].point[4]==0,
    "overlapping pins must stay visible")
assert(marks[1]:GetAlpha()==1 and marks[2]:GetAlpha()==1,"distance must not change pin opacity")
assert(marks[3].icon.texture=="herb" and marks[3].point[4]>0,"east must appear to the right of north")
local hovered=marks[1]
assert(hovered.mouseMotion and not hovered.mouseClick,"HUD hover must pass clicks through to the game")
hovered:GetScript("OnEnter")(hovered)
assert(GameTooltip:IsOwned(hovered) and GameTooltip.text==GatherLite:translate("node.copper"))
assert(GameTooltip.distanceLine=="35 yards away")
local distanceUpdates=GameTooltip.distanceUpdates
hudPlayerY=-499.8
drawHud(0,.01)
assert(GameTooltip.distanceUpdates==distanceUpdates,"unchanged rounded distances need no tooltip refresh")
hudPlayerY=-498
drawHud(0,.01)
assert(GameTooltip:IsOwned(hovered) and GameTooltip.distanceLine=="33 yards away",
    "walking must update the hovered tooltip without re-entering the pin")
hovered:GetScript("OnLeave")(hovered)
assert(not GameTooltip:IsOwned(hovered))
hudPlayerY=-500
marks=drawHud(.12)
assert(marks[3]:GetAlpha()<1 and marks[1]:GetAlpha()==1,"only compass-edge pins should fade")
drawHud(0)
local queries=hudQueries
marks=drawHud(7*math.pi/4,.01)
local step=marks[1].point[4]
assert(step<0 and step>-40,"the compass must ease across north on the first frame")
marks=drawHud(7*math.pi/4,.01)
assert(marks[1]==hovered and marks[1].point[4]<step,"heading must update every frame using the same hover target")
marks=drawHud(7*math.pi/4)
assert(#marks==3 and marks[1].point[4]<0 and marks[3].point[4]>0)
hudPlayerX=-499
assert(drawHud(0,.5)[1].point[4]>0,"walking must update node bearings between index scans")
assert(hudQueries==queries,"turning and small movements must not rescan the node index")

local cfg=GatherLite.db.char.hud
assert(hud.strata=="BACKGROUND" and not hud.mouseEnabled)
hudOptions.move.func()
assert(hud.strata=="DIALOG" and hud.mouseEnabled,"move mode must raise the drag handle above settings")
hud:GetScript("OnDragStart")(hud)
hud.center,hud.top=UIParent:GetCenter()+65,UIParent:GetTop()-124
hud:GetScript("OnDragStop")(hud)
hud:GetScript("OnMouseUp")(hud,"RightButton")
assert(cfg.x==65 and cfg.y==-124 and hud.point[4]==65 and hud.strata=="BACKGROUND" and not hud.mouseEnabled,
    "dragging and finishing must save the position and restore the normal layer")
hudOptions.fullWidth.set(nil,true)
assert(hud:GetWidth()==UIParent:GetWidth() and hud.point[4]==0 and cfg.x==65)
local originalWidth=UIParent:GetWidth()
UIParent:SetWidth(1500)
drawHud(0)
assert(hud:GetWidth()==1500,"full width must follow UI size changes")
UIParent:SetWidth(originalWidth)
hudOptions.fullWidth.set(nil,false)
assert(hud:GetWidth()==cfg.width and hud.point[4]==65)

local background
for _,region in ipairs(frames) do
    if region.kind=="Texture" and region.color and not region.point and region.parent and region.parent.parent==hud then
        background=region
        break
    end
end
assert(background and background.color[4]==.8)
ColorPickerFrame={
    Hide=function() end, SetFrameStrata=function() end, GetColorRGB=function() return .2,.3,.4 end,
    SetupColorPickerAndShow=function(self,info) self.info=info end,
}
hudOptions.backgroundColor.func()
ColorPickerFrame.info.swatchFunc()
assert(cfg.backgroundColor.r==.2 and background.color[3]==.4)
ColorPickerFrame.info.cancelFunc()
assert(cfg.backgroundColor.r==.035 and background.color[3]==.025)
ColorPickerFrame=nil
hudOptions.backgroundOpacity.set(nil,0)
GatherLite:Trigger("settings:update")
assert(background.color[4]==0 and drawHud(0)[1].alpha>0,"background opacity must leave node icons visible")
hudOptions.height.set(nil,32)
GatherLite:Trigger("settings:update")
assert(hud:GetHeight()==32 and drawHud(0)[1]:GetHeight()==14,"compass height must not resize pins")
hudOptions.pinSize.set(nil,22)
GatherLite:Trigger("settings:update")
assert(hud:GetHeight()==32 and drawHud(0)[1]:GetHeight()==22,"HUD pin size must leave compass height independent")
hudOptions.pinSize.set(nil,14)
hudOptions.showBorder.set(nil,false)
local bordersFound=0
for _,region in ipairs(frames) do
    if region.kind=="Texture" and region.parent==background.parent and region~=background then
        assert(not region:IsShown(),"border toggle must hide the edge texture")
        bordersFound=bordersFound+1
    end
end
assert(bordersFound==2 and background:IsShown(),"border toggle must leave the background independent")
hudOptions.height.set(nil,20)
hudOptions.showBorder.set(nil,true)
do
    local function mockPin(atlas, name)
        local pin=CreateFrame("Frame",nil,Minimap)
        pin.data={Name=name}
        local art=pin:CreateTexture()
        pin.IconTexture=art
        function art:GetTexture() return 42 end
        function art:GetAtlas() return atlas end
        function art:GetVertexColor() return .4,.8,1,1 end
        function art:GetTexCoord() return .25,.5,.25,.75,.5,.5,.5,.75 end
        return pin
    end
    local quest=mockPin("QuestNormal","Test Quest")
    local own=mockPin(nil,"GatherLite pin")
    local hidden=mockPin(nil,"Hidden pin")
    local otherMap=mockPin(nil,"Other instance")
    hidden:Hide()
    addon.name="GatherLite"
    Pins.activeMinimapPins={
        [quest]={instanceID=0,x=-475,y=-460}, [own]={instanceID=0,x=-468,y=-474},
        [hidden]={instanceID=0,x=-481,y=-451}, [otherMap]={instanceID=1,x=-485,y=-468},
    }
    Pins.minimapPinRegistry={GatherLite={[own]=true}}
    assert(#drawHud(0)==3,"addon pins must be off by default")
    setHudExternalPins(true)
    local pins=drawHud(0)
    assert(#pins==4,"only visible external pins on the current instance should be copied")
    local external
    for _,mark in ipairs(pins) do
        if mark.item.external then external=mark end
    end
    assert(external and external.icon.atlas=="QuestNormal" and external.icon.texCoord[1]==.25
        and external.icon.vertexColor[2]==.8)
    external:GetScript("OnEnter")(external)
    assert(GameTooltip.text=="Test Quest")
    quest:Hide()
    assert(#drawHud(0,.21)==3 and not GameTooltip:IsOwned(external),"hidden source pins must clear from the HUD")
    quest:Show()
    assert(#drawHud(0,.21)==4)
    quest:SetAlpha(0)
    assert(#drawHud(0,.21)==3,"transparent source pins must also disappear")
    quest:SetAlpha(1)
    assert(#drawHud(0,.21)==4)
    setHudExternalPins(false)
    assert(#drawHud(0,.01)==3,"turning off addon pins must remove them immediately")

    local fish=mockPin(nil,"Fish")
    fish.fish={{name="Test Fish"}}
    own.object={name="copper"}
    Pins.activeMinimapPins[fish]={instanceID=0,x=-520,y=-459}
    Pins.minimapPinRegistry[addon.Fishing]={[fish]=true}
    local mini=GatherLite.db.char.minimap
    local previousHide,previousHerb=mini.hideNearbyNodes,mini.herbalism
    mini.hideNearbyNodes,mini.herbalism=true,false
    own:Hide()
    hudOptions.mirrorMinimap.set(nil,true)
    pins=drawHud(0,.01)
    assert(#pins==4,"mirror mode must retain nearby GatherLite nodes and show compatible addon pins")
    local labels,resources={},0
    for _,mark in ipairs(pins) do
        if mark.item.external then
            labels[mark.item.title]=true
        else
            assert(mark.item.object.name=="copper" and mark.distance<mini.distance,
                "mirror mode must honor minimap filters while ignoring nearby hiding")
            resources=resources+1
        end
    end
    assert(labels["Test Quest"] and labels["Test Fish"] and resources==2,
        "mirror mode must include addon, GatherLite and fish pins")
    own:Show()
    assert(#drawHud(0,.21)==4,"a visible GatherLite minimap pin must not duplicate the indexed HUD pin")
    mini.hideNearbyNodes,mini.herbalism=previousHide,previousHerb
    hudOptions.mirrorMinimap.set(nil,false)
    pins=drawHud(0,.01)
    assert(#pins==3 and not pins[1].item.external,
        "turning off the mirror must restore independent HUD filters")
    Pins.activeMinimapPins,Pins.minimapPinRegistry=nil,nil
end
GatherLite.db.global.usePredefined=false
GatherLite:Trigger("settings:update")
assert(#drawHud(0)==2,"HUD must honor the predefined-data setting")
GatherLite.db.global.usePredefined=true
GatherLite:SetNodeTracking("hud","herbalism",false)
assert(#drawHud(0)==2 and GatherLite:GetNodeTracking("worldmap","herbalism"),"HUD filters must be independent")
local originalIsInInstance,originalInCombatLockdown=IsInInstance,InCombatLockdown
IsInInstance=function() return true end
assert(#drawHud(0)==0,"instances must hide the compass by default")
visibility.hideInInstances.set(nil,false)
assert(#drawHud(0)==2,"instance hiding must be optional")
IsInInstance=originalIsInInstance
InCombatLockdown=function() return true end
visibility.hideInCombat.set(nil,true)
assert(#drawHud(0)==0,"combat hiding must be optional")
hudOptions.move.func()
assert(hud.strata=="DIALOG" and hud.mouseEnabled and hud:IsVisible(),"move mode must override visibility")
hud:GetScript("OnMouseUp")(hud,"RightButton")
InCombatLockdown=originalInCombatLockdown
visibility.hideInCombat.set(nil,false)
local mapWasShown=WorldMapFrame:IsShown()
WorldMapFrame:Show()
visibility.hideOnWorldMap.set(nil,true)
assert(#drawHud(0)==0,"an open world map must hide the HUD when selected")
WorldMapFrame:Hide()
assert(#drawHud(0)==2,"closing the map must restore the HUD")
WorldMapFrame:SetShown(mapWasShown)
visibility.hideOnWorldMap.set(nil,false)
assert(#drawHud(nil)==0,"unavailable facing must clear markers")
hudOptions.enabled.set(nil,false)
assert(not hud:IsShown(),"disabling the HUD must stop drawing")
HBD.GetPlayerWorldPosition=originalPlayerPosition
facing=0
print("HUD GPS passed: smooth heading and motion, hover, drag, strata, width, color, opacity, filters and visibility")

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
print("Protected-panel isolation and resource category filters passed")

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
    local cache=assert(GatherLite.db.char.savedRoute,"completed geometry was not persisted")
    assert(not cache.byMap[1].object,"saved routes retained a live resource object")
    local originalBuild=addon.GroundNavigation.Build
    addon.GroundNavigation.Build=function() error("reload recalculated saved geometry") end
    R.worker,R.active,R.object,R.byMap,R.bestMapID=nil,nil,nil,nil,nil
    R.setup()
    local watcher=frames[#frames]
    watcher:GetScript("OnUpdate")(watcher,.01)
    while R.worker do R:Tick() end
    assert(R.object.objects and #R.object.objects==2 and R.byMap[1] and not R.byMap[2],"reload dropped selected resources or zone scope")
    assert(not R.worker and R.active.geometry and R.active.geometry~=cache.byMap[1].geometry,
        "reload did not restore an independent terrain circuit immediately")
    addon.GroundNavigation.Build=originalBuild
    local object=R.object
    cache.schema=0
    assert(not R:Restore(object,1,1),"outdated planner cache was accepted")
    cache.schema=1
    local version,build,id=cache.version,cache.build,cache.ids[1]
    cache.version="outdated-version"
    assert(not R:Restore(object,1,1),"different addon version reused saved geometry")
    cache.version=version; cache.build=-1
    assert(not R:Restore(object,1,1),"different client build reused saved geometry")
    cache.build=build; cache.ids[1]=-1
    assert(not R:Restore(object,1,1),"different resource selection reused saved geometry")
    cache.ids[1]=id; cache.predefined=false
    assert(not R:Restore(object,1,1),"reference-data setting change kept stale geometry")
    cache.predefined=true
    local x=cache.byMap[1].geometry[1].x
    cache.byMap[1].geometry[1].x=0/0
    assert(not R:Restore(object,1,1),"malformed cached geometry was accepted")
    cache.byMap[1].geometry[1].x=x
    assert(not R:Restore(object,2,2),"different zone scope reused a saved circuit")
    W:SetMap(2)
    assert(W.noResults:IsShown(),"resources from a different zone leaked into the list")
    assert(#W.selectedObjects==2,"browsing a zone silently changed checked resources")
    W:SetMap(1)
    W:ToggleObject(herb)
    assert(W.object==copper and not R.byMap,"unchecking did not invalidate combined route")
    assert(not GatherLite.db.char.savedRoute,"clearing a route retained saved geometry")
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
    GatherLite:Trigger("nodes:added",addon.nodes.herbalism[1])
    assert(W.rows[1]:IsShown() and W.rows[1].object==herb,"recorded herb missing with predefined data off")
    W:SelectObject(herb)
    assert(#W.locations[1]==1)
    addon.nodes.herbalism[2]={object=3,mapID=1,posX=.7,posY=.7}
    GatherLite:Trigger("nodes:added",addon.nodes.herbalism[2])
    assert(#W.locations[1]==2 and W.mapID==1,"new self-found location did not refresh selected resource")
    local visible=0
    for _,pin in ipairs(W.pins) do if pin:IsShown() then visible=visible+1 end end
    assert(visible==2,"new self-found location did not refresh window pins")
    local locations=W.locations
    GatherLite:Trigger("nodes:added",{object=1,mapID=1})
    assert(W.locations==locations,"unrelated gather recollected the selected resource")
    W.search:SetText("copper"); W:RefreshList()
    assert(W.noResults:IsShown(),"search did not combine with category and zone")
    addon.nodes.herbalism=nil; addon.predefined[3]=previousHerbs
    GatherLite.db.global.usePredefined=true
    W.search:SetText(""); W.categoryButtons[1]:GetScript("OnClick")()
end
print("Combined route selection, per-resource pins, zone filtering, saved restoration and cancellation passed")

-- Zone browsing and zone-only route input must stay independent of the size
-- of other zones. Use prebuilt buckets, as GetNodesForMap does in the addon.
do
    local originalNodes, originalQuery = addon.nodes, GatherLite.GetNodesForMap
    local originalPredefined = GatherLite.db.global.usePredefined
    local target = {
        {object=1,mapID=1,posX=.1,posY=.1},
        {object=1,mapID=1,posX=.9,posY=.1},
        {object=1,mapID=1,posX=.9,posY=.9},
        {object=1,mapID=1,posX=.1,posY=.9},
    }
    local all, offMapReads = {}, 0
    for _,node in ipairs(target) do all[#all+1]=node end
    for i=1,50000 do
        all[#all+1]=setmetatable({object=1,posX=.5,posY=.5}, {__index=function(_,key)
            if key=="mapID" then offMapReads=offMapReads+1; return 2 end
        end})
    end
    addon.nodes={mining=all}
    GatherLite.db.global.usePredefined=false
    local queries=0
    function GatherLite:GetNodesForMap(kind,mapID)
        queries=queries+1
        assert(kind=="mining" and mapID==1)
        return target
    end
    assert(R:ZoneResources(1)[1] and offMapReads==0 and queries==1,
        "resource browsing scanned unrelated zones")
    local checkpoints=0
    local collected=R:Collect(addon.nodeDB[1],function() checkpoints=checkpoints+1 end,1)
    assert(#collected[1]==4 and not collected[2] and checkpoints==4 and offMapReads==0,
        "zone-only routes scanned unrelated zones or lost target locations")
    local originalReference = addon.predefined
    addon.predefined = { [1] = { [1]={.1,.1}, [2]={.1,.1,.2,.2,.3,.3} } }
    GatherLite.db.global.usePredefined = true
    checkpoints = 0
    collected = R:Collect(addon.nodeDB[1], function() checkpoints=checkpoints+1 end, 1)
    assert(#collected[1] == 4 and not collected[2] and checkpoints == 5,
        "a zone route must not even visit compressed locations for other zones")
    addon.predefined = originalReference
    -- Compare against the previous whole-database availability scan.
    local available={}
    for _,node in ipairs(all) do
        if node.mapID==1 then available[node.object]=true end
    end
    assert(available[1] and offMapReads==50000)
    addon.nodes, GatherLite.GetNodesForMap = originalNodes, originalQuery
    GatherLite.db.global.usePredefined=originalPredefined
end
print("Indexed zone browsing: 4 candidate nodes instead of 50,004; zone-only route collection visits 4 candidates")

do
    local originalGenerate=R.Generate
    local restoredScope
    GatherLite.db.char.savedRoute=nil
    GatherLite.db.char.routeObjects={1}
    GatherLite.db.char.routeMapID=1
    GatherLite.db.char.routeOnlyMapID=nil
    R.worker=nil
    function R:Generate(object,mapID,onlyMapID)
        assert(object==addon.nodeDB[1] and mapID==1)
        restoredScope=onlyMapID
    end
    R.setup()
    local watcher=frames[#frames]
    watcher:GetScript("OnUpdate")(watcher,.01)
    assert(restoredScope==1,"legacy reload rebuilt every zone instead of the saved farming zone")
    R.Generate=originalGenerate
end
print("Legacy route restoration rebuilds only the saved zone")

do
    local locations = {
        [1] = {{x=0,y=0,instance=0},{x=5000,y=0,instance=0},{x=5000,y=5000,instance=0},{x=0,y=5000,instance=0}},
        [2] = {{x=0,y=0,instance=0},{x=200,y=0,instance=0},{x=200,y=200,instance=0}},
    }
    assert(R:SortedZones(locations)[1] == 1, "the standalone location order must remain count-based")
    assert(R:RecommendedZones(locations)[1] == 2, "recommend the denser route instead of the larger raw node count")
    assert(R:RecommendedZones(locations, { [1]={score=.4}, [2]={score=.3} })[1] == 1,
        "use completed terrain scores when available")
end

do
    load("plugins/openmap/openmap.lua")
    load("scripts/maps/worldmap-sidebar.lua")
    local sidebar = GatherLite.modules.worldMapSidebar
    local world = WorldMapFrame
    local scroll, canvas = world.ScrollContainer, world:GetCanvas()
    local combat, dragging = false, false
    function InCombatLockdown() return combat end
    function IsMouseButtonDown() return dragging end
    function methods:GetEffectiveScale() return self.scale or 1 end
    function methods:GetLeft() return self.left or 0 end
    function methods:GetTop() return self.top or 0 end
    function methods:GetParent() return self.parent end
    function methods:IsProtected() return self.protected or false end
    local function trackAnchors(frame, anchors)
        function frame:GetNumPoints() return #anchors end
        function frame:GetPoint(index) return unpack(anchors[index]) end
        function frame:SetPoint(point, ...)
            assert(not combat or not self:IsProtected(), "protected anchors must wait for combat to end")
            for i, anchor in ipairs(anchors) do
                if anchor[1] == point then anchors[i] = { point, ... }; return end
            end
            error("unexpected anchor change: " .. point)
        end
    end
    local anchors = {
        { "TOPLEFT", world, "TOPLEFT", 2, -25 },
        { "BOTTOMLEFT", world, "BOTTOMLEFT", 0, 2 },
        { "RIGHT", world, "RIGHT", -3, 0 },
    }
    local baseLeft, baseWidth, refits, windowRefits, artFits = 300, 1000, 0, 0, 0
    local function inset() return anchors[1][4] - 2 end
    trackAnchors(scroll, anchors)
    function scroll:GetLeft() return baseLeft + inset() end
    function scroll:GetWidth() return baseWidth - inset() end
    function scroll:CreateZoomLevels()
        local fit = math.min(self:GetWidth() / 1002, self:GetHeight() / 668)
        self.zoomLevels = { {scale=fit,layerIndex=1}, {scale=fit*2,layerIndex=2} }
    end
    function scroll:OnCanvasSizeChanged()
        refits = refits + 1
        self.mapID = world.mapID
        self:CreateZoomLevels()
        canvas:SetSize(1002, 668)
        self.currentScale = self.zoomLevels[1].scale
    end
    function scroll:GetCanvasScale() return self.currentScale end
    function scroll:GetNormalizedHorizontalScroll() return .5 end
    function scroll:GetNormalizedVerticalScroll() return .5 end
    function scroll:InstantPanAndZoom(scale)
        assert(not combat, "GatherLite must not adjust canvas zoom in combat")
        self.currentScale, artFits = scale, artFits + 1
    end
    function world:OnFrameSizeChanged()
        windowRefits = windowRefits + 1
        scroll:OnCanvasSizeChanged()
    end
    local title, footer, close = node("Frame", nil, world), node("Frame", nil, world), node("Button")
    local titleAnchors = { {"BOTTOMLEFT", scroll, "TOPLEFT", 0, 0}, {"BOTTOMRIGHT", scroll, "TOPRIGHT", 333, 0} }
    local footerAnchors = { {"TOPLEFT", scroll, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", scroll, "BOTTOMRIGHT", 333, 0} }
    trackAnchors(title, titleAnchors)
    trackAnchors(footer, footerAnchors)
    trackAnchors(close, { {"RIGHT", title, "RIGHT", -2, 0} })
    footer.back, footer.t = {}, {}
    function world:GetChildren() return self.ScrollContainer, title, footer end
    function world:SynchronizeDisplayState()
        footerAnchors[1][4] = 0
    end
    C_AddOns = { IsAddOnLoaded=function(name) return name == "Leatrix_Maps" end }
    R:Clear()
    W:Hide()
    world:Show()
    world:SetMapID(1)
    addon.predefined[3] = { [1] = { .2,.2,.7,.3,.6,.8 } }
    local remote = { type="ore", name="remote_ore", icon="ore", id={4} }
    addon.nodeDB[3] = remote
    addon.predefined[4] = { [2] = { .1,.1,.8,.2,.7,.9 } }
    sidebar.setup()
    local function update() sidebar.driver:GetScript("OnUpdate")(sidebar.driver, .16) end
    local function toggle() sidebar:Toggle() end
    local function findRow(object)
        for i = 1, sidebar.rowCount do
            if sidebar.rows[i].object == object then return sidebar.rows[i] end
        end
    end
    update()
    assert(sidebar.panel:IsVisible() and not sidebar.hud:IsShown() and not sidebar.generate:IsEnabled())
    assert(not sidebar.zoneFilter and not sidebar.toggle and findRow(remote), "the sidebar must use one map button and a global list")
    assert(not sidebar.status and sidebar.list.point[1] == "BOTTOMRIGHT" and sidebar.list.point[3] == 65,
        "the resource list must extend to the route buttons")
    assert(sidebar.panel.point[1] == "BOTTOMRIGHT" and sidebar.panel.point[2] == scroll
        and sidebar.panel.point[3] == "BOTTOMLEFT", "the pane must end where the map begins")
    assert(inset() == 254 and scroll:GetLeft() == 554 and sidebar.panel.width == 250,
        "the pane must stay inside the map even when there is screen space on the left")
    assert(math.abs(scroll:GetCanvasScale() - 1000/668) < .0001
        and scroll.zoomLevels[1].scale == scroll:GetWidth()/1002,
        "Blizzard map art must fill the canvas without writing to native zoom levels")
    assert(refits == 1 and windowRefits == 0, "docking must refit the canvas without resizing the outer map")
    world.BorderFrame = { CloseButton = close }
    world:Hide(); world:Show()
    assert(titleAnchors[1][4] == -254 and footerAnchors[1][4] == -254,
        "the open hook must wrap the dock before the first update")
    update()
    assert(titleAnchors[1][4] == -254 and footerAnchors[1][4] == -254 and titleAnchors[2][4] == 333,
        "Leatrix must enclose the pane while keeping the right-side quest width")
    title:SetPoint("BOTTOMLEFT", scroll, "TOPLEFT", 0, 0)
    world:Hide(); world:Show()
    update()
    assert(titleAnchors[1][4] == -254 and refits == 1 and windowRefits == 0 and artFits == 1,
        "reopening the Leatrix map must restore chrome without resetting the canvas or window")
    world:SynchronizeDisplayState()
    assert(footerAnchors[1][4] == -254 and refits == 1 and windowRefits == 0,
        "display-state changes must restore Leatrix chrome without touching the canvas or window size")
    baseLeft, baseWidth = 10, 470
    scroll:GetScript("OnSizeChanged")()
    dragging = true
    update()
    assert(inset() == 254, "a drag must not repeatedly reflow the map")
    dragging = false
    update()
    assert(inset() == 220 and sidebar.panel.width == 216 and scroll:GetWidth() == 250,
        "narrow maps must shrink the resource pane before shrinking the map below its minimum")
    assert(anchors[2][4] == 220 and anchors[3][4] == -3, "resize both left anchors and leave the quest pane side alone")
    update()
    assert(refits == 2 and artFits == 1, "Leatrix owns canvas zoom and a settled layout must not resize again")
    combat = true
    scroll.protected = true
    titleAnchors[1][4], footerAnchors[1][4] = 0, 0
    world:Hide(); world:Show()
    assert(inset() == 220 and titleAnchors[1][4] == -220 and footerAnchors[1][4] == -220 and refits == 2,
        "reopening in combat must restore Leatrix chrome immediately without resizing the protected viewport")
    update()
    local function leatrixEvent(event)
        assert(sidebar.driver.events[event])
        sidebar.driver:GetScript("OnEvent")(sidebar.driver, event)
        update()
    end
    combat = false
    titleAnchors[1][4], footerAnchors[1][4] = 0, 0
    leatrixEvent("PLAYER_REGEN_ENABLED")
    assert(titleAnchors[1][4] == -220 and footerAnchors[1][4] == -220 and refits == 2,
        "Leatrix's combat-end reset must restore the chrome even when the canvas stays the same size")
    footerAnchors[1][4] = 0
    leatrixEvent("UI_SCALE_CHANGED")
    assert(footerAnchors[1][4] == -220 and refits == 2,
        "Leatrix's pixel-edge reset must restore the footer without refitting the canvas")
    combat = true
    baseWidth = 480
    scroll:GetScript("OnSizeChanged")()
    world:OnFrameSizeChanged()
    titleAnchors[1][4], footerAnchors[1][4] = 0, 0
    title.protected = true
    toggle()
    update()
    assert(sidebar.panel:IsVisible() and inset() == 220 and titleAnchors[1][4] == 0 and footerAnchors[1][4] == -220
        and refits == 3 and not sidebar.chromeDirty, "protected chrome must wait for the combat-end event")
    combat = false
    leatrixEvent("PLAYER_REGEN_ENABLED")
    assert(inset() == 230 and titleAnchors[1][4] == -230 and windowRefits == 1,
        "a queued dock update must run after combat without calling the outer resize")
    toggle()
    assert(not sidebar.panel:IsShown() and inset() == 0 and anchors[2][4] == 0 and scroll:GetWidth() == 480,
        "collapse must restore the original left anchors")
    assert(titleAnchors[1][4] == 0 and footerAnchors[1][4] == 0 and scroll.zoomLevels[1].scale == 480/1002,
        "collapse must restore Leatrix chrome and the native fit scale")
    toggle()
    baseWidth = 430
    scroll:GetScript("OnSizeChanged")()
    update()
    assert(not sidebar.panel:IsShown() and inset() == 0, "a narrow map must recover its full canvas width")
    baseWidth = 1000
    scroll:GetScript("OnSizeChanged")()
    update()
    world:SetMapID(2)
    local herbRow = assert(findRow(addon.nodeDB[2]))
    herbRow:GetScript("OnClick")(herbRow)
    assert(world:GetMapID() == 1 and sidebar.zoneIndex == 1 and sidebar.zoneCounter:GetText() == "1 / 1 zones",
        "selecting a resource must jump from the current map to its recommended zone")
    local oreRow = assert(findRow(addon.nodeDB[1]))
    oreRow:GetScript("OnClick")(oreRow)
    assert(world:GetMapID() == sidebar.zones[1] and sidebar.zoneIndex == 1,
        "adding a resource must jump to the combined selection's recommendation")
    update()
    world:SetMapID(1)
    update()
    assert(#sidebar:GetSelection() == 2 and sidebar.generate:IsEnabled() and sidebar.hud:IsVisible()
        and sidebar.hud.point[1] == "BOTTOMLEFT" and sidebar.hud.point[2] == scroll
        and sidebar.hud.point[4] == 0 and sidebar.hud.point[5] == 0 and sidebar.zoneName:GetText() == "Zone 1",
        "combined resources must show a bottom-left zone HUD")
    sidebar.next:GetScript("OnClick")()
    assert(world:GetMapID() == 2 and sidebar.zoneName:GetText() == "Zone 2" and findRow(remote),
        "next zone must move the map while leaving the list global")
    sidebar.previous:GetScript("OnClick")()
    assert(world:GetMapID() == 1 and sidebar.zoneName:GetText() == "Zone 1")
    local groundBuild = addon.GroundNavigation.Build
    function addon.GroundNavigation:Build(points, mapID, checkpoint, progress)
        progress(.5)
        coroutine.yield()
        return groundBuild(self, points, mapID, checkpoint, progress)
    end
    sidebar.generate:GetScript("OnClick")()
    assert(sidebar.generate:GetText():find("0%%") and sidebar.progress:IsVisible() and sidebar.progress.value == 0
        and sidebar.progress.point[2] == sidebar.hud, "generation must immediately show progress above the map HUD")
    R:Tick()
    assert(sidebar.progress.value > 0 and sidebar.progress.value < 100, "the route worker must advance the progress bar")
    sidebar.clear:GetScript("OnClick")()
    assert(not R.worker and not sidebar.progress:IsShown(), "cancelling must dismiss map progress")
    sidebar.generate:GetScript("OnClick")()
    while R.worker do R:Tick() end
    addon.GroundNavigation.Build = groundBuild
    assert(not sidebar.progress:IsShown(), "completing a route must dismiss map progress")
    assert(world:IsShown() and not W.frame:IsShown() and R.active.mapID == 1 and R.onlyMapID == 1 and not R.byMap[2],
        "generation must solve only the zone in the HUD")
    local built = R.active
    sidebar.generate:GetScript("OnClick")()
    assert(not R.worker and R.active == built, "regenerating the same selection and zone must reuse the completed route")
    update()
    sidebar.visibility:GetScript("OnClick")()
    assert(GatherLite.db.char.routeVisible == false)
    sidebar.visibility:GetScript("OnClick")()
    assert(GatherLite.db.char.routeVisible)

    local stitched, zoom, stitchedZone, now = false, 8, 2, 0
    GetTime = function() return now end
    local focus
    OpenMapAPI = { major=1, IsStitched=function() return stitched end,
        GetView=function() return .65,.45,zoom end, MapAt=function() return stitchedZone end,
        WorldFromMap=function(id,x,y) return (id - 1) * .5 + x * .5, y end,
        MapFromWorld=function(id,u,v) return (u - (id - 1) * .5) / .5, v end,
        ShowWorld=function(u,v,level) focus={u,v,level}; return true end,
        ArtTopLevel=function() return 500 end }
    toggle()
    assert(not sidebar.hud:IsVisible(), "the zone HUD must hide when the resource pane is collapsed")
    baseLeft, scroll.top, scroll.scale = 100, 600, 1
    canvas.left, canvas.top, canvas.scale = 550, 300, 2
    canvas:SetSize(1000,1000)
    world:SetMapID(2)
    local left, right, top, bottom = R:GetViewport(world, true)
    assert(left == -.5 and right == 0 and top == 0 and bottom == .5, "scaled stitched viewport coordinates")
    local layer = node("Frame", nil, scroll)
    layer.lines = {}
    layer:SetSize(1000,1000)
    R:DrawOnCanvas(layer, world)
    assert(#layer.lines == 0, "native maps must not render a route from another zone")
    R:DrawOnCanvas(layer, world, nil, OpenMapAPI)
    assert(layer.lines[1] and layer.lines[1]:IsShown(), "stitched maps must draw routes extending outside the host map")

    world:SetMapID(1)
    stitched = true
    toggle()
    assert(sidebar.hud:IsVisible() and sidebar.zoneName:GetText() == "Zone 2" and #sidebar:GetSelection() == 2 and findRow(remote),
        "the zone HUD must follow the stitched view while retaining the selection and catalog")
    assert(scroll.zoomLevels[1].scale == scroll:GetWidth()/1002, "leave stitched-map zoom levels to OpenMap")
    sidebar.previous:GetScript("OnClick")()
    assert(focus and focus[1] == .25 and focus[2] == .5 and focus[3] == 7, "zone HUD must open at pin visibility zoom")
    local remoteRow = assert(findRow(remote))
    remoteRow:GetScript("OnClick")(remoteRow)
    local recommended = sidebar.zones[1]
    assert(sidebar.zoneIndex == 1 and focus[1] == (recommended - 1) * .5 + .25,
        "selection must immediately show the recommendation and start an OpenMap glide")
    stitchedZone = recommended == 1 and 2 or 1
    now = .2
    update()
    assert(sidebar.zoneIndex == 1, "the HUD must not jump to a zone passed during the glide")
    now, stitchedZone = .6, recommended
    update()
    stitchedZone = recommended == 1 and 2 or 1
    update()
    assert(sidebar.zones[sidebar.zoneIndex] == stitchedZone, "manual panning must update the HUD after the glide")
    sidebar.search:SetText("missing")
    sidebar.search:GetScript("OnTextChanged")()
    assert(sidebar.empty:IsShown() and sidebar.rowCount == 0)
    zoom = 1
    update()
    sidebar.search:SetText("")
    sidebar.search:GetScript("OnTextChanged")()
    assert(findRow(remote) and findRow(addon.nodeDB[2]) and sidebar.generate:IsEnabled(),
        "the full catalog and route generation must also work from the world overview")
    sidebar.clear:GetScript("OnClick")()
    local row = assert(findRow(remote))
    row:GetScript("OnClick")(row)
    sidebar.generate:GetScript("OnClick")()
    while R.worker do R:Tick() end
    assert(R.active and R.active.mapID == 2 and R.onlyMapID == 2 and world:GetMapID() == 1 and focus[1] == .75,
        "a resource outside the view must generate only in the HUD's destination zone")
    toggle()
    assert(not sidebar.panel:IsShown() and GatherLite.db.char.worldMapSidebarCollapsed)
    toggle()
    assert(sidebar.panel:IsShown())
    world:Hide()
    assert(not sidebar.panel:IsVisible(), "closing the world map must hide the sidebar")
end
print("World map sidebar passed: docking, global resources, bottom-left zone HUD, scoped routes and OpenMap alignment")
