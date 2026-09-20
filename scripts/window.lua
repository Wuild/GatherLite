local _, addon = ...
local UI, Routes = addon.UI, addon.Routes
local HBD = LibStub("HereBeDragons-2.0")
local Window = {}
addon.Window = Window
local function objectName(object) return object.type=="fish" and object.name or GatherLite:translate("node." .. object.name) end
local resourceKinds={ore="Mining",herb="Herbalism",container="Containers",fishing="Fishing pools",fish="Fish catches"}
local function mapName(id)
    local info=id and C_Map.GetMapInfo(id)
    return info and info.name or "World"
end

function Window:RefreshSettings()
    if not self.frame then return end
    for _,panel in pairs(self.settingsPanels) do if panel:IsShown() then panel:Refresh() end end
end
function Window:RefreshRoute()
    if not self.frame then return end
    local fish=self.object and self.object.type=="fish"
    self.status:SetText(fish and "Fishing locations | Reports show possible catches, not guaranteed spawns." or Routes.status)
    self.requirement:SetText(UI.Requirement(self.object))
    self.cardTitle:SetText(fish and "FISHING LOCATIONS" or "FARMING ROUTE")
    self.generate:SetEnabled(self.object~=nil)
    self.generate:SetText(Routes.progress and "Restart calculation" or "Generate zone routes")
    self.clear:SetEnabled(Routes.byMap~=nil or Routes.progress~=nil)
    self.clear:SetText(Routes.progress and "Cancel" or "Clear")
    self.visibility:SetText(GatherLite.db.char.routeVisible==false and "Show route" or "Hide route")
    self.routeIcon:SetTexture(self.object and self.object.icon or "Interface\\Icons\\INV_Misc_Map_01")
    local route=Routes.object==self.object and Routes.byMap and Routes.byMap[self.mapID]
    self.routeSummary:SetText(Routes.progress and "Planning your farming circuits..." or
        (route and string.format("%d stops  |  %.1f km%s",#route.points,route.length*.0009144,
            self.mapID==Routes.bestMapID and "  |  Best" or "") or
        (self.object and "Browse zones and generate your routes." or "Choose a resource to plan your run.")))
    self.visibility:SetEnabled(fish or Routes.byMap~=nil)
    if fish then
        local count=#((self.locations or {})[self.mapID] or {})
        self.generate:SetText(count>0 and "Catch locations shown" or "Zone information only")
        self.generate:SetEnabled(false)
        self.clear:SetEnabled(true)
        self.visibility:SetText(addon.Fishing.visible and "Hide catches" or "Show catches")
        self.routeSummary:SetText(count>0 and "Reported catches; availability can vary." or
            "Known fishing zone; precise catch positions are not published.")
    end
    -- Keep the empty state small and only show actions that have something to act on.
    local selected=self.object~=nil
    local hasActions=fish or Routes.byMap~=nil or Routes.progress~=nil
    local multipleZones=selected and #(self.zones or {})>1
    self.routeCard:SetHeight(selected and (multipleZones and 202 or 170) or 90)
    self.routeIcon:SetShown(selected); self.routeRim:SetShown(selected)
    self.requirement:SetShown(selected); self.zoneLabel:SetShown(selected)
    self.previous:SetShown(multipleZones); self.next:SetShown(multipleZones); self.zoneCounter:SetShown(multipleZones)
    self.generate:SetShown(selected and not fish)
    self.visibility:SetShown(selected and hasActions and not Routes.progress)
    self.clear:SetShown(selected and hasActions)
    self.selection:ClearAllPoints()
    self.selection:SetPoint("TOPLEFT",selected and 45 or 12,-12)
    self.selection:SetWidth(selected and 202 or 238)
    self.routeSummary:ClearAllPoints()
    self.routeSummary:SetPoint("TOPLEFT",12,selected and -70 or -34)
    self.generate:SetWidth(hasActions and 160 or 242)
    self.clear:SetWidth(fish and 242 or 76)
    self.open:SetWidth(self.visibility:IsShown() and 117 or 242)
    self.open:ClearAllPoints(); self.open:SetPoint("BOTTOMRIGHT",-10,10)
    self.progress:SetShown(Routes.progress~=nil)
    if Routes.progress then
        self.progress:SetValue(Routes.progress)
        self.progress.text:SetText(string.format("Calculating route... %d%%",math.floor(Routes.progress)))
    end
    if self.map and self.map:IsVisible() then Routes:DrawOnCanvas(self.mapOverlay,self.map) end
end
function Window:ShowRoute(route)
    if not self.frame then return end
    if self.object~=route.object then self:SelectObject(route.object) end
    self:SetMap(route.mapID)
end
function Window:CollectLocations()
    self.locations=Routes:Collect(self.object)
    self.displayLocations=self.object.type=="fish" and addon.Fishing:ThinLocations(self.locations) or nil
    self.zones={}
    for id in pairs(self.locations) do self.zones[#self.zones+1]=id end
    table.sort(self.zones,function(a,b)
        local x,y=#self.locations[a],#self.locations[b]
        return x>y or (x==y and a<b)
    end)
    self.zoneIndex=1
end
function Window:SelectObject(object)
    if addon.Fishing then
        if object.type=="fish" then Routes:Clear() end
        addon.Fishing:Select(object.type=="fish" and object or nil)
    end
    self.object=object
    self:CollectLocations()
    self.selection:SetText(objectName(object))
    self:SetMap(self.zones[1] or C_Map.GetBestMapForUnit("player"))
    self:RefreshList(); self:RefreshRoute()
end
function Window:SetMap(id)
    if not id then return end
    self.map:SetMapID(id)
    self:MapChanged()
end
function Window:MapChanged()
    self.mapID=self.map:GetMapID()
    local info=C_Map.GetMapInfo(self.mapID)
    local parent=info and info.parentMapID
    self.parentMap=parent and parent>0 and parent or nil
    self.up:SetEnabled(self.parentMap~=nil)
    self.breadcrumb:SetText((self.parentMap and (mapName(self.parentMap).."  >  ") or "")..mapName(self.mapID))
    for i,id in ipairs(self.zones or {}) do if id==self.mapID then self.zoneIndex=i; break end end
    local count=#((self.locations or {})[self.mapID] or {})
    self.zoneLabel:SetText(self.object and (#self.zones==0 and "No known locations" or (count.." locations in this zone")) or "Select a resource above")
    if self.object and self.object.type=="fish" then
        self.zoneLabel:SetText(count>0 and (count.." reported catch points") or
            (self.locations[self.mapID] and "Fishing zone (no precise pins)" or "No known catches in this zone"))
    end
    local zoneCount=#(self.zones or {})
    self.previous:SetEnabled(zoneCount>1); self.next:SetEnabled(zoneCount>1)
    self.zoneCounter:SetText(zoneCount>0 and (self.zoneIndex.." / "..zoneCount.." zones") or "")
    if Routes.byMap and Routes.object==self.object and info and info.mapType==3 then
        Routes:SelectMap(self.mapID)
    end
    self:DrawMap()
    self:RefreshRoute()
end
function Window:DrawMap()
    local map,overlay=self.map,self.mapOverlay
    if not map or not overlay then return end
    local left,right,top,bottom=Routes:GetViewport(map)
    if not left or right<=left or bottom<=top then return end
    local width,height=overlay:GetWidth(),overlay:GetHeight()
    local state={map:GetMapID(),left,right,top,bottom,width,height,self.locations,Routes.active,GatherLite.db.char.routeVisible,addon.Fishing and addon.Fishing.visible}
    local same=self.lastDraw~=nil
    if same then for i=1,11 do if state[i]~=self.lastDraw[i] then same=false; break end end end
    if same then return end
    self.lastDraw=state
    local count,cells=0,{}
    local fish=self.object and self.object.type=="fish"
    local spacing=10
    local function occupied(x,y)
        local cx,cy=math.floor(x/spacing),math.floor(y/spacing)
        for dx=-1,1 do
            for dy=-1,1 do
                for _,point in ipairs(cells[(cx+dx)..":"..(cy+dy)] or {}) do
                    if (point.x-x)^2+(point.y-y)^2<spacing*spacing then return true end
                end
            end
        end
        local key=cx..":"..cy
        cells[key]=cells[key] or {}
        cells[key][#cells[key]+1]={x=x,y=y}
        return false
    end
    local locations=(fish and self.displayLocations or self.locations) or {}
    if self.object and self.object.type=="fish" and not addon.Fishing.visible then locations={} end
    for sourceMap,points in pairs(locations) do
        for _,point in ipairs(points) do
            local u,v=Routes:Project(point,sourceMap,map:GetMapID())
            if u and v and u>left and u<right and v>top and v<bottom then
                local x,y=(u-left)/(right-left)*width,(v-top)/(bottom-top)*height
                if fish or not occupied(x,y) then
                    count=count+1
                    local pin=self.pins[count]
                    if not pin then
                        pin=CreateFrame("Frame",nil,overlay)
                        pin:SetSize(14,14); pin:EnableMouse(false)
                        pin:SetMouseMotionEnabled(true); pin:SetMouseClickEnabled(false)
                        pin.icon=pin:CreateTexture(nil,"OVERLAY"); pin.icon:SetAllPoints()
                        pin:SetScript("OnEnter",function(p)
                            GameTooltip:SetOwner(p,"ANCHOR_RIGHT"); GameTooltip:SetText(objectName(self.object))
                            GameTooltip:AddLine(string.format("%s: %.1f, %.1f",mapName(p.mapID),p.point.u*100,p.point.v*100),1,1,1)
                            GameTooltip:AddLine(UI.Requirement(self.object),1,.82,.35)
                            if self.object.type=="fish" then
                                GameTooltip:AddLine("Reported catch location, not a guaranteed fish spawn.",.8,.8,.8,true)
                            end
                            GameTooltip:Show()
                        end)
                        pin:SetScript("OnLeave",function() GameTooltip:Hide() end)
                        self.pins[count]=pin
                    end
                    pin.point,pin.mapID=point,sourceMap
                    pin.icon:SetTexture(self.object.icon)
                    pin:ClearAllPoints(); pin:SetPoint("CENTER",overlay,"TOPLEFT",x,-y)
                    -- Keep complete icons inside the map viewport.
                    pin:SetShown(x>=7 and x<=width-7 and y>=7 and y<=height-7)
                end
            end
        end
    end
    for i=count+1,#self.pins do self.pins[i]:Hide() end
    Routes:DrawOnCanvas(overlay,map)
end
function Window:RefreshList()
    local query=string.lower(self.search:GetText() or "")
    self.searchHint:SetShown(query=="")
    local objects={}
    local catalog={}
    for _,object in ipairs(addon.nodeDB) do catalog[#catalog+1]=object end
    for _,object in ipairs(addon.fishDB or {}) do catalog[#catalog+1]=object end
    for _,object in ipairs(catalog) do
        if query=="" or string.find(string.lower(objectName(object)),query,1,true)
            or string.find(object.type,query,1,true) then objects[#objects+1]=object end
    end
    table.sort(objects,function(a,b) return objectName(a)<objectName(b) end)
    for i,object in ipairs(objects) do
        local row=self.rows[i]
        if not row then
            row=CreateFrame("Button",nil,self.list.content)
            row:SetSize(239,36); row:SetPoint("TOPLEFT",0,-(i-1)*38)
            row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight","ADD")
            UI.Background(row,i%2==0 and .10 or .065,.055,.028,.65)
            row.selected=UI.Background(row,.36,.25,.10,.65)
            row.accent=row:CreateTexture(nil,"OVERLAY")
            row.accent:SetColorTexture(.92,.70,.25,1)
            row.accent:SetPoint("TOPLEFT",0,-3); row.accent:SetPoint("BOTTOMLEFT",0,3); row.accent:SetWidth(2)
            row.icon=row:CreateTexture(nil,"ARTWORK"); row.icon:SetSize(26,26); row.icon:SetPoint("LEFT",7,0)
            local rim=row:CreateTexture(nil,"OVERLAY"); rim:SetTexture("Interface\\Buttons\\UI-Quickslot2")
            rim:SetSize(44,44); rim:SetPoint("CENTER",row.icon,"CENTER",0,-1)
            row.label=UI.Text(row,"","GameFontHighlightSmall"); row.label:SetPoint("TOPLEFT",42,-5); row.label:SetWidth(191)
            row.detail=UI.Text(row,"","GameFontDisableSmall")
            row.detail:SetPoint("BOTTOMLEFT",42,5); row.detail:SetWidth(191)
            row:SetScript("OnClick",function(button) self:SelectObject(button.object) end)
            self.rows[i]=row
        end
        row.object=object; row.icon:SetTexture(object.icon); row.label:SetText(objectName(object))
        row.detail:SetText(object.levels and UI.Requirement(object) or resourceKinds[object.type] or object.type)
        row.accent:SetShown(object==self.object)
        row.label:SetTextColor(1,object==self.object and .82 or .95,object==self.object and .45 or .85)
        row.selected:SetShown(object==self.object); row:Show()
    end
    for i=#objects+1,#self.rows do self.rows[i]:Hide() end
    self.list.content:SetHeight(math.max(1,#objects*38))
    self.noResults:SetShown(#objects==0)
    self.resultCount:SetText(#objects.." resources"..(query~="" and " found" or " to discover"))
end
function Window:LayoutMap()
    self.map:ClearAllPoints()
    self.map:SetPoint("TOPLEFT",self.pages[1],"TOPLEFT",0,-36)
    self.map:SetPoint("BOTTOMRIGHT",self.pages[1],"BOTTOMRIGHT",self.sidebar:IsShown() and -280 or 0,0)
    self.navigation:ClearAllPoints()
    self.navigation:SetPoint("TOPLEFT",self.pages[1],"TOPLEFT")
    self.navigation:SetPoint("TOPRIGHT",self.pages[1],"TOPRIGHT",self.sidebar:IsShown() and -280 or 0,0)
    self.map:OnFrameSizeChanged()
    self:DrawMap()
end
function Window:CreateMap(page)
    self.zones,self.rows,self.pins={},{},{}
    self.sidebar=CreateFrame("Frame",nil,page)
    local sidebar=self.sidebar
    sidebar:SetPoint("TOPRIGHT"); sidebar:SetPoint("BOTTOMRIGHT"); sidebar:SetWidth(276)
    UI.Background(sidebar,.045,.035,.024,.98); UI.Border(sidebar)
    local header=CreateFrame("Frame",nil,sidebar)
    header:SetPoint("TOPLEFT",1,0); header:SetPoint("TOPRIGHT",-1,0); header:SetHeight(36)
    UI.HeaderBackground(header)
    self.search=CreateFrame("EditBox",nil,header,"InputBoxTemplate")
    self.search:SetSize(220,24); self.search:SetPoint("LEFT",13,0)
    self.search:SetAutoFocus(false); self.search:SetMaxLetters(80)
    self.search:SetScript("OnEscapePressed",function(edit) edit:ClearFocus() end)
    self.searchHint=UI.Text(self.search,"Search resources","GameFontDisableSmall")
    self.searchHint:SetPoint("LEFT",4,0)
    local resetSearch=UI.Button(header,"x",24,function()
        self.search:SetText(""); self.search:ClearFocus()
    end)
    resetSearch:SetPoint("RIGHT",-7,0)
    self.resultCount=UI.Text(sidebar,"","GameFontDisableSmall")
    self.resultCount:SetPoint("TOPLEFT",14,-45)
    self.list=UI.Scroll(sidebar,"GatherLiteResourceScroll",239)
    self.list:SetPoint("TOPLEFT",10,-64); self.list:SetPoint("BOTTOMRIGHT",-28,106)
    self.noResults=UI.Text(sidebar,"No matching resources.","GameFontDisableSmall")
    self.noResults:SetPoint("TOPLEFT",14,-72)
    self.search:SetScript("OnTextChanged",function() self.list:SetVerticalScroll(0); self:RefreshList() end)

    local card=CreateFrame("Frame",nil,sidebar)
    self.routeCard=card
    card:SetPoint("BOTTOMLEFT",7,8); card:SetPoint("BOTTOMRIGHT",-7,8); card:SetHeight(90)
    self.list:ClearAllPoints()
    self.list:SetPoint("TOPLEFT",sidebar,"TOPLEFT",10,-64)
    self.list:SetPoint("BOTTOMRIGHT",card,"TOPRIGHT",-21,8)
    UI.Background(card,.105,.073,.035,.95); UI.Border(card)
    self.cardTitle=UI.Text(card,"FARMING ROUTE","GameFontNormalSmall")
    self.cardTitle:SetPoint("TOPLEFT",12,-12); self.cardTitle:Hide()
    self.routeIcon=card:CreateTexture(nil,"ARTWORK")
    self.routeIcon:SetSize(24,24); self.routeIcon:SetPoint("TOPLEFT",12,-12)
    local rim=card:CreateTexture(nil,"OVERLAY"); self.routeRim=rim
    rim:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    rim:SetSize(40,40); rim:SetPoint("CENTER",self.routeIcon,"CENTER",0,-1)
    self.selection=UI.Text(card,"Choose a resource","GameFontNormal")
    self.selection:SetPoint("TOPLEFT",55,-36); self.selection:SetWidth(192)
    self.requirement=UI.Text(card,"","GameFontNormalSmall")
    self.requirement:SetPoint("TOPLEFT",45,-32); self.requirement:SetWidth(192)
    self.zoneLabel=UI.Text(card,"","GameFontDisableSmall")
    self.zoneLabel:SetPoint("TOPLEFT",12,-52); self.zoneLabel:SetWidth(192)
    self.routeSummary=UI.Text(card,"","GameFontHighlightSmall")
    self.routeSummary:SetPoint("TOPLEFT",12,-96); self.routeSummary:SetWidth(238)
    local function step(delta)
        if #self.zones==0 then return end
        self.zoneIndex=(self.zoneIndex-1+delta)%#self.zones+1; self:SetMap(self.zones[self.zoneIndex])
        self:RefreshRoute()
    end
    self.previous=UI.Button(card,"<",28,function() step(-1) end); self.previous:SetPoint("BOTTOMLEFT",10,74)
    self.next=UI.Button(card,">",28,function() step(1) end); self.next:SetPoint("BOTTOMRIGHT",-10,74)
    self.zoneCounter=UI.Text(card,"","GameFontHighlightSmall"); self.zoneCounter:SetPoint("BOTTOM",0,81)
    self.generate=UI.Button(card,"Generate zone routes",242,function()
        if self.object then GatherLite.db.char.routeVisible=true; Routes:Generate(self.object) end
    end)
    self.generate:SetPoint("BOTTOMLEFT",10,42)
    self.visibility=UI.Button(card,"Hide route",117,function()
        if self.object and self.object.type=="fish" then
            addon.Fishing.visible=not addon.Fishing.visible
            addon.Fishing:Refresh(); self:DrawMap()
        else
            GatherLite.db.char.routeVisible=GatherLite.db.char.routeVisible==false
        end
        self:RefreshRoute()
    end)
    self.visibility:SetPoint("BOTTOMLEFT",10,10)
    self.clear=UI.Button(card,"Clear",76,function()
        if self.object and self.object.type=="fish" then
            addon.Fishing:Select(nil)
            self.object=nil; self.locations={}; self.zones={}
            self.selection:SetText("Choose a resource")
            self:MapChanged(); self:RefreshList()
        end
        Routes:Clear()
    end); self.clear:SetPoint("BOTTOMRIGHT",-10,42)
    self.open=UI.Button(card,"Open world map",242,function()
        self.frame:Hide(); ShowUIPanel(WorldMapFrame); WorldMapFrame:SetMapID(self.map:GetMapID())
    end)
    self.open:SetPoint("BOTTOMLEFT",10,10)

    self.map=CreateFrame("Frame","GatherLiteMapCanvas",page,"GatherLiteMapCanvasTemplate")
    local map=self.map
    map:SetFrameStrata(self.frame:GetFrameStrata())
    map.ScrollContainer:ClearAllPoints(); map.ScrollContainer:SetAllPoints()
    map:SetShouldNavigateOnClick(true); map:SetShouldZoomInOnClick(false)
    map:SetShouldPanOnClick(false); map:SetShouldZoomInstantly(true)
    addon.MapZoom.Attach(map)
    self.mapOverlay=CreateFrame("Frame",nil,map.ScrollContainer)
    self.mapOverlay:SetAllPoints(); self.mapOverlay:EnableMouse(false)
    self.mapOverlay:SetFrameLevel(map.ScrollContainer:GetFrameLevel()+100)
    self.mapOverlay.lines={}
    self:LayoutMap()
    map:SetMapID(C_Map.GetBestMapForUnit("player") or 947)
    local levels=map:GetPinFrameLevelsManager()
    levels:AddFrameLevel("PIN_FRAME_LEVEL_MAP_EXPLORATION")
    levels:AddFrameLevel("PIN_FRAME_LEVEL_MAP_HIGHLIGHT")
    local exploration = CreateFromMixins(MapExplorationDataProviderMixin)
    map:AddDataProvider(exploration)
    addon.MapReveal.Attach(exploration)
    if MapHighlightDataProviderMixin then map:AddDataProvider(CreateFromMixins(MapHighlightDataProviderMixin)) end
    hooksecurefunc(map,"OnMapChanged",function() self:MapChanged() end)
    local elapsedTotal=0
    map:HookScript("OnUpdate",function(_,elapsed)
        elapsedTotal=elapsedTotal+elapsed
        if elapsedTotal>=.03 then elapsedTotal=0; self:DrawMap() end
    end)
    map:Show()
end

function Window:CreateNavigation(page)
    self.navigation=CreateFrame("Frame",nil,page)
    local nav=self.navigation
    nav:SetHeight(36)
    UI.HeaderBackground(nav)
    self.up=UI.Button(nav,"<",28,function() if self.parentMap then self:SetMap(self.parentMap) end end)
    self.up:SetPoint("LEFT",5,0)
    self.breadcrumb=UI.Text(nav,"","GameFontNormal")
    self.breadcrumb:SetPoint("LEFT",40,0); self.breadcrumb:SetWidth(535)
    local minus=UI.Button(nav,"-",28,function() addon.MapZoom.Step(self.map,-1) end); minus:SetPoint("RIGHT",-102,0)
    local plus=UI.Button(nav,"+",28,function() addon.MapZoom.Step(self.map,1) end); plus:SetPoint("RIGHT",-70,0)
    local toggle=UI.Button(nav,"Find",58,function()
        self.sidebar:SetShown(not self.sidebar:IsShown()); self:LayoutMap()
    end)
    toggle:SetPoint("RIGHT",-5,0)
end

function Window:CreateSettings(page)
    self.settingsPanels,self.settingsButtons={},{}
    UI.Parchment(page)
    local rail=CreateFrame("Frame",nil,page)
    rail:SetPoint("TOPLEFT"); rail:SetPoint("BOTTOMLEFT"); rail:SetWidth(184)
    UI.Background(rail,.19,.125,.065,1); UI.Border(rail)
    UI.Text(rail,"PREFERENCES","GameFontNormalSmall"):SetPoint("TOPLEFT",12,-16)
    local groups={"general","worldmap","minimap","tracking","debugging"}
    local labels={"General","World map","Minimap","Resources","Debugging"}
    local icons={"Interface\\Icons\\inv_misc_spyglass_02","Interface\\Icons\\INV_Misc_Map_01",
        "compass","Interface\\Icons\\INV_Ore_Copper_01","Interface\\Icons\\Trade_Engineering"}
    local descriptions={
        "Choose where GatherLite displays gathering locations.",
        "Adjust resource markers and tooltips on the game world map.",
        "Tune nearby markers, tracking distance and minimap appearance.",
        "Choose which resources appear in your normal gathering overlays.",
        "Diagnostic controls for investigating addon issues.",
    }
    self.settingsTitle=UI.InkText(page,"","GameFontNormalLarge")
    self.settingsTitle:SetPoint("TOPLEFT",204,-18)
    self.settingsTitle:SetTextColor(.25,.14,.055)
    self.settingsDescription=UI.InkText(page,"","GameFontHighlightSmall")
    self.settingsDescription:SetPoint("TOPLEFT",204,-44)
    self.settingsDescription:SetWidth(884)
    self.settingsDescription:SetTextColor(.36,.25,.13)
    for i,key in ipairs(groups) do
        local group=addon.SettingsOptions.args[key]
        local button=UI.NavButton(rail,labels[i],168,function()
            if not self.settingsPanels[key] then self.settingsPanels[key]=UI.SettingsGroup(page,group,"GatherLiteSettings_"..key) end
            for id,panel in pairs(self.settingsPanels) do panel:SetShown(id==key) end
            for id,tab in pairs(self.settingsButtons) do tab:Select(id==key) end
            self.settingsTitle:SetText(labels[i]); self.settingsDescription:SetText(descriptions[i])
            self:RefreshSettings()
        end,icons[i])
        button:SetHeight(42)
        button:SetPoint("TOPLEFT",8,-42-(i-1)*48)
        self.settingsButtons[key]=button
        if i==1 then self.settingsFirst=button end
    end
    local note=UI.Text(rail,"Changes are saved automatically.","GameFontDisableSmall")
    note:SetPoint("BOTTOMLEFT",12,16); note:SetWidth(160)
end
function Window:SelectTab(index)
    self.selectedTab=index
    for i,page in ipairs(self.pages) do page:SetShown(i==index) end
    PanelTemplates_SetTab(self.frame,index)
    if index==2 and not next(self.settingsPanels) then self.settingsFirst:GetScript("OnClick")() end
    self.status:SetShown(index==1)
    if self.footer then
        self.footer:SetText(index==1 and "Scroll to zoom  |  Drag to pan  |  Click a zone to enter  |  Right-click to go back"
            or "Preferences save automatically. The predefined database is shared; map preferences are per character.")
    end
    if index==1 then self:LayoutMap() end
    self:RefreshSettings()
end
function Window:Create()
    -- A frame can exist even if an earlier creation step raised an error.
    if self.frame then return self.ready end
    local frame=CreateFrame("Frame","GatherLiteWindow",UIParent,"ButtonFrameTemplate")
    self.frame=frame
    frame:Hide(); frame:SetSize(1160,710)
    frame:SetScale(math.min(1,(UIParent:GetWidth()-40)/1160,(UIParent:GetHeight()-70)/740))
    frame:SetClampRectInsets(0,0,0,-32)
    frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetToplevel(true); frame:EnableMouse(true)
    frame:SetTitle("GatherLite"); frame:SetPortraitToAsset("Interface\\Icons\\inv_misc_spyglass_02")
    ButtonFrameTemplate_HideButtonBar(frame)
    frame.Inset:ClearAllPoints(); frame.Inset:SetPoint("TOPLEFT",4,-66); frame.Inset:SetPoint("BOTTOMRIGHT",-6,27)
    frame:SetMovable(true); frame:SetClampedToScreen(true); frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart",function() frame:StartMoving() end)
    frame:SetScript("OnDragStop",function() frame:StopMovingOrSizing() end)
    frame.CloseButton:SetScript("OnClick",function() frame:Hide() end)
    table.insert(UISpecialFrames,"GatherLiteWindow")
    self.pages,self.tabs={},{}
    for i,title in ipairs({"World Map","Settings"}) do
        local page=CreateFrame("Frame",nil,frame)
        page:SetPoint("TOPLEFT",7,-68); page:SetPoint("BOTTOMRIGHT",-9,29)
        self.pages[i]=page
        local tab=CreateFrame("Button","GatherLiteWindowTab"..i,frame,"PanelTabButtonTemplate")
        tab:SetID(i); tab:SetText(title)
        PanelTemplates_TabResize(tab,24)
        tab:SetScript("OnClick",function() self:SelectTab(i) end)
        if i==1 then tab:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",12,7)
        else tab:SetPoint("TOPLEFT",self.tabs[i-1],"TOPRIGHT",-10,0) end
        self.tabs[i]=tab
    end
    PanelTemplates_SetNumTabs(frame,#self.tabs)
    self.status=UI.Text(frame,"","GameFontHighlightSmall")
    self.status:SetPoint("TOPLEFT",80,-44); self.status:SetWidth(1042)
    self:CreateNavigation(self.pages[1])
    self:CreateMap(self.pages[1])
    self.progress=CreateFrame("StatusBar",nil,self.pages[1])
    self.progress:SetSize(420,24); self.progress:SetPoint("BOTTOM",self.map,"BOTTOM",0,28)
    self.progress:SetFrameLevel(self.mapOverlay:GetFrameLevel()+5)
    self.progress:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.progress:SetStatusBarColor(.64,.44,.12)
    self.progress:SetMinMaxValues(0,100)
    UI.Background(self.progress,.035,.025,.01,.95); UI.Border(self.progress)
    self.progress.text=UI.Text(self.progress,"","GameFontHighlightSmall"); self.progress.text:SetPoint("CENTER")
    self.progress:Hide()
    self:CreateSettings(self.pages[2])
    self.footer=UI.Text(frame,"","GameFontDisableSmall")
    self.footer:SetPoint("BOTTOMLEFT",16,10)
    self:SelectTab(1); self:MapChanged(); self:RefreshList(); self:RefreshRoute()
    GatherLite:On("settings:update",function()
        if self.frame:IsShown() and self.object then self:CollectLocations(); self:MapChanged() end
        self:RefreshSettings()
    end)
    self.ready=true
    return true
end
function Window:Show()
    if not GatherLite:IsLoaded() then return end
    if not self:Create() then return end
    self.frame:Show(); self:SelectTab(1)
    local selectedRoute=Routes.active
    if not self.object and addon.Fishing then self.object=addon.Fishing.object end
    if self.object then self:SelectObject(self.object) end
    if selectedRoute then self:ShowRoute(selectedRoute) end
    self:RefreshRoute()
end
