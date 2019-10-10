local name, _GatherLite = ...;


-----------------------------------------------------------------------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
_GatherLite.tooltip = CreateFrame("GameTooltip", "GatherLiteTooltip", UIParent, "GameTooltipTemplate")
_GatherLite.tooltip:ClearLines()
_GatherLite.tooltip:AddFontStrings(_GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), _GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));
_GatherLite.showingTooltip = false;

_GatherLite.showTooltip = function(title, ...)
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    _GatherLite.tooltip:SetText(title);

    if ... then
        for r, l in ipairs(...) do
            _GatherLite.tooltip:AddLine(l);
        end
    end
    _GatherLite.tooltip:Show();
    _GatherLite.showingTooltip = true;
end

_GatherLite.hideTooltip = function()
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:Hide();
    _GatherLite.showingTooltip = false;
end

local minimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("GatherLiteMinimapIcon", {
    type = "data source",
    text = "Gatherlite",
    icon = "Interface\\Icons\\inv_misc_spyglass_02",

    OnClick = function(self, button)
        if button == "LeftButton" then
            if IsShiftKeyDown() then
                GatherLite.db.char.enabled = not GatherLite.db.char.enabled;
                return ;
            end

            local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(dropDown, GatherLite:MinimapContextMenu(), "MENU")
            ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
        elseif button == "RightButton" then
            InterfaceOptionsFrame_OpenToCategory("GatherLite")
            InterfaceOptionsFrame_OpenToCategory("GatherLite") -- run it again to set the correct tab

            --if not GatherLite.OptionsPanel:IsShown() then
            --    PlaySound(882);
            --    LibStub("AceConfigDialog-3.0"):Open("GatherLite", GatherLite.OptionsPanel)
            --else
            --    GatherLite.OptionsPanel:Hide();
            --end
        end
    end,

    OnTooltipShow = function(tooltip)
        tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('mining'), "white"), GatherLite:tablelength(_GatherLite.nodes.mining));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('herbalism'), "white"), GatherLite:tablelength(_GatherLite.nodes.herbalism));

        if not _GatherLite.isClassic then
            tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('archaeology'), "white"), GatherLite:tablelength(_GatherLite.nodes.artifacts));
        end
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('fish'), "white"), GatherLite:tablelength(_GatherLite.nodes.fish));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('treasures'), "white"), GatherLite:tablelength(_GatherLite.nodes.treasure));

        tooltip:AddLine(" ");
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.left_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.left_click_text"));
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.shift_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.shift_click_text") .. " " .. _GatherLite.name);
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.right_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.right_click_text"));
    end,
});

function GatherLite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GatherLiteConfig", _GatherLite.configsDefaults, true)
    self.minimap = LibStub("LibDBIcon-1.0");

    GatherLite:sanitizeDatabase();

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    -- register synchronization
    GatherLite:RegisterComm(_GatherLite.name .. "Node", "p2pNode")
    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")

    GatherLite.syncTimer = GatherLite:ScheduleTimer("p2pDatabase", 5)
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 5)
    GatherLite:ScheduleRepeatingTimer("UpdateNodes", 1);
    GatherLite:ScheduleRepeatingTimer("syncCheck", 10)

    GatherLite:RegisterEvent("UNIT_SPELLCAST_SENT", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventHandler")
    GatherLite:RegisterEvent("LOOT_OPENED", "EventHandler")

    GatherLite:print(GatherLite:Colorize(_GatherLite.version, "blue"), "has been loaded");
    GatherLite:print("use |cFF00FF00/gather|r or |cFF00FF00/gatherlite|r to access addon settings");
    if _GatherLite.isClassic then
        GatherLite:print("Please consider sharing your database over at our website", GatherLite:Colorize("http://gatherlite.labcake.org", "cyan"), "as we are currently building a predefined database and all contributions are appreciated");
    end

    GatherLite.minimap:Register("GatherLiteMinimapIcon", minimapIcon, self.db.profile.minimap);

    GatherLite:loadDatabase();

    GatherLite:drawMinimap();
    GatherLite:drawWorldmap();

    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(_GatherLite.nodes.mining) .. "|r", "mining nodes");
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(_GatherLite.nodes.herbalism) .. "|r", "herbalism nodes");
    if not _GatherLite.isClassic then
        GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(_GatherLite.nodes.artifacts) .. "|r", "artifact nodes");
    end
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(_GatherLite.nodes.fish) .. "|r", "fishing spots");
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(_GatherLite.nodes.treasure) .. "|r", "treasures");


    self.db.global.classic = _GatherLite.isClassic;
end