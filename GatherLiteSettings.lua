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
        GatherLiteSharingGuild:SetChecked(GatherLiteConfigCharacter.shareGuild);
        GatherLiteSharingParty:SetChecked(GatherLiteConfigCharacter.shareParty);
        self:UnregisterEvent("ADDON_LOADED");
    end
end

function ApplyOptions()
    GatherLite.needMapUpdate = true;
end

OptionsPanel:SetScript('OnEvent', OptionsPanelOnEvent);