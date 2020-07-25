local name, _GatherLite = ...;

local GFrame = LibStub("GatherLiteFrame");

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

        if GatherLite.db.global.debug.enabled then
            tooltip:AddLine(" ");
            tooltip:AddLine("             -- Debugging --             ");
            tooltip:AddDoubleLine(GatherLite:Colorize("Used frames", "white"), GatherLite:tablelength(GFrame.usedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("Unused frames", "white"), GatherLite:tablelength(GFrame.unusedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("All frames", "white"), GatherLite:tablelength(GFrame.allFrames));
        end

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
            GatherLite.db.char.debugging = false;
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
    GatherLite:print("Keep this addon alive by donating a coffee at " .. GatherLite:Colorize("https://www.buymeacoffee.com/yuImx6KOY", "cyan"));

    GatherLite.minimap:Register("GatherLiteMinimapIcon", minimapIcon, self.db.profile.minimap);

    GatherLite:RegisterEvent("UNIT_SPELLCAST_SENT", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventHandler")
    GatherLite:RegisterEvent("LOOT_OPENED", "EventHandler")
    GatherLite:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler")

    hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
        GatherLite:ResetWorldmap();
    end);

    GameTooltip:HookScript("OnShow", GatherLite.ModifyTooltip)
    GameTooltip:HookScript("OnUpdate", GatherLite.ModifyTooltip)

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 10)
    GatherLite:ScheduleRepeatingTimer("LoadMinimap", 2)

    GatherLite:SendVersionCheck()
    GatherLite:Load();
end

function GatherLite.ModifyTooltip()
    local skillname, objname, linenum, req, object

    skillname = GameTooltipTextLeft2:GetText()
    objname = GameTooltipTextLeft1:GetText()

    if skillname == GatherLite:translate("mining") then
        req = GatherLite:GetRequiredLevel(objname)
    elseif skillname == GatherLite:translate("herbalism") then
        req = GatherLite:GetRequiredLevel(objname)
    elseif not skillname then
        object = GatherLite:GetObject(objname)

        if object and object.type == "ore" then
            skillname = GatherLite:translate("mining")
        end
        if object and object.type == "herb" then
            skillname = GatherLite:translate("herbalism")
        end

        if not skillname then
            return
        end

        req = object.levels
        GameTooltip:AddLine(skillname)
    else
        return
    end

    if not req then
        return
    end

    local newstr, required
    newstr = _G["GameTooltipTextLeft2"]:GetText() .. " " .. req[1]
    required = req[1]

    local skill = GatherLite:GetProfessionLevel(skillname)

    if skill then
        if skill >= req[1] then
            _G["GameTooltipTextLeft2"]:SetTextColor(1.00, 0.5, 0)
        end
        if skill >= req[2] then
            _G["GameTooltipTextLeft2"]:SetTextColor(1.00, 1.0, 0)
        end
        if skill >= req[3] then
            _G["GameTooltipTextLeft2"]:SetTextColor(0.12, 1.0, 0)
        end
        if skill >= req[4] then
            _G["GameTooltipTextLeft2"]:SetTextColor(0.62, 0.62, 0.62)
        end

        if skill < req[1] then
            _G["GameTooltipTextLeft2"]:SetTextColor(1.00, 0, 0)
        end
    end

    _G["GameTooltipTextLeft2"]:SetText(newstr)
    GameTooltip:Show()
end
