local name, _GatherLite = ...;

local GFrame = LibStub("GatherLiteFrame");
local HBD = LibStub("HereBeDragons-2.0");

local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(dropDown, GatherLite:MinimapContextMenu(), "MENU")

local minimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("GatherLiteMinimapIcon", {
    type = "data source",
    text = "Gatherlite",
    icon = "Interface\\Icons\\inv_misc_spyglass_02",

    OnClick = function(self, button)
        if button == "LeftButton" then
            ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
        elseif button == "RightButton" then
            CloseDropDownMenus(1)
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

            local function minimapFilter(node)
                if not GatherLite.db.char.minimap.enabled then
                    return false
                end
                if not GatherLite.db.char.tracking[node.type] then
                    return false
                end
                if node.predefined and not GatherLite.db.global.usePredefined then
                    return false
                end
                if GatherLite:IsIgnored(node.object) then
                    return false
                end
                return true
            end

            local worldX, worldY, instanceID = HBD:GetPlayerWorldPosition()
            local zoneX, zoneY, mapID = HBD:GetPlayerZonePosition()
            local range = GatherLite.db.char.minimap.range
            local types = { "mining", "herbalism", "containers", "fishing" }
            local totalInRange = 0

            if worldX and worldY and instanceID and zoneX and zoneY and mapID then
                for i = 1, #types do
                    local type = types[i]
                    local nodes = GatherLite:GetNearbyNodes(type, mapID, instanceID, zoneX, zoneY, range)
                    local count = 0
                    for j = 1, #nodes do
                        local node = nodes[j]
                        if node.instance == instanceID and minimapFilter(node) then
                            if not node.worldX or not node.worldY then
                                GatherLite:EnsureNodeWorld(node)
                            end
                            local _, distance = HBD:GetWorldVector(instanceID, worldX, worldY, node.worldX, node.worldY)
                            if distance and distance < range then
                                count = count + 1
                            end
                        end
                    end
                    totalInRange = totalInRange + count
                    tooltip:AddDoubleLine(GatherLite:Colorize("In range " .. type, "white"), count)
                end
                tooltip:AddDoubleLine(GatherLite:Colorize("In range total", "white"), totalInRange)
            else
                tooltip:AddDoubleLine(GatherLite:Colorize("In range total", "white"), "n/a")
            end

            local stats = GatherLite:GetNodeIndexStats()
            for i = 1, #types do
                local type = types[i]
                local stat = stats[type]
                if stat then
                    tooltip:AddLine(" ");
                    tooltip:AddLine(GatherLite:Colorize("Index " .. type, "white"))
                    tooltip:AddDoubleLine("Nodes", stat.nodes)
                    tooltip:AddDoubleLine("Map buckets", stat.byMap)
                    tooltip:AddDoubleLine("Cell buckets", stat.byCell)
                    tooltip:AddDoubleLine("Map/instance", stat.byMapInstance)
                    tooltip:AddDoubleLine("Instance buckets", stat.instanceBuckets)
                    tooltip:AddDoubleLine("Cache maps", stat.cacheMaps)
                    tooltip:AddDoubleLine("Cache instances", stat.cacheInstances)
                end
            end

            local debug = GatherLite.minimapDebug
            if debug then
                local now = GetTime()
                tooltip:AddLine(" ");
                tooltip:AddLine(GatherLite:Colorize("Minimap timing", "white"))
                if debug.lastForceUpdate and debug.lastForceUpdate > 0 then
                    tooltip:AddDoubleLine("Last force", string.format("%.1fs", now - debug.lastForceUpdate))
                end
                if debug.lastNodesUpdate and debug.lastNodesUpdate > 0 then
                    tooltip:AddDoubleLine("Last nodes", string.format("%.1fs", now - debug.lastNodesUpdate))
                end
                if debug.lastIconsUpdate and debug.lastIconsUpdate > 0 then
                    tooltip:AddDoubleLine("Last icons", string.format("%.1fs", now - debug.lastIconsUpdate))
                end
                tooltip:AddDoubleLine("Nodes tick", string.format("%.2fs", debug.lastNodesTick or 0))
                tooltip:AddDoubleLine("Icons tick", string.format("%.2fs", debug.lastIconsTick or 0))
            end
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
    GatherLite:RegisterEvent("PLAYER_LOGIN", "EventHandler")
    GatherLite:RegisterEvent("ZONE_CHANGED", "EventHandler")

    GameTooltip:HookScript("OnShow", GatherLite.ModifyTooltip)
    GameTooltip:HookScript("OnUpdate", GatherLite.ModifyTooltip)

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 10)
end

function GatherLite.ModifyTooltip()

    local lines = GameTooltip:NumLines();

    for i = 1, lines do
        local skillname, objname, linenum, req, object
        skillname = _G['GameTooltipTextLeft' .. i]:GetText()

        if skillname == GatherLite:translate("mining") then
            objname = _G['GameTooltipTextLeft' .. (i - 1)]:GetText()
            req = GatherLite:GetRequiredLevel(objname)
        elseif skillname == GatherLite:translate("herbalism") then
            objname = _G['GameTooltipTextLeft' .. (i - 1)]:GetText()
            req = GatherLite:GetRequiredLevel(objname)
        elseif not skillname then
            objname = _G['GameTooltipTextLeft' .. (i - 1)]:GetText()
            object = GatherLite:GetObject(objname)

            if object and object.type == "ore" then
                skillname = GatherLite:translate("mining")
            end
            if object and object.type == "herb" then
                skillname = GatherLite:translate("herbalism")
            end

            if skillname then
                req = object.levels
                GameTooltip:AddLine(skillname)
            end
        end

        if req then
            local newstr, required
            newstr = _G['GameTooltipTextLeft' .. i]:GetText() .. " " .. req[1]
            required = req[1]

            local skill = GatherLite:GetProfessionLevel(skillname)

            if skill then
                if skill >= req[1] then
                    _G['GameTooltipTextLeft' .. i]:SetTextColor(1.00, 0.5, 0)
                end
                if skill >= req[2] then
                    _G['GameTooltipTextLeft' .. i]:SetTextColor(1.00, 1.0, 0)
                end
                if skill >= req[3] then
                    _G['GameTooltipTextLeft' .. i]:SetTextColor(0.12, 1.0, 0)
                end
                if skill >= req[4] then
                    _G['GameTooltipTextLeft' .. i]:SetTextColor(0.62, 0.62, 0.62)
                end

                if skill < req[1] then
                    _G['GameTooltipTextLeft' .. i]:SetTextColor(1.00, 0, 0)
                end
            end

            _G['GameTooltipTextLeft' .. i]:SetText(newstr)
        end
    end

    --GameTooltip:Show()
end
