local name, _GatherLite = ...;

local minimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("GatherLiteMinimapIcon", {
    type = "data source",
    text = "Gatherlite",
    icon = "Interface\\Icons\\inv_misc_spyglass_02",

    OnClick = function(self, button)
        if button == "LeftButton" then
            local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(dropDown, GatherLite:MinimapContextMenu(), "MENU")
            ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
        elseif button == "RightButton" then
            InterfaceOptionsFrame_OpenToCategory("GatherLite")
            InterfaceOptionsFrame_OpenToCategory("GatherLite") -- run it again to set the correct tab
        end
    end,

    OnTooltipShow = function(tooltip)
        tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('mining'), "white"), GatherLite:tablelength(GatherLite.db.global.nodes.mining));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('herbalism'), "white"), GatherLite:tablelength(GatherLite.db.global.nodes.herbalism));

        tooltip:AddLine(" ");
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.left_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.left_click_text"));
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.right_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.right_click_text"));
    end,
});

function GatherLite:GatherSlash(input)
    input = string.trim(input, " ");
    if input == "" or not input then
        GatherLite:ShowSettings();
        return ;
    end

    if input == "debugging" then
        if GatherLite.db.char.debugging then
            GGatherLite.db.char.debugging = false;
            GatherLite:print("debugging", GatherLite:Colorize("disabled", "red"));
        else
            GatherLite.db.char.debugging = true;
            GatherLite:print("debugging", GatherLite:Colorize("enabled", "green"));
        end
    end
end

function GatherLite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GatherLiteSettings", _GatherLite.configsDefaults, true)
    self.minimap = LibStub("LibDBIcon-1.0")

    GatherLite:print(GatherLite:Colorize(_GatherLite.version, "blue"), "has been loaded");
    GatherLite:print("use |cFF00FF00/gather|r or |cFF00FF00/gatherlite|r to access addon settings");

    GatherLite.minimap:Register("GatherLiteMinimapIcon", minimapIcon, self.db.profile.minimap);

    GatherLite:RegisterEvent("UNIT_SPELLCAST_SENT", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventHandler")
    GatherLite:RegisterEvent("LOOT_OPENED", "EventHandler")

    hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
        GatherLite:LoadWorldmap();
    end);

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 5)

    GatherLite:SendVersionCheck()
    GatherLite:Load();
end