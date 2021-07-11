local name, _GatherLite = ...

local needReload = false;
local GFrame = LibStub("GatherLiteFrame");

local tracking = {
    header = {
        name = function()
            return GatherLite:translate("mining");
        end,
        type = "header",
        order = 0,
    }
}

local function checkAllIgnored(type)
    local ignored = false
    for index, object in pairs(_GatherLite.nodeDB) do
        if object.type == type and GatherLite:IsIgnored(object.id[1]) then
            ignored = true
        end
    end
    return ignored
end

tracking["toggleOres"] = {
    name = function()
        return GatherLite:translate("settings.tracking.toggle_all_ores");
    end,
    type = "toggle",
    width = "full",
    order = 0,
    set = function(info, val)

        local ignored = checkAllIgnored("ore")

        for index, object in pairs(_GatherLite.nodeDB) do
            if object.type == "ore" then
                GatherLite:SetIgnored(object, not ignored)
            end
        end
        GatherLite:ResetMinimap();
        GatherLite:ResetWorldmap();
    end,
    get = function(info)
        return not checkAllIgnored("ore")
    end
}

for index, object in pairs(_GatherLite.nodeDB) do
    if object.type == "ore" then
        tracking["node_" .. index] = {
            name = function()
                return GatherLite:translate("node." .. object.name);
            end,
            type = "toggle",
            order = 2,
            set = function(info, val)
                GatherLite:SetIgnored(object, not GatherLite:IsIgnored(object.id[1]))
                GatherLite:ResetMinimap();
                GatherLite:ResetWorldmap();
            end,
            get = function(info)
                return not GatherLite:IsIgnored(object.id[1])
            end
        }
    end
end

tracking["header2"] = {
    name = function()
        return GatherLite:translate("herbalism");
    end,
    type = "header",
    order = 3,
}

tracking["toggleHerbs"] = {
    name = function()
        return GatherLite:translate("settings.tracking.toggle_all_herbs");
    end,
    type = "toggle",
    width = "full",
    order = 4,
    set = function(info, val)

        local ignored = checkAllIgnored("herb")

        for index, object in pairs(_GatherLite.nodeDB) do
            if object.type == "herb" then
                GatherLite:SetIgnored(object, not ignored)
            end
        end
        GatherLite:ResetMinimap();
        GatherLite:ResetWorldmap();
    end,
    get = function(info)
        return not checkAllIgnored("herb")
    end
}

for index, object in pairs(_GatherLite.nodeDB) do
    if object.type == "herb" then
        tracking["node_" .. index] = {
            name = function()
                return GatherLite:translate("node." .. object.name);
            end,
            type = "toggle",
            order = 5,
            set = function(info, val)
                GatherLite:SetIgnored(object, not GatherLite:IsIgnored(object.id[1]))
                GatherLite:ResetMinimap();
                GatherLite:ResetWorldmap();
            end,
            get = function(info)
                return not GatherLite:IsIgnored(object.id[1])
            end
        }
    end
end

tracking["header3"] = {
    name = function()
        return GatherLite:translate("containers");
    end,
    type = "header",
    order = 6,
}

tracking["toggleContainers"] = {
    name = function()
        return GatherLite:translate("settings.tracking.toggle_all_containers");
    end,
    type = "toggle",
    width = "full",
    order = 7,
    set = function(info, val)

        local ignored = checkAllIgnored("container")

        for index, object in pairs(_GatherLite.nodeDB) do
            if object.type == "container" then
                GatherLite:SetIgnored(object, not ignored)
            end
        end
        GatherLite:ResetMinimap();
        GatherLite:ResetWorldmap();
    end,
    get = function(info)
        return not checkAllIgnored("container")
    end
}

for index, object in pairs(_GatherLite.nodeDB) do
    if object.type == "container" then
        tracking["node_" .. index] = {
            name = function()
                return GatherLite:translate("node." .. object.name);
            end,
            type = "toggle",
            order = 8,
            set = function(info, val)
                GatherLite:SetIgnored(object, not GatherLite:IsIgnored(object.id[1]))
                GatherLite:ResetMinimap();
                GatherLite:ResetWorldmap();
            end,
            get = function(info)
                return not GatherLite:IsIgnored(object.id[1])
            end
        }
    end
end

LibStub("AceConfig-3.0"):RegisterOptionsTable("GatherLite", {
    type = "group",
    childGroups = "tab",
    args = {
        tracking = {
            name = function()
                return GatherLite:translate("settings.tracking");
            end,
            type = "group",
            order = 1,
            args = tracking
        },
        general = {
            name = function()
                return GatherLite:translate("settings.general");
            end,
            type = "group",
            order = 1,
            args = {

                nodeheader = {
                    name = function()
                        return GatherLite:translate("settings.node");
                    end,
                    type = "header",
                    order = 1,
                },

                predefined = {
                    name = function()
                        return GatherLite:translate("settings.node.predefined");
                    end,
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.global.usePredefined = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLite.db.global.usePredefined
                    end
                },

                nodeMinimap = {
                    name = function()
                        return GatherLite:translate("settings.node.minimap");
                    end,
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.minimap.enabled = val;
                        GatherLite:ResetMinimap();
                        GatherLite:ResetWorldmap();
                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.enabled;
                    end
                },

                nodeWorldmap = {
                    name = function()
                        return GatherLite:translate("settings.node.worldmap");
                    end,
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.worldmap.enabled = val;
                        GatherLite:ResetMinimap();
                        GatherLite:ResetWorldmap();
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.enabled;
                    end
                },

                reloadUI = {
                    name = function()
                        return "reload ui";
                    end,
                    type = "execute",
                    order = 4,
                    hidden = function()
                        return not needReload
                    end,
                    func = function()
                        ReloadUI();
                    end
                },

                header = {
                    name = function()
                        return GatherLite:translate("settings.general");
                    end,
                    type = "header",
                    order = 5,
                },
                minimap = {
                    name = function()
                        return GatherLite:translate("settings.general.minimap");
                    end,
                    type = "toggle",
                    order = 6,
                    set = function(info, val)
                        GatherLite.db.profile.minimap.hide = not val;
                        if GatherLite.db.profile.minimap.hide then
                            GatherLite.minimap:Hide("GatherLiteMinimapIcon");
                        else
                            GatherLite.minimap:Show("GatherLiteMinimapIcon");
                        end
                    end,
                    get = function(info)
                        return not GatherLite.db.profile.minimap.hide
                    end
                },
                Spacer_1 = {
                    type = "description",
                    order = 7,
                    name = " ",
                    fontSize = "large",
                },
                tracking = {
                    type = "group",
                    name = GatherLite:translate('tracking'),
                    inline = true,
                    order = 8,
                    args = {
                        mining = {
                            name = function()
                                return GatherLite:translate('mining');
                            end,
                            type = "toggle",
                            order = 1,

                            set = function(info, val)
                                GatherLite.db.char.tracking.mining = val;
                                GatherLite:ResetMinimap();
                                GatherLite:ResetWorldmap();
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.mining
                            end,
                            width = "full",
                        },
                        herbalism = {
                            name = function()
                                return GatherLite:translate('herbalism');
                            end,
                            type = "toggle",
                            order = 2,
                            set = function(info, val)
                                GatherLite.db.char.tracking.herbalism = val;
                                GatherLite:ResetMinimap();
                                GatherLite:ResetWorldmap();
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.herbalism
                            end,
                            width = "full",
                        },
                        containers = {
                            name = function()
                                return GatherLite:translate('containers');
                            end,
                            type = "toggle",
                            order = 2,
                            set = function(info, val)
                                GatherLite.db.char.tracking.containers = val;
                                GatherLite:ResetMinimap();
                                GatherLite:ResetWorldmap();
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.containers
                            end,
                            width = "full",
                        },
                        fishing = {
                            name = function()
                                return GatherLite:translate('fish');
                            end,
                            type = "toggle",
                            order = 2,
                            set = function(info, val)
                                GatherLite.db.char.tracking.fishing = val;
                                GatherLite:ResetMinimap();
                                GatherLite:ResetWorldmap();
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.fishing
                            end,
                            width = "full",
                        }
                    }
                }
            }
        },
        worldmap = {
            name = function()
                return GatherLite:translate("settings.map");
            end,
            type = "group",
            order = 2,
            args = {
                header = {
                    name = function()
                        return GatherLite:translate("settings.map");
                    end,
                    type = "header",
                    order = 1,
                },
                loot = {
                    name = function()
                        return GatherLite:translate("settings.map.loot");
                    end,
                    type = "toggle",
                    order = 3,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.worldmap.loot = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.loot
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
                                return GatherLite:translate("settings.map.size");
                            end,
                            type = "range",
                            min = 4,
                            max = 30,
                            step = .1,
                            order = 5,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.worldmap.size = val;
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "worldmap" then
                                        frame:SetSize(val, val)
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.worldmap.size
                            end
                        },
                        iconOpacity = {
                            name = function()
                                return GatherLite:translate("settings.map.opacity");
                            end,
                            type = "range",
                            min = 0.1,
                            step = 0.1,
                            max = 1.0,
                            order = 6,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.worldmap.opacity = val;
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "worldmap" then
                                        frame:SetAlpha(val)
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.worldmap.opacity
                            end
                        }
                    }
                }
            }
        },
        minimap = {
            name = function()
                return GatherLite:translate("settings.minimap");
            end,
            type = "group",
            order = 3,
            args = {
                header = {
                    name = function()
                        return GatherLite:translate("settings.minimap");
                    end,
                    type = "header",
                    width = "full",
                    order = 1,
                },
                edge = {
                    name = function()
                        return GatherLite:translate("settings.minimap.edge");
                    end,
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.minimap.edge = val;

                        GatherLite:ResetMinimap()

                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.edge
                    end
                },
                loot = {
                    name = function()
                        return GatherLite:translate("settings.minimap.loot");
                    end,
                    type = "toggle",
                    order = 3,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.minimap.loot = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.loot
                    end
                },
                sliders = {
                    type = "group",
                    name = "",
                    inline = true,
                    order = 6,
                    args = {
                        nodeRange = {
                            name = function()
                                return GatherLite:translate("settings.minimap.threshold", GatherLite.db.char.minimap.range);
                            end,
                            type = "range",
                            min = 200,
                            max = 1000,
                            step = 1,
                            order = 4,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.range = val;
                                GatherLite:ResetMinimap()
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.range
                            end
                        },
                        iconSize = {
                            name = function()
                                return GatherLite:translate("settings.minimap.size");
                            end,
                            type = "range",
                            min = 4,
                            max = 30,
                            step = .1,
                            order = 5,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.size = val;
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "minimap" then
                                        frame:SetSize(val, val)
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.size
                            end
                        },
                        iconOpacity = {
                            name = function()
                                return GatherLite:translate("settings.minimap.opacity");
                            end,
                            type = "range",
                            min = 0.1,
                            step = 0.1,
                            max = 1.0,
                            order = 6,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.opacity = val;
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "minimap" then
                                        frame:SetAlpha(val)
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.opacity
                            end
                        },
                        iconRange = {
                            name = function()
                                return GatherLite:translate("settings.minimap.range", GatherLite.db.char.minimap.distance);
                            end,
                            type = "range",
                            min = 0,
                            max = 200,
                            step = 1,
                            order = 7,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.distance = val;
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.distance
                            end
                        }
                    }
                }
            }
        },
        debugging = {
            name = function()
                return GatherLite:translate("settings.debugging");
            end,
            type = "group",
            order = 6,
            args = {
                enabled = {
                    name = function()
                        return "Enable debugging"
                    end,
                    type = "toggle",
                    order = 3,
                    set = function(info, val)
                        GatherLite.db.global.debug.enabled = val;
                    end,
                    get = function(info)
                        return GatherLite.db.global.debug.enabled
                    end
                },

                debugging = {
                    type = "group",
                    name = "Debugging",
                    inline = true,
                    order = 7,
                    args = {
                        nodes = {
                            name = function()
                                return "Nodes"
                            end,
                            type = "toggle",
                            order = 3,
                            set = function(info, val)
                                GatherLite.db.global.debug.types[_GatherLite.DEBUG_NODE] = val;
                            end,
                            get = function(info)
                                return GatherLite.db.global.debug.types[_GatherLite.DEBUG_NODE]
                            end
                        },
                        frames = {
                            name = function()
                                return "Frames"
                            end,
                            type = "toggle",
                            order = 3,
                            set = function(info, val)
                                GatherLite.db.global.debug.types[_GatherLite.DEBUG_FRAME] = val;
                            end,
                            get = function(info)
                                return GatherLite.db.global.debug.types[_GatherLite.DEBUG_FRAME]
                            end
                        },
                        p2p = {
                            name = function()
                                return "p2p"
                            end,
                            type = "toggle",
                            order = 3,
                            set = function(info, val)
                                GatherLite.db.global.debug.types[_GatherLite.DEBUG_P2P] = val;
                            end,
                            get = function(info)
                                return GatherLite.db.global.debug.types[_GatherLite.DEBUG_P2P]
                            end
                        },
                    }
                },
            }
        },
    }
})
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GatherLite", "GatherLite");
