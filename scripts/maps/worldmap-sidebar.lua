local _, addon = ...
local UI, Routes = addon.UI, addon.Routes
local Sidebar = { rows = {} }
GatherLite.modules.worldMapSidebar = Sidebar

local WIDTH, ROW_HEIGHT = 250, 25
local MIN_PANE_WIDTH, MIN_VIEW_WIDTH, MIN_VIEW_HEIGHT = 190, 250, 200
local LEFT_PADDING = 4
local CATEGORY_PADDING = 8
local function T(key, ...) return GatherLite:translate(key, ...) end

local function stitchedMap()
    local api = OpenMapAPI
    return api and api.major == 1 and api.IsStitched() and api
end

local function viewedZone(map)
    local mapID = map:GetMapID()
    local openMap = stitchedMap()
    if openMap then
        local u, v, zoom = openMap.GetView()
        -- Use the zone under the view even when OpenMap's host map is pinned.
        mapID = zoom and zoom >= 8 and openMap.MapAt(u, v) or nil
    end
    local info = mapID and C_Map.GetMapInfo(mapID)
    if info and info.mapType == 3 then return mapID end
end

function Sidebar:GetSelection()
    if self.selection then return self.selection end
    local object = Routes.object
    if object then
        return object.objects or { object }
    end
    return {}
end

function Sidebar:RefreshZones(jumpToRecommended)
    local fish = addon.Fishing.object
    local selection = fish or self.selection or Routes.object
    local view = viewedZone(self.map)
    local changed = self.zonesDirty or self.zoneSelection ~= selection
    if changed then
        self.zoneSelection, self.zonesDirty = selection, false
        self.zoneObject = fish or Routes.object
        if not fish and self.selection then self.zoneObject = Routes:Combine(self.selection) end
        self.locations = self.zoneObject and Routes:Collect(self.zoneObject) or {}
        self.zoneView = nil
    end
    -- A route built for one zone cannot establish a recommendation across zones.
    local completed = not Routes.onlyMapID and Routes.object == self.zoneObject and Routes.byMap or nil
    if changed or completed ~= self.rankedRoutes then
        local previous = not changed and self.zones[self.zoneIndex]
        self.rankedRoutes = completed
        self.zones = fish and Routes:SortedZones(self.locations) or Routes:RecommendedZones(self.locations, completed)
        self.zoneIndex = 1
        for i, id in ipairs(self.zones) do
            if id == previous then self.zoneIndex = i; break end
        end
    end
    if jumpToRecommended then
        self.zoneIndex, self.zoneView = 1, view
        if self.zones[1] ~= view or self.glidingUntil then self:FocusZone(self.zones[1]) end
    elseif self.glidingUntil then
        -- Keep the requested HUD zone as OpenMap glides past other zones.
        self.zoneView = view
        if GetTime() >= self.glidingUntil then self.glidingUntil = nil end
    elseif self.zoneView ~= view then
        self.zoneView = view
        for i, id in ipairs(self.zones) do
            if id == view then self.zoneIndex = i; break end
        end
    end
    local id = self.zones[self.zoneIndex]
    self.hud:SetShown(self.expanded and self.zoneObject ~= nil)
    local info = id and C_Map.GetMapInfo(id)
    self.zoneName:SetText(info and info.name or T("window.zone.no_locations"))
    self.zoneCounter:SetText(id and T("window.worldmap.zone_count", self.zoneIndex, #self.zones) or "")
    local canBrowse = #self.zones > 1 and not InCombatLockdown()
    self.previous:SetEnabled(canBrowse)
    self.next:SetEnabled(canBrowse)
end

function Sidebar:FocusZone(mapID)
    if not mapID or InCombatLockdown() then return end
    local api = stitchedMap()
    if api and api.ShowWorld then
        local u, v = api.WorldFromMap(mapID, .5, .5)
        local _, _, zoom = api.GetView()
        local minZoom = addon.OpenMap:GetMinPinZoom()
        if u and api.ShowWorld(u, v, math.max(minZoom, zoom or minZoom)) then
            self.glidingUntil = GetTime() + .5
            return
        end
    end
    self.glidingUntil = nil
    if C_Map.OpenWorldMap then C_Map.OpenWorldMap(mapID) else self.map:SetMapID(mapID) end
end

function Sidebar:ToggleResource(object)
    local added
    if object.type == "fish" then
        local fishing = addon.Fishing
        added = object ~= fishing.object
        fishing:Select(added and object or nil)
    else
        if addon.Fishing.object then addon.Fishing:Select(nil) end
        local selected, found = {}, false
        for _, item in ipairs(self:GetSelection()) do
            if item == object then found = true else selected[#selected + 1] = item end
        end
        added = not found
        if added then selected[#selected + 1] = object end
        self.selection = selected
    end
    self:RefreshZones(added)
    self:RefreshActions()
end

function Sidebar:RefreshList()
    local query = (self.search:GetText() or ""):lower()
    self.searchHint:SetShown(query == "")
    local objects = UI.ResourceList(query, self.resourceCategory)
    for i, object in ipairs(objects) do
        local row = self.rows[i]
        if not row then
            row = CreateFrame("Button", nil, self.list.content)
            row:SetHeight(ROW_HEIGHT)
            row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_HEIGHT)
            row:SetPoint("TOPRIGHT", 0, -(i - 1) * ROW_HEIGHT)
            row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
            UI.Background(row, .16, .11, .06, i % 2 == 0 and .55 or .28)
            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetSize(18, 18)
            row.icon:SetPoint("LEFT", 5, 0)
            row.label = UI.Text(row, "", "GameFontHighlightSmall")
            row.label:SetPoint("LEFT", 29, 0)
            row.label:SetPoint("RIGHT", -25, 0)
            row.label:SetWordWrap(false)
            row.check = CreateFrame("CheckButton", nil, row, "CheckboxWithLabelTemplate")
            row.check:SetSize(21, 21)
            row.check:SetPoint("RIGHT", -1, 0)
            row.check:EnableMouse(false)
            row:SetScript("OnClick", function(button) self:ToggleResource(button.object) end)
            row:SetScript("OnEnter", function(button)
                GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
                GameTooltip:SetText(UI.ResourceName(button.object))
                GameTooltip:AddLine(UI.Requirement(button.object), 1, .82, .35)
                GameTooltip:Show()
            end)
            local function hideTooltip(button)
                if GameTooltip:IsOwned(button) then GameTooltip:Hide() end
            end
            row:SetScript("OnLeave", hideTooltip)
            row:SetScript("OnHide", hideTooltip)
            self.rows[i] = row
        end
        row.object = object
        row.icon:SetTexture(object.icon)
        row.label:SetText(UI.ResourceName(object))
        row:Show()
    end
    for i = #objects + 1, #self.rows do self.rows[i]:Hide() end
    self.rowCount = #objects
    self.list.content:SetHeight(math.max(1, #objects * ROW_HEIGHT))
    self.empty:SetShown(#objects == 0)
end

function Sidebar:RefreshActions()
    local selected, checked = self:GetSelection(), {}
    for _, object in ipairs(selected) do checked[object] = true end
    local fish = addon.Fishing.object
    for i = 1, self.rowCount do
        local row = self.rows[i]
        row.check:SetChecked(checked[row.object] or row.object == fish)
    end
    local busy = Routes.progress ~= nil
    local hasRoute = Routes.active ~= nil or Routes.bestMapID ~= nil
    self.generate:SetEnabled(not fish and self.zones[self.zoneIndex] ~= nil and not busy)
    self.generate:SetText(busy and T("window.worldmap.progress", math.floor(Routes.progress))
        or T("window.action.generate_zone"))
    self.clear:SetEnabled(busy or Routes.object ~= nil or fish ~= nil or #selected > 0)
    self.clear:SetText(T(busy and "window.action.cancel" or "window.action.clear"))
    self.visibility:SetEnabled(not busy and (hasRoute or fish ~= nil))
    local visibilityKey
    if fish then
        visibilityKey = addon.Fishing.visible and "window.action.hide_catches" or "window.action.show_catches"
    else
        visibilityKey = GatherLite.db.char.routeVisible == false and "window.action.show_route" or "window.action.hide_route"
    end
    self.visibility:SetText(T(visibilityKey))
end

function Sidebar:RefreshProgress()
    local bar, progress = self.progress, Routes.progress
    if not bar then return end
    bar:SetShown(progress ~= nil)
    if progress == nil then return end
    bar:SetValue(progress)
    local percent = math.floor(progress)
    if self.progressPercent ~= percent then
        self.progressPercent = percent
        bar.text:SetText(T("window.worldmap.progress", percent))
    end
end

local function leftAnchors(viewport)
    local anchors, hasRight = {}, false
    for i = 1, viewport:GetNumPoints() do
        local point, relative, relativePoint, x, y = viewport:GetPoint(i)
        if point:find("LEFT", 1, true) then
            anchors[#anchors + 1] = { point, relative or viewport:GetParent(), relativePoint, x or 0, y or 0 }
        elseif point:find("RIGHT", 1, true) then
            hasRight = true
        end
    end
    if hasRight and #anchors > 0 then return anchors end
end

local function getAnchor(frame, point)
    for i = 1, frame:GetNumPoints() do
        local anchor, relative, relativePoint, x, y = frame:GetPoint(i)
        if anchor == point then return relative, relativePoint, x, y end
    end
end

local function fitChromeLeft(frame, point, viewport, relativePoint, x, y, inset, combat)
    if addon.API.IsSecret(x) or addon.API.IsSecret(y) or (combat and frame:IsProtected()) then return end
    if (x or 0) ~= -inset then frame:SetPoint(point, viewport, relativePoint, -inset, y or 0) end
end

function Sidebar:FitLeatrixChrome(combat)
    if not self.leatrix then return end
    local map, viewport = self.map, self.map.ScrollContainer
    local close = map.BorderFrame and map.BorderFrame.CloseButton
    if not close then return end
    local title = getAnchor(close, "RIGHT")
    if not title or title:GetParent() ~= map then return end
    local left, leftPoint, x, y = getAnchor(title, "BOTTOMLEFT")
    local right, rightPoint = getAnchor(title, "BOTTOMRIGHT")
    -- Leatrix's simple frame hangs its border off this title bar. Verify the
    -- anchor chain before extending it over the pane.
    if left ~= viewport or leftPoint ~= "TOPLEFT" or right ~= viewport or rightPoint ~= "TOPRIGHT" then return end
    fitChromeLeft(title, "BOTTOMLEFT", viewport, "TOPLEFT", x, y, self.inset, combat)

    if self.leatrixTitle ~= title then
        self.leatrixTitle, self.leatrixFooter = title, nil
        for _, child in ipairs({ map:GetChildren() }) do
            -- Its optional coordinates footer has a themed background and texture.
            if child.back and child.t and (getAnchor(child, "TOPLEFT") == viewport
                or getAnchor(child, "BOTTOMLEFT") == viewport) then
                self.leatrixFooter = child
                break
            end
        end
    end
    local footer = self.leatrixFooter
    if footer then
        local relative, point, offset, vertical = getAnchor(footer, "TOPLEFT")
        if relative == viewport and point == "BOTTOMLEFT" then
            fitChromeLeft(footer, "TOPLEFT", viewport, "BOTTOMLEFT", offset, vertical, self.inset, combat)
        end
    end
end

function Sidebar:FillMapArt(viewport)
    if not self.expanded or self.leatrixTitle or stitchedMap() or not viewport.mapID then return end
    local canvas = self.map:GetCanvas()
    local width, height = canvas:GetWidth(), canvas:GetHeight()
    if width <= 0 or height <= 0 then return end
    local cover = math.max(viewport:GetWidth() / width, viewport:GetHeight() / height)
    if viewport:GetCanvasScale() < cover then
        viewport:InstantPanAndZoom(cover, viewport:GetNormalizedHorizontalScroll(), viewport:GetNormalizedVerticalScroll(), true)
    end
end

function Sidebar:UpdateDock()
    local viewport = self.map.ScrollContainer
    local width = math.min(WIDTH, math.floor(viewport:GetWidth() + self.inset - MIN_VIEW_WIDTH - LEFT_PADDING))
    local fits = width >= MIN_PANE_WIDTH and viewport:GetHeight() >= MIN_VIEW_HEIGHT
    local expanded = fits and GatherLite.db.char.worldMapSidebarCollapsed == false
    local inset = expanded and width + LEFT_PADDING or 0
    if inset > 0 and self.inset == 0 then
        self.anchors = leftAnchors(viewport)
        if not self.anchors then expanded, inset = false, 0 end
    end
    local toggled = expanded ~= self.expanded
    self.expanded = expanded
    if inset ~= self.inset then
        self.inset = inset
        for _, anchor in ipairs(self.anchors) do
            viewport:SetPoint(anchor[1], anchor[2], anchor[3], anchor[4] + inset, anchor[5])
        end
        if inset == 0 then self.anchors = nil end
        if expanded then
            self.panel:SetWidth(width)
            self.categoryBar:ResizeButtons(width - 2 * CATEGORY_PADDING)
            self.list.content:SetWidth(width - 36)
        end
        -- Refit only the canvas. Leatrix uses the window callback to reset its position.
        viewport:OnCanvasSizeChanged()
        self.chromeDirty = true
    end
    if toggled then
        self.panel:SetShown(expanded)
        if not expanded then self.search:ClearFocus() end
    end
end

function Sidebar:Update()
    if not IsMouseButtonDown("LeftButton") then
        local combat = InCombatLockdown()
        if self.layoutDirty and not combat then
            self.layoutDirty = false
            self:UpdateDock()
        end
        -- Leatrix can reset its cosmetic anchors on show even during combat.
        if self.chromeDirty then
            self.chromeDirty = false
            self:FitLeatrixChrome(combat)
        end
        if self.artDirty and not combat then
            self.artDirty = false
            self:FillMapArt(self.map.ScrollContainer)
        end
    end
    self:RefreshZones()
    if not self.expanded then return end
    if self.dirty then self:RefreshList(); self.dirty = false end
    self:RefreshActions()
end

function Sidebar:Toggle()
    if InCombatLockdown() then return end
    GatherLite.db.char.worldMapSidebarCollapsed = self.expanded
    self.layoutDirty = true
    self:Update()
end

function Sidebar.setup()
    local self, map = Sidebar, WorldMapFrame
    self.map, self.dirty, self.inset, self.expanded = map, true, 0, false
    self.zones, self.zoneIndex, self.zonesDirty, self.rowCount = {}, 1, true, 0
    local viewport = map.ScrollContainer
    self.leatrix = C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Leatrix_Maps")
    self.layoutDirty, self.chromeDirty = true, self.leatrix
    viewport:HookScript("OnSizeChanged", function() self.layoutDirty = true end)
    if viewport.CreateZoomLevels and viewport.InstantPanAndZoom then
        hooksecurefunc(viewport, "CreateZoomLevels", function() self.artDirty = true end)
    end
    if self.leatrix then
        local function refreshChrome() self.chromeDirty = true end
        local function restoreOpenChrome()
            -- Reuse the docked inset before the map is drawn. Leatrix may also
            -- refresh its pixel edges on the next frame.
            if self.inset > 0 and map:IsShown() and not IsMouseButtonDown("LeftButton") then
                self:FitLeatrixChrome(InCombatLockdown())
            end
            refreshChrome()
        end
        map:HookScript("OnShow", restoreOpenChrome)
        if map.SynchronizeDisplayState then
            hooksecurefunc(map, "SynchronizeDisplayState", restoreOpenChrome)
        end
        hooksecurefunc(map, "OnFrameSizeChanged", refreshChrome)
        local questLog = map.QuestLog
        if questLog then
            questLog:HookScript("OnShow", refreshChrome)
            questLog:HookScript("OnHide", refreshChrome)
        end
    end
    local panel = CreateFrame("Frame", nil, map)
    self.panel = panel
    panel:SetPoint("TOPRIGHT", viewport, "TOPLEFT", 0, 0)
    panel:SetPoint("BOTTOMRIGHT", viewport, "BOTTOMLEFT", 0, 0)
    panel:SetWidth(WIDTH)
    panel:SetFrameLevel(math.min(viewport:GetFrameLevel() + 9480, 9780))
    panel:EnableMouse(true)
    panel:EnableMouseWheel(true)
    panel:Hide()
    UI.Background(panel, .045, .033, .022, .98)
    UI.Border(panel)
    self.search = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    self.search:SetHeight(22)
    self.search:SetPoint("TOPLEFT", 15, -10)
    self.search:SetPoint("TOPRIGHT", -13, -10)
    self.search:SetAutoFocus(false)
    self.search:SetMaxLetters(80)
    self.search:SetScript("OnEscapePressed", function(edit) edit:ClearFocus() end)
    self.search:SetScript("OnEnterPressed", function(edit) edit:ClearFocus() end)
    self.searchHint = UI.Text(self.search, T("window.search"), "GameFontDisableSmall")
    self.searchHint:SetPoint("LEFT", 3, 0)
    local function refreshFilters()
        self.list:SetVerticalScroll(0)
        self:RefreshList()
        self:RefreshActions()
    end
    self.resourceCategory = "all"
    self.categoryBar, self.categoryButtons = UI.ResourceCategories(panel, WIDTH - 2 * CATEGORY_PADDING, 32, 6, function(key)
        self.resourceCategory = key
        refreshFilters()
    end)
    self.categoryBar:SetPoint("TOPLEFT", CATEGORY_PADDING, -38)
    self.list = UI.Scroll(panel, "GatherLiteWorldMapResources", WIDTH - 36)
    self.list:SetPoint("TOPLEFT", 8, -77)
    self.list:SetPoint("BOTTOMRIGHT", -28, 65)
    self.empty = UI.Text(panel, T("window.results.none"), "GameFontDisableSmall")
    self.empty:SetPoint("TOPLEFT", 10, -84)
    self.search:SetScript("OnTextChanged", refreshFilters)

    self.generate = UI.Button(panel, T("window.action.generate_zone"), WIDTH - 20, function()
        self:RefreshZones()
        local id, object = self.zones[self.zoneIndex], self.zoneObject
        if not id or not object or object.type == "fish" or Routes.worker then return end
        if viewedZone(map) ~= id then self:FocusZone(id) end
        GatherLite.db.char.routeVisible = true
        if Routes.object ~= object or Routes.onlyMapID ~= id or not Routes.active or self.routeDirty then
            self.routeDirty = false
            Routes:Generate(object, id, id)
        end
        self:RefreshActions()
    end)
    self.generate:SetPoint("BOTTOMLEFT", 10, 35)
    self.generate:SetPoint("BOTTOMRIGHT", -10, 35)
    self.generate:SetScript("OnEnter", function(button)
        local id = self.zones[self.zoneIndex]
        if id and Routes.object == self.zoneObject and Routes.onlyMapID == id and not Routes.worker and not Routes.active then
            GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
            GameTooltip:AddLine(Routes.status, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    self.generate:SetScript("OnLeave", function(button)
        if GameTooltip:IsOwned(button) then GameTooltip:Hide() end
    end)
    self.clear = UI.Button(panel, T("window.action.clear"), 78, function()
        if Routes.progress then
            Routes:Clear()
        elseif addon.Fishing.object then
            addon.Fishing:Select(nil)
        else
            Routes:Clear()
            self.selection = nil
        end
        self:RefreshZones()
        self:RefreshActions()
    end)
    self.clear:SetPoint("BOTTOMRIGHT", -10, 7)
    self.visibility = UI.Button(panel, T("window.action.hide_route"), WIDTH - 100, function()
        local fishing = addon.Fishing
        if fishing.object then
            fishing.visible = not fishing.visible
            fishing:Refresh()
        else
            GatherLite.db.char.routeVisible = GatherLite.db.char.routeVisible == false
        end
        Routes:Notify()
        self:RefreshActions()
    end)
    self.visibility:SetPoint("BOTTOMLEFT", 10, 7)
    self.visibility:SetPoint("BOTTOMRIGHT", self.clear, "BOTTOMLEFT", -2, 0)

    local hud = CreateFrame("Frame", nil, map)
    self.hud = hud
    hud:SetSize(218, 45)
    hud:SetPoint("BOTTOMLEFT", viewport, "BOTTOMLEFT", 0, 0)
    hud:SetFrameLevel(panel:GetFrameLevel())
    UI.Background(hud, .045, .033, .022, .94)
    UI.Border(hud)
    hud:Hide()
    local function step(delta)
        if #self.zones < 2 or InCombatLockdown() then return end
        self.zoneIndex = (self.zoneIndex - 1 + delta) % #self.zones + 1
        self:FocusZone(self.zones[self.zoneIndex])
        self:RefreshZones()
    end
    self.previous = UI.Button(hud, "<", 28, function() step(-1) end)
    self.previous:SetPoint("LEFT", 5, 0)
    self.next = UI.Button(hud, ">", 28, function() step(1) end)
    self.next:SetPoint("RIGHT", -5, 0)
    local jump = CreateFrame("Button", nil, hud)
    jump:SetPoint("TOPLEFT", 37, -2)
    jump:SetPoint("BOTTOMRIGHT", -37, 2)
    jump:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    jump:SetScript("OnClick", function() self:FocusZone(self.zones[self.zoneIndex]) end)
    self.zoneName = UI.Text(jump, "", "GameFontNormalSmall")
    self.zoneName:SetPoint("TOPLEFT", 0, -5)
    self.zoneName:SetPoint("TOPRIGHT", 0, -5)
    self.zoneName:SetJustifyH("CENTER")
    self.zoneName:SetWordWrap(false)
    self.zoneCounter = UI.Text(jump, "", "GameFontHighlightSmall")
    self.zoneCounter:SetPoint("BOTTOM", 0, 5)

    local progress = CreateFrame("StatusBar", nil, map)
    self.progress = progress
    progress:SetSize(218, 24)
    progress:SetPoint("BOTTOMLEFT", hud, "TOPLEFT", 0, 6)
    progress:SetFrameLevel(hud:GetFrameLevel() + 1)
    progress:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    progress:SetStatusBarColor(.64, .44, .12)
    progress:SetMinMaxValues(0, 100)
    UI.Background(progress, .035, .025, .01, .95)
    UI.Border(progress)
    progress.text = UI.Text(progress, "", "GameFontHighlightSmall")
    progress.text:SetPoint("CENTER")
    self:RefreshProgress()

    local driver = CreateFrame("Frame")
    self.driver = driver
    if self.leatrix then
        -- Leatrix also lays out its frame directly in these event handlers.
        driver:RegisterEvent("PLAYER_REGEN_ENABLED")
        driver:RegisterEvent("UI_SCALE_CHANGED")
        driver:RegisterEvent("DISPLAY_SIZE_CHANGED")
        driver:SetScript("OnEvent", function() self.chromeDirty = true end)
    end
    local elapsed, wasVisible = .15, false
    driver:SetScript("OnUpdate", function(_, delta)
        if not map:IsVisible() then
            -- Avoid releasing edit-box focus inside Blizzard's gamepad close handler.
            if wasVisible then self.search:ClearFocus() end
            wasVisible = false
            return
        end
        wasVisible = true
        elapsed = elapsed + delta
        if elapsed < .15 or not GatherLite:IsLoaded() then return end
        elapsed = 0
        self:Update()
    end)
    local reference = GatherLite.db.global.usePredefined
    GatherLite:On("settings:update", function()
        local enabled = GatherLite.db.global.usePredefined
        if reference ~= enabled then self.zonesDirty, reference = true, enabled end
    end)
    GatherLite:On("nodes:added", function(node)
        if not node or not self.zoneObject or self.zoneObject.type == "fish" then return end
        for _, id in ipairs(self.zoneObject.id) do
            if node.object == id then
                self.zonesDirty = true
                self.routeDirty = Routes.onlyMapID == node.mapID or self.routeDirty
                break
            end
        end
    end)
end
