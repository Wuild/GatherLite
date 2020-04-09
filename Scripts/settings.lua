local name, _GatherLite = ...

local needReload = false;
local GFrame = LibStub("GatherLiteFrame");

LibStub("AceConfig-3.0"):RegisterOptionsTable("GatherLite", {
    type = "group",
    childGroups = "tab",
    args = {
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
                debugging = {
                    name = function()
                        return GatherLite:translate("settings.general.debugging");
                    end,
                    type = "toggle",
                    order = 4,
                    set = function(info, val)
                        GatherLite.db.char.debugging = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.debugging
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
                                GatherLite:UpdateNodes()
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
                                GatherLite:UpdateNodes()
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
                        GatherLite.db.global.predefined = val;
                        GatherLite:UpdateNodes()
                    end,
                    get = function(info)
                        return GatherLite.db.global.predefined
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
                            step = 1,
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
                            step = 1,
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
        }
    }
})
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GatherLite", "GatherLite");