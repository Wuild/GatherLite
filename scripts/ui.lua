local _, addon = ...
local UI = {}
addon.UI = UI

-- Keep the map requirement tied to the same catalog values as node tooltips.
function UI.Requirement(object)
    if not object then return "" end
    if object.objects then return "Combined gathering route" end
    if object.type=="fish" then return "Fishing | Reported catches" end
    local profession=({ore="Mining",herb="Herbalism",fishing="Fishing",container="Lockpicking"})[object.type]
    local level=object.levels and object.levels[1]
    if profession and level then return profession.." "..level end
    return object.type=="fishing" and "Fishing | Pool locations" or "No skill requirement recorded"
end

function UI.Text(parent, text, font)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    label:SetText(text or "")
    label:SetJustifyH("LEFT")
    return label
end
function UI.Background(parent, r, g, b, a)
    local texture = parent:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints()
    texture:SetColorTexture(r, g, b, a or 1)
    return texture
end
function UI.HeaderBackground(parent)
    -- Tile a plain panel texture at its native scale; decorative title strips
    -- stretch their carved end caps and can obscure sibling header artwork.
    UI.Background(parent,.14,.115,.085,1)
    local texture=parent:CreateTexture(nil,"BACKGROUND",nil,1)
    texture:SetAllPoints()
    texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
    texture:SetHorizTile(true); texture:SetVertTile(true)
    local wash=parent:CreateTexture(nil,"BACKGROUND",nil,2)
    wash:SetAllPoints(); wash:SetColorTexture(.24,.19,.12,.32)
    local function resize()
        texture:SetTexCoord(0,math.max(1,parent:GetWidth())/64,0,math.max(1,parent:GetHeight())/64)
    end
    parent:HookScript("OnSizeChanged",resize)
    resize()
    local edge=parent:CreateTexture(nil,"BORDER")
    edge:SetColorTexture(.48,.37,.22,.65)
    edge:SetHeight(1); edge:SetPoint("BOTTOMLEFT"); edge:SetPoint("BOTTOMRIGHT")
    return texture
end

function UI.Border(parent)
    for _, edge in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local line = parent:CreateTexture(nil, "BORDER")
        line:SetColorTexture(.42, .32, .18, .65)
        if edge == "TOP" or edge == "BOTTOM" then
            line:SetPoint(edge .. "LEFT"); line:SetPoint(edge .. "RIGHT"); line:SetHeight(1)
        else
            line:SetPoint("TOP" .. edge); line:SetPoint("BOTTOM" .. edge); line:SetWidth(1)
        end
    end
end
function UI.Parchment(parent)
    UI.Background(parent,.79,.71,.55,1)
    -- QuestBG contains transparent padding and a painted edge. Use a seamless
    -- tiled texture as faint grain so every part of the page has the same finish.
    local paper=parent:CreateTexture(nil,"BACKGROUND",nil,1)
    paper:SetAllPoints()
    paper:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
    paper:SetHorizTile(true); paper:SetVertTile(true)
    paper:SetAlpha(.07)
    local function resize()
        paper:SetTexCoord(0,math.max(1,parent:GetWidth())/64,0,math.max(1,parent:GetHeight())/64)
    end
    parent:HookScript("OnSizeChanged",resize)
    resize()
    UI.Border(parent)
end
function UI.InkText(parent,text,font)
    local label=UI.Text(parent,text,font)
    -- GameFont objects inherit black drop shadows intended for dark panels.
    label:SetShadowOffset(0,0)
    label:SetShadowColor(0,0,0,0)
    label:SetTextColor(.22,.16,.095)
    return label
end
function UI.Button(parent, text, width, action)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width, 26); button:SetText(text); button:SetScript("OnClick", action)
    return button
end
-- Draw a compass directly so it never depends on a missing client icon.
function UI.Compass(parent)
    local frame=CreateFrame("Frame",nil,parent)
    frame:SetSize(25,25); frame:SetPoint("LEFT",11,0)
    local function line(x1,y1,x2,y2,r,g,b,thickness)
        local stroke=frame:CreateLine(nil,"ARTWORK")
        stroke:SetColorTexture(r,g,b,1); stroke:SetThickness(thickness or 1.5)
        stroke:SetStartPoint("CENTER",x1,y1); stroke:SetEndPoint("CENTER",x2,y2)
    end
    for i=0,23 do
        local a,b=i*math.pi/12,(i+1)*math.pi/12
        line(math.cos(a)*11,math.sin(a)*11,math.cos(b)*11,math.sin(b)*11,.78,.61,.31)
    end
    line(-8,0,8,0,.47,.40,.28,1)
    line(0,-8,0,8,.47,.40,.28,1)
    line(0,0,3,8,.86,.18,.10,3)
    line(0,0,-3,-8,.95,.88,.66,3)
    return frame
end
function UI.NavButton(parent, text, width, action, icon)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width, 42)
    button.selected = UI.Background(button, .56, .37, .13, .4)
    button.selected:Hide()
    button.mark = button:CreateTexture(nil, "OVERLAY")
    button.mark:SetColorTexture(.95, .72, .28, 1)
    button.mark:SetPoint("TOPLEFT"); button.mark:SetPoint("BOTTOMLEFT"); button.mark:SetWidth(3)
    button.mark:Hide()
    button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    local label = UI.Text(button, text, "GameFontNormal")
    label:SetPoint("LEFT", icon and 44 or 15, 0)
    label:SetWidth(width - (icon and 50 or 22))
    button.label = label
    if icon=="compass" then
        UI.Compass(button)
    elseif icon then
        local art = button:CreateTexture(nil, "ARTWORK")
        art:SetSize(25,25); art:SetPoint("LEFT",11,0); art:SetTexture(icon)
    end
    button:SetScript("OnClick", action)
    button.Select = function(self, selected)
        self.selected:SetShown(selected); self.mark:SetShown(selected)
        self.label:SetTextColor(selected and 1 or .77, selected and .84 or .72, selected and .47 or .62)
    end
    return button
end
function UI.Scroll(parent, name, width)
    local scroll = CreateFrame("ScrollFrame", name, parent)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(width, 1)
    scroll:SetScrollChild(content); scroll.content = content
    local bar=CreateFrame("EventFrame",name and name.."ScrollBar",scroll,"MinimalScrollBar")
    bar:SetPoint("TOPLEFT",scroll,"TOPRIGHT",10,0)
    bar:SetPoint("BOTTOMLEFT",scroll,"BOTTOMRIGHT",10,0)
    scroll.ScrollBar=bar
    scroll:EnableMouseWheel(true)
    ScrollUtil.InitScrollFrameWithScrollBar(scroll,bar)
    scroll:SetPanExtent(32)
    local function updateVisibility(self)
        local range=math.max(0,self:GetVerticalScrollRange())
        bar:SetShown(range>0)
        if self:GetVerticalScroll()>range then self:SetVerticalScroll(range) end
    end
    scroll:HookScript("OnScrollRangeChanged",updateVisibility)
    scroll:HookScript("OnShow",function(self)
        self:GetScript("OnScrollRangeChanged")(self,0,self:GetVerticalScrollRange())
    end)
    return scroll
end
function UI.Section(parent, text, width)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(width, 28)
    local label = UI.InkText(frame, text, "GameFontNormal")
    label:SetPoint("LEFT", 6, 3)
    local line = frame:CreateTexture(nil,"BORDER")
    line:SetColorTexture(.46,.34,.17,.35)
    line:SetPoint("BOTTOMLEFT"); line:SetPoint("BOTTOMRIGHT"); line:SetHeight(1)
    return frame
end
local function value(v)
    if type(v) == "function" then return v() end
    return v
end
local help = {
    predefined = "Include bundled gathering locations alongside your personal discoveries.",
    nodeMinimap = "Display known gathering locations near your character.",
    nodeWorldmap = "Display gathering markers on the game world map.",
    minimap = "Keep the GatherLite button beside your minimap.",
    zoneTooltip = "Preview a zone's tracked resources while hovering the continent map.",
    loot = "Include recorded loot and visit history in marker tooltips.",
    edge = "Keep out-of-range markers at the edge of the minimap.",
    enabled = "Record diagnostic messages for troubleshooting.",
}
function UI.SettingsGroup(parent, group, name)
    local scroll = UI.Scroll(parent, name, 904)
    scroll:SetPoint("TOPLEFT", 204, -76)
    scroll:SetPoint("BOTTOMRIGHT", -28, 12)
    local content, cursor, column, refresh = scroll.content, 0, 0, {}
    scroll.controls={}
    local function control(frame,x,y)
        frame.settingsX,frame.settingsY=x,y
        scroll.controls[#scroll.controls+1]=frame
        frame.OnSmartNavSelect=function()
            local top=frame.settingsY
            local bottom=top+frame:GetHeight()+8
            local offset=scroll:GetVerticalScroll()
            if top<offset then offset=top
            elseif bottom>offset+scroll:GetHeight() then offset=bottom-scroll:GetHeight() end
            scroll:SetVerticalScroll(math.max(0,math.min(scroll:GetVerticalScrollRange(),offset)))
            local navigation=addon.Window and addon.Window.controllerNavigation
            if navigation then navigation:SetScrollFrameForFrame(addon.Window.frame,scroll) end
        end
    end
    local function flush()
        if column > 0 then cursor = cursor + 30; column = 0 end
    end
    local function render(args)
        local keys = {}
        for key in pairs(args) do keys[#keys+1]=key end
        table.sort(keys, function(a,b)
            local x,y=args[a].order or 0,args[b].order or 0
            if x~=y then return x<y end
            if a:match("^node_") and b:match("^node_") then
                return value(args[a].name)<value(args[b].name)
            end
            return a<b
        end)
        for _,key in ipairs(keys) do
            local option=args[key]
            if option.type=="group" then
                flush()
                if value(option.name)~="" then
                    UI.Section(content,value(option.name),904):SetPoint("TOPLEFT",0,-cursor)
                    cursor=cursor+34
                end
                render(option.args)
            elseif option.type=="header" then
                flush()
                if cursor>0 then cursor=cursor+12 end
                UI.Section(content,value(option.name),904):SetPoint("TOPLEFT",0,-cursor)
                cursor=cursor+34
            elseif option.type=="toggle" then
                local index=tonumber(key:match("^node_(%d+)$"))
                local object=index and addon.nodeDB[index]
                if not object then flush() end
                local description=value(option.desc) or help[key]
                local height=not object and description and 46 or 30
                local width=object and 296 or 904
                local x=object and column*304 or 0
                local row=CreateFrame("Frame",nil,content)
                row:SetSize(width,height); row:SetPoint("TOPLEFT",x,-cursor)
                local check=CreateFrame("CheckButton",nil,row,"CheckboxWithLabelTemplate")
                check:SetSize(24,24); check:SetPoint("TOPLEFT",6,-3); check.Text:SetText("")
                check:SetHitRectInsets(0,-(width-30),0,-(height-27))
                local label=UI.InkText(row,value(option.name),"GameFontHighlight")
                label:SetPoint("TOPLEFT",object and 57 or 36,-9)
                label:SetWidth(width-(object and 64 or 44))
                label:SetTextColor(.20,.12,.055)
                if object then
                    local icon=row:CreateTexture(nil,"ARTWORK")
                    icon:SetSize(18,18); icon:SetPoint("LEFT",35,0); icon:SetTexture(object.icon)
                end
                if description and not object then
                    local hint=UI.InkText(row,description,"GameFontHighlightSmall")
                    hint:SetPoint("TOPLEFT",36,-28); hint:SetWidth(width-48)
                    hint:SetTextColor(.36,.25,.13)
                end
                if description and object then
                    check:SetScript("OnEnter",function()
                        GameTooltip:SetOwner(check,"ANCHOR_RIGHT")
                        GameTooltip:SetText(value(option.name))
                        GameTooltip:AddLine(description,1,1,1,true); GameTooltip:Show()
                    end)
                    check:SetScript("OnLeave",function() GameTooltip:Hide() end)
                end
                control(check,x,cursor)
                check:SetScript("OnClick",function(self)
                    option.set(nil,self:GetChecked() and true or false)
                    if addon.Window then addon.Window:RefreshSettings() end
                end)
                refresh[#refresh+1]=function() check:SetChecked(option.get()) end
                if object then
                    column=column+1
                    if column==3 then column=0; cursor=cursor+30 end
                else cursor=cursor+height+4 end
            elseif option.type=="execute" then
                flush()
                local button=UI.Button(content,value(option.name),240,function() option.func() end)
                button:SetPoint("TOPLEFT",8,-cursor)
                control(button,0,cursor)
                local description=value(option.desc)
                if description then
                    local hint=UI.InkText(content,description,"GameFontHighlightSmall")
                    hint:SetPoint("TOPLEFT",8,-cursor-30); hint:SetWidth(880)
                end
                cursor=cursor+(description and 64 or 38)
            elseif option.type=="range" then
                flush()
                local label=UI.InkText(content,value(option.name),"GameFontHighlight")
                label:SetPoint("TOPLEFT",8,-cursor-9)
                label:SetTextColor(.20,.12,.055)
                local slider=CreateFrame("Frame",nil,content,"MinimalSliderWithSteppersTemplate")
                slider:SetPoint("TOPLEFT",16,-cursor-32); slider:SetWidth(535)
                control(slider,0,cursor+32)
                slider.smartNavigationCanFocus=true
                for _,child in ipairs({slider.Slider,slider.Back,slider.Forward}) do child.smartNavigationIgnored=true end
                slider.OnSmartNavClick=function()
                    if addon.Window and addon.Window.BeginSliderEdit then addon.Window:BeginSliderEdit(slider) end
                end
                slider.OnSmartNavDeselect=function()
                    if addon.Window and addon.Window.editSlider==slider then addon.Window:EndSliderEdit() end
                end
                slider.AdjustBy=function(_,direction)
                    local current=option.get()
                    local steps=math.floor((current-option.min)/option.step+.5)+direction
                    local nextValue=math.max(option.min,math.min(option.max,option.min+steps*option.step))
                    if math.abs(nextValue-current)>option.step*.001 then slider:SetValue(nextValue) end
                end
                local updating=false
                slider:Init(option.get(),option.min,option.max,math.floor((option.max-option.min)/option.step+.5),{
                    [MinimalSliderWithSteppersMixin.Label.Right]=function(v) return string.format("%.1f",v) end,
                })
                slider:RegisterCallback("OnValueChanged",function(_,v)
                    if updating then return end
                    option.set(nil,v); GatherLite:Trigger("settings:update")
                    label:SetText(value(option.name))
                end,slider)
                refresh[#refresh+1]=function()
                    updating=true; slider:SetValue(option.get()); label:SetText(value(option.name)); updating=false
                end
                cursor=cursor+65
            end
        end
        flush()
    end
    render(group.args)
    content:SetHeight(math.max(cursor,1))
    scroll.Refresh=function() for _,fn in ipairs(refresh) do fn() end end
    scroll:HookScript("OnShow",scroll.Refresh); scroll:Hide()
    return scroll
end
