local _, addon = ...
addon.WindowController = {}

function addon.WindowController.Attach(window)
    local frame = window.frame
    local GamepadMode, SmartNavigation, localManager = addon.WindowInput.Create(window)
    GamepadMode.FrameControlsManager=localManager
    local SMART_NAV_INPUT_DIRECTION={LEFT="left",RIGHT="right",UP="up",DOWN="down"}
    local function SmartNavigation_AddJumpNavigationOverride(button,direction,target)
        if not button then return end
        button.gatherliteNavigation=button.gatherliteNavigation or {}
        button.gatherliteNavigation[direction]=target
    end
    local initialized, manager, bindings, bindingsActive
    local panX, panY = 0, 0
    local function active()
        return manager and frame:IsShown() and InputUtil.IsGamepadUIEnabled()
            and manager:GetActiveFrame() == frame
            and (not SmartNavigation.activeInfo or SmartNavigation.activeInfo.frame == frame)
    end
    local function action()
        return window.generate:IsShown() and window.generate:IsEnabled() and window.generate or window.open
    end
    local function resource()
        local first
        for _, row in ipairs(window.rows) do
            if row:IsShown() then
                first = first or row
                if row.object == window.object then return row end
            end
        end
        return first or window.search
    end
    function window:SetControllerTarget(target)
        if active() and target then SmartNavigation:SetTargetButtonForFrame(frame, target) end
    end
    function window:FocusRouteAction() self:SetControllerTarget(action()) end
    local sliderBindings, sliderDirection, sliderDelay
    function window:EndSliderEdit()
        if self.editSlider and sliderBindings then GamepadMode.DeactivateBindingGroup(sliderBindings) end
        self.editSlider,sliderDirection=nil,nil
        if self.selectedTab==2 and self.footer then
            self.footer:SetText("D-pad / stick: navigate | Left / Right: adjust slider | Confirm: toggle | Back: categories | Right stick: scroll")
        end
    end
    function window:BeginSliderEdit(slider)
        if not active() or self.selectedTab~=2 or not slider:IsVisible() then return end
        self:EndSliderEdit()
        if not sliderBindings then
            sliderBindings=GamepadMode.CreateBindingGroup("GatherLiteSettingsSlider")
            local function direction(delta,down)
                if not active() or not self.editSlider then return end
                if down then
                    sliderDirection,sliderDelay=delta,.35
                    self.editSlider:AdjustBy(delta)
                elseif sliderDirection==delta then sliderDirection=nil end
            end
            sliderBindings:AddFunctionBinding(GAMEPAD_DPAD_LEFT,function(down) direction(-1,down) end,GAMEPAD_BUTTON_ANY_DOWN_OR_UP)
            sliderBindings:AddFunctionBinding(GAMEPAD_DPAD_RIGHT,function(down) direction(1,down) end,GAMEPAD_BUTTON_ANY_DOWN_OR_UP)
            sliderBindings:AddFunctionBinding(GAMEPAD_FACE_BOTTOM,function() self:EndSliderEdit() end)
            sliderBindings:AddFunctionBinding(GAMEPAD_FACE_RIGHT,function() self:EndSliderEdit() end)
        end
        self.editSlider=slider
        self:SetControllerTarget(slider)
        GamepadMode.ActivateBindingGroup(sliderBindings)
        self.footer:SetText("Editing slider: Left / Right to adjust (hold to repeat) | Confirm or Back to finish | Changes save automatically")
    end
    local function settingsJumps(jump,dir)
        for key,button in pairs(window.settingsButtons) do
            jump(button,dir.RIGHT,function()
                if window.settingsCategory~=key then button:GetScript("OnClick")() end
                local panel=window.settingsPanels[key]
                return panel and panel.controls[1]
            end)
        end
        local panel=window.settingsPanels[window.settingsCategory]
        if not panel or panel.controllerJumpsReady then return end
        panel.controllerJumpsReady=true
        local controls=panel.controls
        for _,control in ipairs(controls) do
            local left,right,up,down
            local function closer(candidate,best)
                if not best then return true end
                local a=math.abs(candidate.settingsY-control.settingsY)*1000+math.abs(candidate.settingsX-control.settingsX)
                local b=math.abs(best.settingsY-control.settingsY)*1000+math.abs(best.settingsX-control.settingsX)
                return a<b
            end
            for _,other in ipairs(controls) do
                if other.settingsY==control.settingsY then
                    if other.settingsX<control.settingsX and closer(other,left) then left=other end
                    if other.settingsX>control.settingsX and closer(other,right) then right=other end
                elseif other.settingsY<control.settingsY and closer(other,up) then up=other
                elseif other.settingsY>control.settingsY and closer(other,down) then down=other end
            end
            jump(control,dir.LEFT,left or window.settingsButtons[window.settingsCategory])
            jump(control,dir.RIGHT,right or control)
            jump(control,dir.UP,up or control)
            jump(control,dir.DOWN,down or control)
        end
    end
    local function releaseBindings()
        panX, panY = 0, 0
        if bindingsActive then GamepadMode.DeactivateBindingGroup(bindings); bindingsActive = false end
    end
    local function refreshBindings()
        local want = active() and window.selectedTab == 1
        if not want then releaseBindings(); return end
        if not bindings and GamepadMode.CreateBindingGroup then
            bindings = GamepadMode.CreateBindingGroup("GatherLiteMapControls")
            bindings:AddAxisBinding(GAMEPAD_STICK_LEFT, function(x, y)
                if not active() then panX, panY = 0, 0; return true end
                panX = math.abs(x) > .18 and x or 0
                panY = math.abs(y) > .18 and -y or 0
                if (panX~=0 or panY~=0) and not window.helpStep and not window.controllerMenu then
                    window:SetControllerTarget(window.map)
                end
                return false
            end)
            bindings:AddFunctionBinding(GAMEPAD_SHOULDER_LEFT, function()
                if active() then addon.MapZoom.Step(window.map, -1) end
            end)
            bindings:AddFunctionBinding(GAMEPAD_SHOULDER_RIGHT, function()
                if active() then addon.MapZoom.Step(window.map, 1) end
            end)
        end
        if bindings and not bindingsActive then
            GamepadMode.ActivateBindingGroup(bindings); bindingsActive = true
        end
    end
    function window:RefreshController(resetFocus)
        if not active() then return end
        local jump, dir = SmartNavigation_AddJumpNavigationOverride, SMART_NAV_INPUT_DIRECTION
        if jump and dir then
            settingsJumps(jump,dir)
            jump(self.map,dir.RIGHT,resource)
            jump(self.map,dir.UP,function() return self.breadcrumb.homeButton end)
            for _, row in ipairs(self.rows) do
                jump(row, dir.RIGHT, action)
                jump(row, dir.LEFT, function() return self.breadcrumb.homeButton end)
            end
            for _, button in ipairs({self.generate,self.clear,self.visibility,self.open,self.previous,self.next}) do
                jump(button, dir.LEFT, resource)
            end
            for _, crumb in ipairs(self.breadcrumb.navList or {}) do
                local arrow=crumb.MenuArrowButton
                if arrow and arrow:IsShown() then
                    -- Blizzard marks these native arrows ignored by default.
                    arrow.smartNavigationIgnored=false
                    jump(crumb, dir.DOWN, arrow)
                    jump(arrow, dir.UP, crumb)
                    jump(arrow, dir.RIGHT, resource)
                    jump(arrow, dir.DOWN, self.map)
                end
            end
        end
        SmartNavigation:RefreshButtonGroups(frame)
        refreshBindings()
        if self.helpStep then
            self:UpdateOnboarding()
        elseif self.selectedTab==2 and not self.editSlider then
            self.footer:SetText("D-pad / stick: navigate | Left / Right: adjust slider | Confirm: toggle | Back: categories | Right stick: scroll")
        elseif self.selectedTab==3 then
            SmartNavigation:SetScrollFrameForFrame(frame,self.changelogScroll)
            self.footer:SetText("D-pad / stick: controls | Right stick: scroll release notes | Tabs: switch pages")
        elseif self.selectedTab==1 then
            self.footer:SetText("D-pad: controls | Map: stick moves cursor, Confirm enters zone | Shoulders: zoom | Right stick: scroll")
        end
        if resetFocus then
            SmartNavigation:ClearLastTarget(frame)
            self:SetControllerTarget(self.helpStep and self.guide.next or
                (self.selectedTab == 1 and self.map or self.selectedTab == 3 and self.tabs[3] or self.settingsFirst))
        end
    end
    local function shown()
        if not initialized or not frame:IsShown() or not InputUtil.IsGamepadUIEnabled() then return end
        manager = GamepadMode.FrameControlsManager
        manager:FrameShown(frame)
        window:RefreshController()
    end
    local function hidden()
        releaseBindings()
        window:EndSliderEdit()
        if manager then
            manager:FrameHidden(frame)
            if SmartNavigation then SmartNavigation:HandlePanelClose(frame) end
            manager = nil
        end
        if window.helpStep then window:UpdateOnboarding() end
        if window.footer and window.selectedTab==1 then
            window.footer:SetText("Scroll to zoom | Drag to pan | Click a zone to enter | Right-click to go back")
        end
    end
    frame.FocusGamepad = function() window:RefreshController(true) end
    frame.UnfocusGamepad = function()
        releaseBindings(); window:EndSliderEdit()
        if window.mapCursor then window.mapCursor:Hide() end
        if addon.MapHover then addon.MapHover:ClearWindow() end
    end
    frame.SmartNavigationCloseHandler = function()
        if window.editSlider then window:EndSliderEdit()
        elseif window.helpStep then window:CloseOnboarding() else frame:Hide() end
        return true
    end
    frame:HookScript("OnShow", shown)
    frame:HookScript("OnHide", hidden)
    frame:HookScript("OnUpdate", function(_, elapsed)
        if window.editSlider then
            if not active() or not window.editSlider:IsVisible()
                or SmartNavigation:GetCurrentButton()~=window.editSlider then
                window:EndSliderEdit()
            elseif sliderDirection then
                sliderDelay=sliderDelay-elapsed
                if sliderDelay<=0 then sliderDelay=.07; window.editSlider:AdjustBy(sliderDirection) end
            end
        end
        if bindingsActive and active() and (panX~=0 or panY~=0) then
            if SmartNavigation:GetCurrentButton()==window.map then
                window:MoveControllerMapCursor(panX*math.min(elapsed,.05)*.7,panY*math.min(elapsed,.05)*.7)
            else
                addon.MapZoom.Pan(window.map, panX*math.min(elapsed,.05)*.7, panY*math.min(elapsed,.05)*.7)
            end
        end
    end)
    local function initialize()
        if initialized or not InputUtil or not InputUtil.IsGamepadUIEnabled then return end
        initialized = true
        window.map.smartNavigationIgnored=true
        local wasEnabled=false
        frame:HookScript("OnUpdate",function()
            local enabled=InputUtil.IsGamepadUIEnabled() and not (InCombatLockdown and InCombatLockdown())
            if enabled~=wasEnabled then
                wasEnabled=enabled
                if enabled then shown() else hidden() end
            elseif enabled and not window.controllerInput:IsShown() then shown() end
        end)
        shown()
        frame:UnregisterEvent("ADDON_LOADED")
    end
    frame:RegisterEvent("ADDON_LOADED")
    frame:HookScript("OnEvent", function(_, event) if event == "ADDON_LOADED" then initialize() end end)
    initialize()
end
