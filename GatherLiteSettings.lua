local name, GatherLite = ...


--options interface
local OptionsPanel = CreateFrame("Frame", "GatherLiteOptionsPanel", UIParent);
OptionsPanel.name = GatherLite.name;
OptionsPanel:RegisterEvent('ADDON_LOADED')

InterfaceOptions_AddCategory(OptionsPanel);

local t;

--add a title
t = OptionsPanel:CreateFontString("GatherLiteOptionsPanelTitle", "OVERLAY", "GameFontNormal")
t:SetPoint("TOPLEFT", 16, -16)
t:SetFont("Fonts\\FRIZQT__.TTF", 18)
t:SetText("GatherLite")


------------------
--- WORLD MAP
------------------
t = CreateFrame("CheckButton", "GatherLiteWorldmapIcons", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -70);
GatherLiteWorldmapIconsText:SetText(' |cffffffffWorld map icons|r');
t.tooltip = 'Display world map icons.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.showOnWorldMap = self:GetChecked();
    ApplyOptions()
end)

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -50)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('World map options')

-- icon size world map
t = CreateFrame("Slider", "GatherLiteWorldMapIconSize", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 360, -80);
t:SetMinMaxValues(4, 30);
t:SetValueStep(1);
getglobal(t:GetName() .. 'Low'):SetText('4');
getglobal(t:GetName() .. 'High'):SetText('30');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Size: ' .. string.format('%.0f', tostring(self:GetValue()))));
    GatherLiteConfigCharacter.worldmapIconSize = tonumber(self:GetValue());
    ApplyOptions()
end)

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -120)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('Mini map options')

t = CreateFrame("CheckButton", "GatherLiteMinimapIcons", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -140);
GatherLiteMinimapIconsText:SetText(' |cffffffffMini map icons|r');
t.tooltip = 'Display mini map icons.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.showOnMinimap = self:GetChecked();
    ApplyOptions()
end)

-- icon size world map
t = CreateFrame("Slider", "GatherLiteMiniMapIconSize", OptionsPanel, "OptionsSliderTemplate");
t:SetThumbTexture("Interface/Buttons/UI-SliderBar-Button-Horizontal");
t:SetSize(160, 20);
t:SetOrientation('HORIZONTAL');
t:SetPoint('TOPLEFT', 360, -140);
t:SetMinMaxValues(4, 30);
t:SetValueStep(1);
getglobal(t:GetName() .. 'Low'):SetText('4');
getglobal(t:GetName() .. 'High'):SetText('30');
t:SetScript('OnValueChanged', function(self)
    getglobal(self:GetName() .. 'Text'):SetText(tostring('Icon Size: ' .. string.format('%.0f', tostring(self:GetValue()))));
    GatherLiteConfigCharacter.minimapIconSize = tonumber(self:GetValue());
    ApplyOptions()
end)

t = OptionsPanel:CreateFontString('ForagerOptionsPanelSharingOptionsHeader', 'OVERLAY', 'GameFontNormal')
t:SetPoint('TOPLEFT', 16, -180)
t:SetFont("Fonts\\FRIZQT__.TTF", 13)
t:SetJustifyH('LEFT')
t:SetText('Sharing options')

t = CreateFrame("CheckButton", "GatherLiteSharingGuild", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -200);
GatherLiteSharingGuildText:SetText(' |cffffffffGuild share|r');
t.tooltip = 'Share nodes to guild members.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.shareGuild = self:GetChecked();
end)

t = CreateFrame("CheckButton", "GatherLiteSharingParty", OptionsPanel, "ChatConfigCheckButtonTemplate");
t:SetPoint('TOPLEFT', 20, -230);
GatherLiteSharingPartyText:SetText(' |cffffffffParty share|r');
t.tooltip = 'Share nodes to party members.';
t:SetScript('OnClick', function(self)
    GatherLiteConfigCharacter.shareParty = self:GetChecked();
end)

function OptionsPanelOnEvent(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == GatherLite.name then
        GatherLiteWorldMapIconSize:SetValue(GatherLiteConfigCharacter.worldmapIconSize);
        GatherLiteMiniMapIconSize:SetValue(GatherLiteConfigCharacter.minimapIconSize);

        GatherLiteWorldmapIcons:SetChecked(GatherLiteConfigCharacter.showOnWorldMap);
        GatherLiteMinimapIcons:SetChecked(GatherLiteConfigCharacter.showOnMinimap);
        GatherLiteSharingGuild:SetChecked(GatherLiteConfigCharacter.shareGuild);
        GatherLiteSharingParty:SetChecked(GatherLiteConfigCharacter.shareParty);
        self:UnregisterEvent("ADDON_LOADED");
    end
end

function ApplyOptions()
    GatherLite.needMapUpdate = true;
end

OptionsPanel:SetScript('OnEvent', OptionsPanelOnEvent);