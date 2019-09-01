local name, GatherLite = ...


--options interface
local OptionsPanel = CreateFrame("Frame", "GatherLiteOptionsPanel", UIParent);
OptionsPanel.name = GatherLite.name;
OptionsPanel:RegisterEvent('ADDON_LOADED')

InterfaceOptions_AddCategory(OptionsPanel);

local t;

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--add a title
t = OptionsPanel:CreateFontString("GatherLiteOptionsPanelTitle", "OVERLAY", "GameFontNormal")
t:SetPoint("TOPLEFT", 16, -16)
t:SetFont("Fonts\\FRIZQT__.TTF", 18)
t:SetText("GatherLite")

t = CreateFrame("CheckButton", "GatherLiteMinimap", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 420, -20);
GatherLiteMinimapText:SetText(' |cffffffffShow minimap button|r');
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.minimapButton = self:GetChecked();
    ApplyOptions()
end)

------------------
--- WORLD MAP
------------------

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -50)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('World map options')

t = CreateFrame("CheckButton", "GatherLiteWorldmapIcons", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -70);
GatherLiteWorldmapIconsText:SetText(' |cffffffffWorld map icons|r');
t.tooltip = 'Display world map icons.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.showOnWorldMap = self:GetChecked();
    ApplyOptions()
end)

t = CreateFrame("CheckButton", "GatherLiteWorldmapLoot", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 200, -70);
GatherLiteWorldmapLootText:SetText(' |cffffffffLoot table|r');
t.tooltip = 'Display loot table on tooltip.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.worldmapLoot = self:GetChecked();
    ApplyOptions()
end)

-- icon size world map
t = CreateFrame("Slider", "GatherLiteWorldMapIconSize", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 20, -120);
t:SetMinMaxValues(4, 30);
t:SetValueStep(1);
getglobal(t:GetName() .. 'Low'):SetText('4');
getglobal(t:GetName() .. 'High'):SetText('30');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Size: ' .. string.format('%.0f', tostring(self:GetValue()))));
    GatherLiteConfigCharacter.worldmapIconSize = tonumber(self:GetValue());
    ApplyOptions()
end)

t = CreateFrame("Slider", "GatherLiteWorldMapIconAlpha", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 240, -120);
t:SetMinMaxValues(0.1, 1.0);
t:SetValueStep(0.1);
getglobal(t:GetName() .. 'Low'):SetText('0');
getglobal(t:GetName() .. 'High'):SetText('1');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Opacity: ' .. round(self:GetValue(), 1)));
    GatherLiteConfigCharacter.worldmapOpacity = tonumber(self:GetValue());
    ApplyOptions()
end)

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -170)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('Mini map options')

t = CreateFrame("CheckButton", "GatherLiteMinimapIcons", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -190);
GatherLiteMinimapIconsText:SetText(' |cffffffffMini map icons|r');
t.tooltip = 'Display mini map icons.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.showOnMinimap = self:GetChecked();
    ApplyOptions()
end)

t = CreateFrame("CheckButton", "GatherLiteMinimapLoot", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 200, -190);
GatherLiteMinimapLootText:SetText(' |cffffffffLoot table|r');
t.tooltip = 'Display loot table on tooltip.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.minimapLoot = self:GetChecked();
    ApplyOptions()
end)

--t = CreateFrame("CheckButton", "GatherLiteMinimapEdge", OptionsPanel, "ChatConfigCheckButtonTemplate");
--t:SetPoint('TOPLEFT', 380, -190);
--GatherLiteMinimapEdgeText:SetText(' |cffffffffShow on edge|r');
--t.tooltip = 'Display nodes at minimap edge.';
--t:SetScript('OnClick', function(self)
--    GatherLiteConfigCharacter.minimapEdge = self:GetChecked();
--    ApplyOptions()
--end)

-- icon size world map
t = CreateFrame("Slider", "GatherLiteMiniMapIconSize", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 20, -240);
t:SetMinMaxValues(4, 30);
t:SetValueStep(1);
getglobal(t:GetName() .. 'Low'):SetText('4');
getglobal(t:GetName() .. 'High'):SetText('30');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Size: ' .. string.format('%.0f', tostring(self:GetValue()))));
    GatherLiteConfigCharacter.minimapIconSize = tonumber(self:GetValue());
    ApplyOptions()
end)

t = CreateFrame("Slider", "GatherLiteMiniMapIconAlpha", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 240, -240);
t:SetMinMaxValues(0.1, 1.0);
t:SetValueStep(0.1);
getglobal(t:GetName() .. 'Low'):SetText('0');
getglobal(t:GetName() .. 'High'):SetText('1');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Opacity: ' .. round(self:GetValue(), 1)));
    GatherLiteConfigCharacter.minimapOpacity = tonumber(self:GetValue());
    ApplyOptions()
end)

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -290)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('Sharing options')

t = CreateFrame("CheckButton", "GatherLiteSharingGuild", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -310);
GatherLiteSharingGuildText:SetText(' |cffffffffGuild share|r');
t.tooltip = 'Share nodes to guild members.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.shareGuild = self:GetChecked();
end)

t = CreateFrame("CheckButton", "GatherLiteSharingParty", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -340);
GatherLiteSharingPartyText:SetText(' |cffffffffParty share|r');
t.tooltip = 'Share nodes to party members.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.shareParty = self:GetChecked();
end)

function OptionsPanelOnEvent(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == GatherLite.name then
        GatherLiteWorldMapIconSize:SetValue(GatherLiteConfigCharacter.worldmapIconSize);
        GatherLiteMiniMapIconSize:SetValue(GatherLiteConfigCharacter.minimapIconSize);

        GatherLiteWorldMapIconAlpha:SetValue(GatherLiteConfigCharacter.worldmapOpacity);
        GatherLiteMiniMapIconAlpha:SetValue(GatherLiteConfigCharacter.minimapOpacity);

        GatherLiteWorldmapIcons:SetChecked(GatherLiteConfigCharacter.showOnWorldMap);
        GatherLiteWorldmapLoot:SetChecked(GatherLiteConfigCharacter.worldmapLoot);
        GatherLiteMinimapIcons:SetChecked(GatherLiteConfigCharacter.showOnMinimap);
        GatherLiteMinimapLoot:SetChecked(GatherLiteConfigCharacter.minimapLoot);
        --GatherLiteMinimapEdge:SetChecked(GatherLiteConfigCharacter.minimapEdge);
        GatherLiteSharingGuild:SetChecked(GatherLiteConfigCharacter.shareGuild);
        GatherLiteSharingParty:SetChecked(GatherLiteConfigCharacter.shareParty);
        GatherLiteMinimap:SetChecked(GatherLiteConfigCharacter.minimapButton);

        if not GatherLiteConfigCharacter.minimapButton then
            GatherLite.minimap:Hide();
        else
            GatherLite.minimap:Show();
        end

        self:UnregisterEvent("ADDON_LOADED");
    end
end

function ApplyOptions()
    if not GatherLiteConfigCharacter.minimapButton then
        GatherLite.minimap:Hide();
    else
        GatherLite.minimap:Show();
    end
    GatherLite.needMapUpdate = true;
end

OptionsPanel:SetScript('OnEvent', OptionsPanelOnEvent);


-----------------------------------------------------------------------------------------------------------------------------------
-- MINI MAP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.minimap = CreateFrame("Button", "GatherLite_MinimapButton", Minimap);
GatherLite.minimap:EnableMouse(true);
GatherLite.minimap:SetMovable(true);
GatherLite.minimap:SetSize(33, 33);
GatherLite.minimap:SetPoint("TOPLEFT");
GatherLite.minimap:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
GatherLite.minimap:RegisterForClicks("LeftButtonUp", "RightButtonUp");
GatherLite.minimap:RegisterForDrag("LeftButton");

local t = GatherLite.minimap:CreateTexture(nil, "OVERLAY");
t:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
t:SetSize(56, 56);
t:SetPoint("TOPLEFT");

local t = GatherLite.minimap:CreateTexture(nil, "background");
t:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
t:SetSize(21, 21);
t:SetPoint("CENTER");

GatherLite.minimapFrame = CreateFrame("FRAME", nil, GatherLite.minimap);
GatherLite.minimapFrame:SetScript("OnUpdate", function()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70 -- get coordinates as differences from the center of the minimap
    ypos = ypos / UIParent:GetScale() - ymin - 70

    GatherLiteConfigCharacter.MiniMapPosition = math.deg(math.atan2(ypos, xpos))
    GatherLite.updateMiniMapPosition()
end);
GatherLite.minimapFrame:Hide();

GatherLite.minimap:SetScript("OnDragStart", function(self)
    self:LockHighlight();
    GatherLite.minimapFrame:Show();
    GatherLite.tooltip:Hide();
end);

GatherLite.minimap:SetScript("OnDragStop", function(self)
    self:UnlockHighlight();
    GatherLite.minimapFrame:Hide();
    if (GatherLite.showingTooltip) then
        GatherLite.tooltip:Show();
    end ;
end);

GatherLite.minimap:SetScript("OnEnter", function()
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:SetOwner(GatherLite.minimap, "ANCHOR_LEFT");
    GatherLite.tooltip:SetText(GatherLite.name .. " |cFF00FF00" .. GatherLite.version .. "|r");

    GatherLite.tooltip:AddDoubleLine("|cffffffffMining:|r", GatherLite.tablelength(GatherLiteGlobalSettings.database.mining));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(2770), { width = 14, height = 14 })

    GatherLite.tooltip:AddDoubleLine("|cffffffffHerbalism:|r", GatherLite.tablelength(GatherLiteGlobalSettings.database.herbalism));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(765), { width = 14, height = 14 })

    if not GatherLite.isClassic then
        GatherLite.tooltip:AddDoubleLine("|cffffffffArtifacts:|r", GatherLite.tablelength(GatherLiteGlobalSettings.database.artifacts));
        --        GatherLite.tooltip:AddTexture(GetItemIcon(1195), { width = 14, height = 14 })
    end ;
    GatherLite.tooltip:AddDoubleLine("|cffffffffFish:|r", GatherLite.tablelength(GatherLiteGlobalSettings.database.fish));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(6303), { width = 14, height = 14 })

    GatherLite.tooltip:AddDoubleLine("|cffffffffTreasures:|r", GatherLite.tablelength(GatherLiteGlobalSettings.database.treasure));
    --    GatherLite.tooltip:AddTexture(132594, { width = 14, height = 14 })

    GatherLite.tooltip:Show();
    GatherLite.showingTooltip = true;
end);

GatherLite.minimap:SetScript("OnLeave", function()
    GatherLite.hideTooltip();
end);

GatherLite.minimap:SetScript("OnClick", function(self, button)
    local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(dropDown, MinimapContextMenu, "MENU")
    ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
end);

GatherLite.updateMiniMapPosition = function()
    GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end

function addContextItem(args)
    local info = UIDropDownMenu_CreateInfo()
    info.text = args.text;
    info.checked = args.checked;
    info.func = args.callback;
    info.icon = args.icon;
    info.isTitle = args.isTitle;
    info.disabled = args.disabled;
    info.notCheckable = args.notCheckable;
    UIDropDownMenu_AddButton(info)
end

function MinimapContextMenu(frame, level, menuList)

    if level == 1 then

        addContextItem({
            text = "GatherLite",
            isTitle = true,
            notCheckable = true
        });

        addContextItem({
            text = "Mining",
            icon = GetItemIcon(2770),
            checked = GatherLiteConfigCharacter.mining,
            callback = function()
                if GatherLiteConfigCharacter.mining then
                    GatherLiteConfigCharacter.mining = false;
                else
                    GatherLiteConfigCharacter.mining = true;
                end ;

                GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = "Herbalism",
            icon = GetItemIcon(765),
            checked = GatherLiteConfigCharacter.herbalism,
            callback = function()
                if GatherLiteConfigCharacter.herbalism then
                    GatherLiteConfigCharacter.herbalism = false;
                else
                    GatherLiteConfigCharacter.herbalism = true;
                end ;
                GatherLite.needMapUpdate = true;
            end
        })

        if not GatherLite.isClassic then
            addContextItem({
                text = "Archaeology",
                icon = 134435,
                checked = GatherLiteConfigCharacter.artifacts,
                callback = function()
                    if GatherLiteConfigCharacter.artifacts then
                        GatherLiteConfigCharacter.artifacts = false;
                    else
                        GatherLiteConfigCharacter.artifacts = true;
                    end ;
                    GatherLite.needMapUpdate = true;
                end
            })
        end

        addContextItem({
            text = "Fish",
            icon = GetItemIcon(6303),
            checked = GatherLiteConfigCharacter.fish,
            callback = function()
                if GatherLiteConfigCharacter.fish then
                    GatherLiteConfigCharacter.fish = false;
                else
                    GatherLiteConfigCharacter.fish = true;
                end ;
                GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = "Treasure chests",
            icon = 132594,
            checked = GatherLiteConfigCharacter.treasure,
            callback = function()
                if GatherLiteConfigCharacter.treasure then
                    GatherLiteConfigCharacter.treasure = false;
                else
                    GatherLiteConfigCharacter.treasure = true;
                end ;
                GatherLite.needMapUpdate = true;
            end
        })
    end
end
