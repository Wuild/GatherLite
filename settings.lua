local name, _GatherLite = ...

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("GatherLite", true)

--options interface
local OptionsPanel = AceGUI:Create("Frame");
_G["GatherLiteOptionPanel"] = OptionsPanel.frame;
table.insert(UISpecialFrames, "GatherLiteOptionPanel");

local needReload = false;

GatherLite:RegisterChatCommand("gather", "GatherSlash")
GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

LibStub("AceConfig-3.0"):RegisterOptionsTable("GatherLite", {
    type = "group",
    childGroups = "tab",
    args = {
        general = {
            name = function()
                return L["settings.general"];
            end,
            type = "group",
            order = 1,
            args = {
                header = {
                    name = function()
                        return L["settings.general"];
                    end,
                    type = "header",
                    order = 1,
                },

                enable = {
                    name = function()
                        return L["settings.general.enable"];
                    end,
                    type = "toggle",
                    order = 2,
                    set = function(info, val)
                        GatherLiteConfigCharacter.enabled = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.enabled
                    end
                },
                minimap = {
                    name = function()
                        return L["settings.general.minimap"];
                    end,
                    type = "toggle",
                    order = 3,
                    set = function(info, val)
                        GatherLiteConfigCharacter.minimapButton = val;
                        if val then
                            _GatherLite.minimap:Show();
                        else
                            _GatherLite.minimap:Hide();
                        end
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.minimapButton
                    end
                },
                Spacer_1 = {
                    type = "description",
                    order = 5,
                    name = " ",
                    fontSize = "large",
                },
                debugging = {
                    name = function()
                        return L["settings.general.debugging"];
                    end,
                    type = "toggle",
                    order = 6,
                    set = function(info, val)
                        GatherLiteConfigCharacter.debugging2 = val;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.debugging2
                    end
                },
                Spacer_2 = {
                    type = "description",
                    order = 7,
                    name = " ",
                    fontSize = "large",
                },
                reset = {
                    type = "execute",
                    name = function()
                        return L["settings.general.reset"];
                    end,
                    order = 8,
                    confirm = function()
                        return L["confirm.reset"];
                    end,
                    func = function()
                        GatherLiteGlobalSettings.database = {}
                        ReloadUI()
                    end
                }
            }
        },
        worldmap = {
            name = function()
                return L["settings.map"];
            end,
            type = "group",
            order = 2,
            args = {
                header = {
                    name = function()
                        return L["settings.map"];
                    end,
                    type = "header",
                    order = 1,
                },
                enable = {
                    name = function()
                        return L["settings.map.show"];
                    end,
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function(info, val)
                        GatherLiteConfigCharacter.showOnWorldMap = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.showOnWorldMap
                    end
                },
                loot = {
                    name = function()
                        return L["settings.map.loot"];
                    end,
                    type = "toggle",
                    order = 3,
                    width = "full",
                    set = function(info, val)
                        GatherLiteConfigCharacter.worldmapLoot = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.worldmapLoot
                    end
                },
                sliders = {
                    type = "group",
                    name = "",
                    inline = true,
                    order = 4,
                    args = {
                        iconSize = {
                            name = function()
                                return L["settings.map.size"];
                            end,
                            type = "range",
                            min = 4,
                            max = 30,
                            step = 1,
                            order = 5,
                            width = "full",
                            set = function(info, val)
                                GatherLiteConfigCharacter.worldmapIconSize = val;
                                for k, node in ipairs(_GatherLite.nodes.worldmap) do
                                    node.frame:SetSize(val, val)
                                end
                            end,
                            get = function(info)
                                return GatherLiteConfigCharacter.worldmapIconSize
                            end
                        },
                        iconOpacity = {
                            name = function()
                                return L["settings.map.opacity"];
                            end,
                            type = "range",
                            min = 0.1,
                            step = 0.1,
                            max = 1.0,
                            order = 6,
                            width = "full",
                            set = function(info, val)
                                for k, node in ipairs(_GatherLite.nodes.worldmap) do
                                    node.frame:SetAlpha(val)
                                end
                                GatherLiteConfigCharacter.worldmapOpacity = val;
                            end,
                            get = function(info)
                                return GatherLiteConfigCharacter.worldmapOpacity
                            end
                        }
                    }
                }
            }
        },
        minimap = {
            name = function()
                return L["settings.minimap"];
            end,
            type = "group",
            order = 3,
            args = {
                header = {
                    name = function()
                        return L["settings.minimap"];
                    end,
                    type = "header",
                    width = "full",
                    order = 1,
                },
                enable = {
                    name = function()
                        return L["settings.minimap.show"];
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLiteConfigCharacter.showOnMinimap = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.showOnMinimap
                    end
                },
                loot = {
                    name = function()
                        return L["settings.minimap.loot"];
                    end,
                    type = "toggle",
                    order = 3,
                    width = "full",
                    set = function(info, val)
                        GatherLiteConfigCharacter.minimapLoot = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.minimapLoot
                    end
                },
                edge = {
                    name = function()
                        return L["settings.minimap.edge"];
                    end,
                    type = "toggle",
                    width = "full",
                    order = 4,
                    set = function(info, val)
                        GatherLiteConfigCharacter.minimapEdge = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.minimapEdge
                    end
                },
                sliders = {
                    type = "group",
                    name = "",
                    inline = true,
                    order = 5,
                    args = {
                        iconSize = {
                            name = function()
                                return L["settings.minimap.size"];
                            end,
                            type = "range",
                            min = 4,
                            max = 30,
                            step = 1,
                            order = 5,
                            width = "full",
                            set = function(info, val)
                                --MyAddon.enabled = val
                                GatherLiteConfigCharacter.minimapIconSize = val;
                                for k, node in ipairs(_GatherLite.nodes.minimap) do
                                    node.frame:SetSize(val, val)
                                end
                            end,
                            get = function(info)
                                return GatherLiteConfigCharacter.minimapIconSize
                                --return MyAddon.enabled
                            end
                        },
                        iconOpacity = {
                            name = function()
                                return L["settings.minimap.opacity"];
                            end,
                            type = "range",
                            min = 0.1,
                            step = 0.1,
                            max = 1.0,
                            order = 6,
                            width = "full",
                            set = function(info, val)
                                GatherLiteConfigCharacter.minimapOpacity = val;
                                for k, node in ipairs(_GatherLite.nodes.minimap) do
                                    node.frame:SetAlpha(val)
                                end
                            end,
                            get = function(info)
                                return GatherLiteConfigCharacter.minimapOpacity
                            end
                        },
                        iconRange = {
                            name = function()
                                return L["settings.minimap.range"];
                            end,
                            type = "range",
                            min = 0,
                            max = 200,
                            step = 1,
                            order = 7,
                            width = "full",
                            set = function(info, val)
                                GatherLiteConfigCharacter.minimapHideDistance = val;
                            end,
                            get = function(info)
                                return GatherLiteConfigCharacter.minimapHideDistance
                            end
                        }
                    }
                }
            }
        },
        p2p = {
            name = function()
                return L["settings.p2p"];
            end,
            type = "group",
            order = 4,
            args = {
                header = {
                    name = function()
                        return L["settings.p2p"];
                    end,
                    type = "header",
                    width = "full",
                    order = 1,
                },
                guild = {
                    name = function()
                        return L["settings.p2p.guild"];
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLiteConfigCharacter.shareGuild = val;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.shareGuild
                    end
                },
                party = {
                    name = function()
                        return L["settings.p2p.party"];
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLiteConfigCharacter.shareParty = val;
                    end,
                    get = function(info)
                        return GatherLiteConfigCharacter.shareParty
                    end
                },
            }
        },
        actions = {
            type = "group",
            name = " ",
            inline = true,
            order = 6,
            args = {
                description = {
                    type = "description",
                    name = function()
                        return L["settings.warning"];
                    end,
                    width = "full",
                    order = 1,
                },
                reload = {
                    type = "execute",
                    name = function()
                        return L["settings.reload"];
                    end,
                    order = 3,
                    hidden = function()
                        if needReload then
                            return false
                        else
                            return true;
                        end
                    end,
                    func = function()
                        ReloadUI()
                    end
                }
            }
        }
    }
})
configFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GatherLite", "GatherLite");

function GatherLite:ShowSettings()
    LibStub("AceConfigDialog-3.0"):Open("GatherLite", OptionsPanel)
end

-----------------------------------------------------------------------------------------------------------------------------------
-- MINI MAP
-----------------------------------------------------------------------------------------------------------------------------------
_GatherLite.minimap = CreateFrame("Button", "GatherLite_MinimapButton", Minimap);
_GatherLite.minimap:EnableMouse(true);
_GatherLite.minimap:SetMovable(true);
_GatherLite.minimap:SetSize(33, 33);
_GatherLite.minimap:SetPoint("TOPLEFT");
_GatherLite.minimap:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
_GatherLite.minimap:RegisterForClicks("LeftButtonUp", "RightButtonUp");
_GatherLite.minimap:RegisterForDrag("LeftButton");

local t = _GatherLite.minimap:CreateTexture(nil, "OVERLAY");
t:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
t:SetSize(56, 56);
t:SetPoint("TOPLEFT");

local t = _GatherLite.minimap:CreateTexture(nil, "background");
t:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
t:SetSize(21, 21);
t:SetPoint("CENTER");

_GatherLite.minimapFrame = CreateFrame("FRAME", nil, _GatherLite.minimap);
_GatherLite.minimapFrame:SetScript("OnUpdate", function()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70 -- get coordinates as differences from the center of the minimap
    ypos = ypos / UIParent:GetScale() - ymin - 70

    GatherLiteConfigCharacter.MiniMapPosition = math.deg(math.atan2(ypos, xpos))
    GatherLite:updateMiniMapPosition()
end);
_GatherLite.minimapFrame:Hide();

_GatherLite.minimap:SetScript("OnDragStart", function(self)
    self:LockHighlight();
    _GatherLite.minimapFrame:Show();
    _GatherLite.tooltip:Hide();
end);

_GatherLite.minimap:SetScript("OnDragStop", function(self)
    self:UnlockHighlight();
    _GatherLite.minimapFrame:Hide();
    if (_GatherLite.showingTooltip) then
        _GatherLite.tooltip:Show();
    end ;
end);

_GatherLite.minimap:SetScript("OnEnter", function()
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:SetOwner(_GatherLite.minimap, "ANCHOR_LEFT");
    _GatherLite.tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");

    _GatherLite.tooltip:AddDoubleLine(GatherLite:Colorize(L['mining'], "white"), GatherLite:tablelength(GatherLiteGlobalSettings.database.mining));
    --    _GatherLite.tooltip:AddTexture(GetItemIcon(2770), { width = 14, height = 14 })

    _GatherLite.tooltip:AddDoubleLine(GatherLite:Colorize(L['herbalism'], "white"), GatherLite:tablelength(GatherLiteGlobalSettings.database.herbalism));
    --    _GatherLite.tooltip:AddTexture(GetItemIcon(765), { width = 14, height = 14 })

    if not _GatherLite.isClassic then
        _GatherLite.tooltip:AddDoubleLine(GatherLite:Colorize(L['archaeology'], "white"), GatherLite:tablelength(GatherLiteGlobalSettings.database.artifacts));
        --        _GatherLite.tooltip:AddTexture(GetItemIcon(1195), { width = 14, height = 14 })
    end ;
    _GatherLite.tooltip:AddDoubleLine(GatherLite:Colorize(L['fish'], "white"), GatherLite:tablelength(GatherLiteGlobalSettings.database.fish));
    --    _GatherLite.tooltip:AddTexture(GetItemIcon(6303), { width = 14, height = 14 })

    _GatherLite.tooltip:AddDoubleLine(GatherLite:Colorize(L['treasures'], "white"), GatherLite:tablelength(GatherLiteGlobalSettings.database.treasure));
    --    _GatherLite.tooltip:AddTexture(132594, { width = 14, height = 14 })

    _GatherLite.tooltip:Show();
    _GatherLite.showingTooltip = true;
end);

_GatherLite.minimap:SetScript("OnLeave", function()
    _GatherLite.tooltip:Hide()
end);

_GatherLite.minimap:SetScript("OnClick", function(self, button)
    if (button == "LeftButton") then
        local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(dropDown, MinimapContextMenu, "MENU")
        ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
    else
        if not OptionsPanel:IsShown() then
            PlaySound(882);
            LibStub("AceConfigDialog-3.0"):Open("GatherLite", OptionsPanel)
        else
            OptionsPanel:Hide();
        end
    end
end);

function GatherLite:updateMiniMapPosition()
    _GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
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
            text = _GatherLite.name,
            isTitle = true,
            notCheckable = true
        });

        addContextItem({
            text = L['mining'],
            icon = GetItemIcon(2770),
            checked = GatherLiteConfigCharacter.mining,
            callback = function()
                if GatherLiteConfigCharacter.mining then
                    GatherLiteConfigCharacter.mining = false;
                else
                    GatherLiteConfigCharacter.mining = true;
                end ;

                _GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = L['herbalism'],
            icon = GetItemIcon(765),
            checked = GatherLiteConfigCharacter.herbalism,
            callback = function()
                if GatherLiteConfigCharacter.herbalism then
                    GatherLiteConfigCharacter.herbalism = false;
                else
                    GatherLiteConfigCharacter.herbalism = true;
                end ;
                _GatherLite.needMapUpdate = true;
            end
        })

        if not _GatherLite.isClassic then
            addContextItem({
                text = L['archaeology'],
                icon = 134435,
                checked = GatherLiteConfigCharacter.artifacts,
                callback = function()
                    if GatherLiteConfigCharacter.artifacts then
                        GatherLiteConfigCharacter.artifacts = false;
                    else
                        GatherLiteConfigCharacter.artifacts = true;
                    end ;
                    _GatherLite.needMapUpdate = true;
                end
            })
        end

        addContextItem({
            text = L['fish'],
            icon = GetItemIcon(6303),
            checked = GatherLiteConfigCharacter.fish,
            callback = function()
                if GatherLiteConfigCharacter.fish then
                    GatherLiteConfigCharacter.fish = false;
                else
                    GatherLiteConfigCharacter.fish = true;
                end ;
                _GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = L['treasures'],
            icon = 132594,
            checked = GatherLiteConfigCharacter.treasure,
            callback = function()
                if GatherLiteConfigCharacter.treasure then
                    GatherLiteConfigCharacter.treasure = false;
                else
                    GatherLiteConfigCharacter.treasure = true;
                end ;
                _GatherLite.needMapUpdate = true;
            end
        })
    end
end