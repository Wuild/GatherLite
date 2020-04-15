local name, _GatherLite = ...

local needReload = false;
local GFrame = LibStub("GatherLiteFrame");

local tracking = {
    header = {
        name = function()
            return "Mining";
        end,
        type = "header",
        order = 0,
    }
}

local function checkIgnore(table)
    local isIgnored = false;

    for name, id in pairs(table) do
        isIgnored = table[name];
    end
    return isIgnored
end

--tracking["toggleOres"] = {
--    name = function()
--        return "Toggle all ores";
--    end,
--    type = "toggle",
--    width = "full",
--    order = 0,
--    set = function(info, val)
--        if checkIgnore(GatherLite.db.char.ignoreOres) then
--            for name, id in pairs(GatherLite.db.char.ignoreOres) do
--                GatherLite.db.char.ignoreOres[name] = false
--            end
--        else
--            for name, id in pairs(GatherLite.db.char.ignoreOres) do
--                GatherLite.db.char.ignoreOres[name] = true
--            end
--        end
--
--        GatherLite:LoadMinimap()
--    end,
--    get = function(info)
--        return not checkIgnore(GatherLite.db.char.ignoreOres)
--    end
--}

for name, id in pairs(_GatherLite.ores) do
    tracking["node_" .. id] = {
        name = function()
            return name;
        end,
        type = "toggle",
        order = 2,
        set = function(info, val)
            GatherLite.db.char.ignoreOres[id] = not GatherLite.db.char.ignoreOres[id]
            GatherLite:LoadMinimap()
        end,
        get = function(info)
            return not GatherLite.db.char.ignoreOres[id]
        end
    }
end

tracking["header2"] = {
    name = function()
        return "Herbalism";
    end,
    type = "header",
    order = 3,
}

--tracking["toggleHerbs"] = {
--    name = function()
--        return "Toggle all herbs";
--    end,
--    type = "toggle",
--    width = "full",
--    order = 3,
--    set = function(info, val)
--        if checkIgnore(GatherLite.db.char.ignoreHerbs) then
--            for name, id in pairs(GatherLite.db.char.ignoreHerbs) do
--                GatherLite.db.char.ignoreHerbs[name] = false
--            end
--        else
--            for name, id in pairs(GatherLite.db.char.ignoreHerbs) do
--                GatherLite.db.char.ignoreHerbs[name] = true
--            end
--        end
--
--        GatherLite:LoadMinimap()
--    end,
--    get = function(info)
--        return not checkIgnore(GatherLite.db.char.ignoreHerbs)
--    end
--}

for name, id in pairs(_GatherLite.herbs) do
    tracking["node_" .. id] = {
        name = function()
            return name;
        end,
        type = "toggle",
        order = 4,
        set = function(info, val)
            GatherLite.db.char.ignoreHerbs[id] = not GatherLite.db.char.ignoreHerbs[id]
            GatherLite:LoadMinimap()
        end,
        get = function(info)
            return not GatherLite.db.char.ignoreHerbs[id]
        end
    }
end

LibStub("AceConfig-3.0"):RegisterOptionsTable("GatherLite", {
    type = "group",
    childGroups = "tab",
    args = {
        tracking = {
            name = function()
                return "Tracking";
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
                header = {
                    name = function()
                        return GatherLite:translate("settings.general");
                    end,
                    type = "header",
                    order = 1,
                },
                minimap = {
                    name = function()
                        return GatherLite:translate("settings.general.minimap");
                    end,
                    type = "toggle",
                    order = 3,
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
                    order = 6,
                    name = " ",
                    fontSize = "large",
                },
                tracking = {
                    type = "group",
                    name = GatherLite:translate('tracking'),
                    inline = true,
                    order = 7,
                    args = {
                        mining = {
                            name = function()
                                return GatherLite:translate('mining');
                            end,
                            type = "toggle",
                            order = 1,
                            set = function(info, val)
                                GatherLite.db.char.tracking.mining = val;
                                GatherLite:LoadMinimap()
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.mining
                            end,
                            width = "half"
                        },
                        herbalism = {
                            name = function()
                                return GatherLite:translate('herbalism');
                            end,
                            type = "toggle",
                            order = 2,
                            set = function(info, val)
                                GatherLite.db.char.tracking.herbalism = val;
                                GatherLite:LoadMinimap()
                            end,
                            get = function(info)
                                return GatherLite.db.char.tracking.herbalism
                            end,
                            width = "half"
                        }
                    }
                },
                Spacer_2 = {
                    type = "description",
                    order = 8,
                    name = " ",
                    fontSize = "large",
                },
                predefined = {
                    name = function()
                        return GatherLite:translate("settings.general.predefined");
                    end,
                    type = "toggle",
                    order = 10,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.global.usePredefined = val;
                    end,
                    get = function(info)
                        return GatherLite.db.global.usePredefined
                    end
                },
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
                                --MyAddon.enabled = val
                                GatherLite.db.char.minimap.size = val;
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "minimap" then
                                        frame:SetSize(val, val)
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.size
                                --return MyAddon.enabled
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