local _, addon = ...
-- Entirely addon-owned input. Never register with Blizzard's frame manager or
-- binding stack: its core-binding listeners call protected action-bar APIs.
addon.WindowInput={}
function addon.WindowInput.Create(window)
    local owner=window.frame
    local manager, navigation, mode={},{},{}
    local groups, current, targets={},nil,{}
    local input=CreateFrame("Frame",nil,owner)
    input:EnableMouse(false)
    input:SetAllPoints(owner); input:SetFrameLevel(owner:GetFrameLevel()+200)
    input:Hide()
    local highlight=CreateFrame("Frame",nil,input)
    highlight:EnableMouse(false)
    addon.UI.Border(highlight)
    highlight:Hide()
    local function usable()
        return owner:IsShown() and InputUtil and InputUtil.IsGamepadUIEnabled()
            and not (InCombatLockdown and InCombatLockdown())
            and not (GamepadMode and GamepadMode.FrameControlsManager
                and GamepadMode.FrameControlsManager:GetActiveFrame())
    end
    local function enabled(button)
        return button and button:IsVisible() and (not button.IsEnabled or button:IsEnabled())
    end
    local function add(button)
        if enabled(button) then targets[#targets+1]=button end
    end
    local function select(button)
        if not enabled(button) then return end
        if current~=button and current and current.OnSmartNavDeselect then current:OnSmartNavDeselect() end
        current=button
        if button==window.map then
            window.search:ClearFocus()
            window:ShowControllerMapCursor()
        else
            if window.mapCursor then window.mapCursor:Hide() end
        if addon.MapHover then addon.MapHover:ClearWindow() end
        end
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT",button,"TOPLEFT",-3,3)
        highlight:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",3,-3)
        highlight:Show()
        if button.OnSmartNavSelect then button:OnSmartNavSelect() end
    end
    function navigation:RefreshButtonGroups()
        targets={}
        if window.controllerMenu then
            for _,button in ipairs(window.controllerMenu.buttons) do add(button) end
            return
        end
        add(owner.CloseButton); add(window.help)
        for _,tab in ipairs(window.tabs) do add(tab) end
        if window.helpStep then add(window.guide.OkayButton); add(window.guide.CloseButton) end
        if window.selectedTab==1 then
            add(window.search); add(window.map)
            for _,row in ipairs(window.rows) do add(row) end
            for _,button in ipairs({window.generate,window.previous,window.next,window.visibility,window.clear,window.open}) do add(button) end
            for _,crumb in ipairs(window.breadcrumb.navList or {}) do
                add(crumb); add(crumb.MenuArrowButton)
            end
            add(window.breadcrumb.overflowButton)
        elseif window.selectedTab==2 then
            for _,key in ipairs({"general","worldmap","minimap","tracking","debugging"}) do add(window.settingsButtons[key]) end
            local panel=window.settingsPanels[window.settingsCategory]
            for _,control in ipairs(panel and panel.controls or {}) do add(control) end
        end
        if current and not enabled(current) then current=nil; highlight:Hide() end
    end
    function navigation:SetTargetButtonForFrame(_,button) select(button) end
    function navigation:GetCurrentButton() return current end
    function navigation:ClearLastTarget() end
    function navigation:HandlePanelClose() current=nil; highlight:Hide() end
    function navigation:SetScrollFrameForFrame(_,scroll) self.scroll=scroll end
    function manager:GetActiveFrame() return input:IsShown() and usable() and owner or nil end
    function manager:FrameShown()
        if not usable() then return end
        input:EnableGamePadButton(true); input:EnableGamePadStick(true)
        input:Show(); owner:FocusGamepad()
    end
    function manager:FrameHidden()
        owner:UnfocusGamepad(); input:Hide()
        navigation:HandlePanelClose()
        if window.mapCursor then window.mapCursor:Hide() end
        if addon.MapHover then addon.MapHover:ClearWindow() end
    end
    function mode.CreateBindingGroup()
        local group={buttons={},axes={}}
        function group:AddFunctionBinding(key,fn,eventType) self.buttons[key]={fn=fn,both=eventType~=nil} end
        function group:AddAxisBinding(key,fn) self.axes[key]=fn end
        return group
    end
    function mode.ActivateBindingGroup(group)
        for _,other in ipairs(groups) do if other==group then return end end
        groups[#groups+1]=group
    end
    function mode.DeactivateBindingGroup(group)
        for i=#groups,1,-1 do if groups[i]==group then table.remove(groups,i) end end
    end
    local function closeMenu()
        local menu=window.controllerMenu
        if not menu then return end
        window.controllerMenu=nil; menu:Hide()
        navigation:RefreshButtonGroups(); select(menu.returnTarget)
    end
    local function menuFor(button)
        if not window.breadcrumb.navList then return end
        for _,crumb in ipairs(window.breadcrumb.navList) do
            if crumb.MenuArrowButton==button then return crumb end
        end
        if button==window.breadcrumb.overflowButton then return button end
    end
    local function click()
        if not enabled(current) then return end
        local button=current
        local crumb=menuFor(button)
        if crumb and crumb.listFunc then
            local entries=crumb:listFunc() or {}
            if #entries==0 then return end
            local menu=window.controllerMenuFrame or CreateFrame("Frame",nil,owner)
            window.controllerMenuFrame=menu
            for _,old in ipairs(menu.buttons or {}) do old:Hide() end
            menu:SetSize(270,math.min(400,#entries*30+12))
            menu:SetPoint("TOPLEFT",window.breadcrumb,"BOTTOMLEFT",0,-4)
            menu:SetFrameLevel(input:GetFrameLevel()+1)
            highlight:SetFrameLevel(menu:GetFrameLevel()+5)
            if not menu.scroll then addon.UI.Background(menu,.04,.03,.02,1); addon.UI.Border(menu) end
            menu.returnTarget=button; menu.buttons=menu.buttons or {}
            local scroll=menu.scroll or addon.UI.Scroll(menu,nil,240)
            menu.scroll=scroll
            scroll:SetPoint("TOPLEFT",6,-6); scroll:SetPoint("BOTTOMRIGHT",-24,6)
            for i,entry in ipairs(entries) do
                local item=menu.buttons[i] or addon.UI.Button(scroll.content,entry.text,236,function() end)
                item:SetText(entry.text); item:Show()
                item:SetScript("OnClick",function() closeMenu(); entry.func(nil,entry.id) end)
                item:SetPoint("TOPLEFT",0,-(i-1)*30)
                item.gatherliteNavigation={}
                item.OnSmartNavSelect=function()
                    scroll:SetVerticalScroll(math.max(0,math.min(scroll:GetVerticalScrollRange(),(i-1)*30)))
                    navigation.scroll=scroll
                end
                menu.buttons[i]=item
            end
            scroll.content:SetHeight(#entries*30)
            menu:Show()
            window.controllerMenu=menu
            navigation:RefreshButtonGroups(); select(menu.buttons[1])
        elseif button.OnSmartNavClick then button:OnSmartNavClick()
        elseif button.SetFocus and button==window.search then button:SetFocus()
        elseif button.Click then button:Click("LeftButton")
        else
            local fn=button:GetScript("OnClick")
            if fn then fn(button,"LeftButton") end
        end
    end
    local directions={PADDUP={"up",0,1},PADDDOWN={"down",0,-1},PADDLEFT={"left",-1,0},PADDRIGHT={"right",1,0}}
    local function move(direction)
        navigation:RefreshButtonGroups()
        if not current then select(targets[1]); return end
        -- A focused slider is directly adjustable; no hidden edit-mode prerequisite.
        if current.AdjustBy and direction[2]~=0 and not window.controllerMenu then
            current:AdjustBy(direction[2]); return
        end
        local override=current.gatherliteNavigation and current.gatherliteNavigation[direction[1]]
        if type(override)=="function" then override=override() end
        if enabled(override) then select(override); return end
        if window.controllerMenu then
            for i,button in ipairs(targets) do if button==current then select(targets[math.max(1,math.min(#targets,i+(direction[3]>0 and -1 or 1)))]); return end end
        end
        local x,y=current:GetCenter()
        if not x then return end
        local best,score
        for _,button in ipairs(targets) do
            local bx,by=button:GetCenter()
            if bx then
                local dx,dy=bx-x,by-y
                local forward=dx*direction[2]+dy*direction[3]
                local side=math.abs(dx*direction[3]-dy*direction[2])
                local candidate=forward+side*3
                if forward>1 and (not score or candidate<score) then best,score=button,candidate end
            end
        end
        select(best)
    end
    local held,delay,stickKey
    function navigation:ClearDirectionInput() held,stickKey=nil,nil; self.scrollSpeed=0 end
    window.map.OnSmartNavClick=function()
        local left,right,top,bottom=addon.Routes:GetViewport(window.map)
        if not left then return end
        local u,v=window.mapCursorX or .5,window.mapCursorY or .5
        local info=C_Map.GetMapInfoAtPosition(window.mapID,left+(right-left)*u,top+(bottom-top)*v)
        if info and info.mapID~=window.mapID then window:SetMap(info.mapID) end
    end
    function window:ShowControllerMapCursor()
        if not self.mapCursor then
            self.mapCursor=CreateFrame("Frame",nil,self.mapOverlay)
            self.mapCursor:SetSize(36,36); self.mapCursor:EnableMouse(false)
            self.mapCursor:SetFrameLevel(self.mapOverlay:GetFrameLevel()+20)
            -- Reuse the world-map soft cursor artwork, but own the frame and
            -- its state so we never touch Blizzard's protected controller path.
            local shadow=self.mapCursor:CreateTexture(nil,"ARTWORK")
            shadow:SetAtlas("gamepad-reticletargeting-indicator-x1")
            shadow:SetTexCoord(.08,.95,.08,.95)
            shadow:SetSize(36,36); shadow:SetPoint("CENTER",1,-1)
            shadow:SetVertexColor(0,0,0,1)
            local icon=self.mapCursor:CreateTexture(nil,"OVERLAY")
            icon:SetAtlas("gamepad-reticletargeting-indicator-x1")
            icon:SetTexCoord(.08,.95,.08,.95)
            icon:SetSize(34,34); icon:SetPoint("CENTER")
            self.mapCursor.icon=icon
            self.mapCursor.lines={}
            for i=1,4 do
                local line=self.mapCursor:CreateTexture(nil,"BACKGROUND")
                line:SetColorTexture(1,.82,.3,.45)
                self.mapCursor.lines[i]=line
            end
        end
        self.mapCursorX,self.mapCursorY=self.mapCursorX or .5,self.mapCursorY or .5
        self.mapCursor:ClearAllPoints()
        self.mapCursor:SetPoint("CENTER",self.mapOverlay,"TOPLEFT",self.mapCursorX*self.mapOverlay:GetWidth(),-self.mapCursorY*self.mapOverlay:GetHeight())
        local width,height=self.mapOverlay:GetWidth(),self.mapOverlay:GetHeight()
        local px,py=self.mapCursorX*width,self.mapCursorY*height
        local lines=self.mapCursor.lines
        lines[1]:SetPoint("RIGHT",self.mapCursor,"CENTER",-20,0); lines[1]:SetSize(math.max(0,px-20),1)
        lines[2]:SetPoint("LEFT",self.mapCursor,"CENTER",20,0); lines[2]:SetSize(math.max(0,width-px-20),1)
        lines[3]:SetPoint("BOTTOM",self.mapCursor,"CENTER",0,20); lines[3]:SetSize(1,math.max(0,py-20))
        lines[4]:SetPoint("TOP",self.mapCursor,"CENTER",0,-20); lines[4]:SetSize(1,math.max(0,height-py-20))
        self.mapCursor:Show()
    end
    function window:MoveControllerMapCursor(x,y)
        local nextX,nextY=(self.mapCursorX or .5)+x,(self.mapCursorY or .5)+y
        local marginX=math.min(.5,20/math.max(1,self.mapOverlay:GetWidth()))
        local marginY=math.min(.5,20/math.max(1,self.mapOverlay:GetHeight()))
        self.mapCursorX=math.max(marginX,math.min(1-marginX,nextX))
        self.mapCursorY=math.max(marginY,math.min(1-marginY,nextY))
        -- Continue moving the map when the cursor reaches the viewport edge.
        local dx,dy=nextX-self.mapCursorX,nextY-self.mapCursorY
        if dx~=0 or dy~=0 then addon.MapZoom.Pan(self.map,dx,dy) end
        self:ShowControllerMapCursor()
    end
    local function dispatch(key,down)
        if not usable() then return true end
        for i=#groups,1,-1 do
            local binding=groups[i].buttons[key]
            if binding then if down or binding.both then binding.fn(down) end; return false end
        end
        if not down then if held==key then held=nil end; return false end
        if directions[key] then held,delay=key,.35; move(directions[key])
        elseif key==(GAMEPAD_FACE_BOTTOM or "PAD1") then click()
        elseif key==(GAMEPAD_FACE_RIGHT or "PAD2") then
            if window.controllerMenu then closeMenu()
            elseif window.selectedTab==2 and not window.editSlider and current~=window.settingsButtons[window.settingsCategory] then
                select(window.settingsButtons[window.settingsCategory])
            else owner:SmartNavigationCloseHandler() end
        else return true end
        return false
    end
    input:SetScript("OnGamePadButtonDown",function(_,key) return dispatch(key,true) end)
    input:SetScript("OnGamePadButtonUp",function(_,key) return dispatch(key,false) end)
    input:SetScript("OnGamePadStick",function(_,stick,x,y)
        if not usable() then return true end
        if stick=="Movement" and (window.selectedTab~=1 or window.controllerMenu) then
            local key
            if math.max(math.abs(x),math.abs(y))>.45 then
                if math.abs(x)>math.abs(y) then key=x>0 and "PADDRIGHT" or "PADDLEFT"
                else key=y>0 and "PADDUP" or "PADDDOWN" end
            end
            if key~=stickKey then
                if stickKey then dispatch(stickKey,false) end
                stickKey=key
                if key then dispatch(key,true) end
            end
            return false
        end
        if stick=="Movement" and stickKey then dispatch(stickKey,false); stickKey=nil end
        local key=stick=="Movement" and GAMEPAD_STICK_LEFT or GAMEPAD_STICK_RIGHT
        for i=#groups,1,-1 do local fn=groups[i].axes[key]; if fn then return fn(x,y) end end
        if stick=="Camera" then navigation.scrollSpeed=-y; return false end
        return true
    end)
    input:SetScript("OnUpdate",function(_,elapsed)
        if not usable() then
            held=nil; stickKey=nil; navigation.scrollSpeed=0; highlight:Hide(); owner:UnfocusGamepad(); return
        end
        if held then delay=delay-elapsed; if delay<=0 then delay=.12; move(directions[held]) end end
        local scroll=navigation.scroll
        if scroll and scroll:IsVisible() and navigation.scrollSpeed and math.abs(navigation.scrollSpeed)>.18 then
            scroll:SetVerticalScroll(math.max(0,math.min(scroll:GetVerticalScrollRange(),scroll:GetVerticalScroll()+navigation.scrollSpeed*elapsed*600)))
        end
        if not highlight:IsShown() then owner:FocusGamepad() end
        if current==window.map then
            window:ShowControllerMapCursor()
            if addon.MapHover then addon.MapHover:UpdateWindow(window) end
        end
    end)
    owner:HookScript("OnHide",function() held=nil; stickKey=nil; navigation.scrollSpeed=0; closeMenu() end)
    window.controllerInput=input
    window.controllerNavigation=navigation
    return mode,navigation,manager
end
