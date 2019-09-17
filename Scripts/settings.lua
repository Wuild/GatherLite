local name, _GatherLite = ...

local needReload = false;

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

                enable = {
                    name = function()
                        return GatherLite:translate("settings.general.enable");
                    end,
                    type = "toggle",
                    order = 2,
                    set = function(info, val)
                        GatherLite.db.char.enabled = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.enabled
                    end
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
                    order = 5,
                    name = " ",
                    fontSize = "large",
                },
                debugging = {
                    name = function()
                        return GatherLite:translate("settings.general.debugging");
                    end,
                    type = "toggle",
                    order = 6,
                    set = function(info, val)
                        GatherLite.db.char.debugging = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.debugging
                    end
                },
                Spacer_2 = {
                    type = "description",
                    order = 7,
                    name = " ",
                    fontSize = "large",
                },
                Spacer_3 = {
                    type = "description",
                    order = 7,
                    name = " ",
                    fontSize = "large",
                },
                reseters = {
                    type = "group",
                    name = "Reset",
                    inline = true,
                    order = 10,
                    args = {
                        mining = {
                            type = "execute",
                            name = function()
                                return GatherLite:translate("settings.reset.mining");
                            end,
                            order = 1,
                            confirm = function()
                                return GatherLite:translate("confirm.reset");
                            end,
                            func = function()
                                GatherLite:ResetDatabaseType("mining")
                            end
                        },
                        herbalism = {
                            type = "execute",
                            name = function()
                                return GatherLite:translate("settings.reset.herbalism");
                            end,
                            order = 2,
                            confirm = function()
                                return GatherLite:translate("confirm.reset");
                            end,
                            func = function()
                                GatherLite:ResetDatabaseType("herbalism")
                            end
                        },
                        fish = {
                            type = "execute",
                            name = function()
                                return GatherLite:translate("settings.reset.fish");
                            end,
                            order = 3,
                            confirm = function()
                                return GatherLite:translate("confirm.reset");
                            end,
                            func = function()
                                GatherLite:ResetDatabaseType("fish")
                            end
                        },
                        treasure = {
                            type = "execute",
                            name = function()
                                return GatherLite:translate("settings.reset.treasure");
                            end,
                            order = 4,
                            confirm = function()
                                return GatherLite:translate("confirm.reset");
                            end,
                            func = function()
                                GatherLite:ResetDatabaseType("treasure")
                            end
                        },
                    }
                },
                reset = {
                    type = "execute",
                    name = function()
                        return GatherLite:translate("settings.reset.all");
                    end,
                    order = 11,
                    confirm = function()
                        return GatherLite:translate("confirm.reset");
                    end,
                    func = function()
                        GatherLite:ResetDatabase()
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
                enable = {
                    name = function()
                        return GatherLite:translate("settings.map.show");
                    end,
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.worldmap.enabled = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.enabled
                    end
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
                neighbors = {
                    name = function()
                        return GatherLite:translate("settings.map.neighbors");
                    end,
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.worldmap.neighbors = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.neighbors
                    end
                },
                continent = {
                    name = function()
                        return GatherLite:translate("settings.map.continent");
                    end,
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.worldmap.continent = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.continent
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
                                for i, frame in ipairs(GatherLite.frames) do
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
                                for i, frame in ipairs(GatherLite.frames) do
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
                enable = {
                    name = function()
                        return GatherLite:translate("settings.minimap.show");
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLite.db.char.minimap.enabled = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.enabled
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
                edge = {
                    name = function()
                        return GatherLite:translate("settings.minimap.edge");
                    end,
                    type = "toggle",
                    width = "full",
                    order = 4,
                    set = function(info, val)
                        GatherLite.db.char.minimap.edge = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.edge
                    end
                },
                neighbors = {
                    name = function()
                        return GatherLite:translate("settings.minimap.neighbors");
                    end,
                    type = "toggle",
                    order = 5,
                    width = "full",
                    set = function(info, val)
                        GatherLite.db.char.minimap.neighbors = val;
                        needReload = true;
                    end,
                    get = function(info)
                        return GatherLite.db.char.minimap.neighbors
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
                                for i, frame in ipairs(GatherLite.frames) do
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
                                for i, frame in ipairs(GatherLite.frames) do
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
        p2p = {
            name = function()
                return GatherLite:translate("settings.p2p");
            end,
            type = "group",
            order = 4,
            args = {
                header = {
                    name = function()
                        return GatherLite:translate("settings.p2p");
                    end,
                    type = "header",
                    width = "full",
                    order = 1,
                },
                guild = {
                    name = function()
                        return GatherLite:translate("settings.p2p.guild");
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLite.db.char.p2p.guild = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.p2p.guild
                    end
                },
                party = {
                    name = function()
                        return GatherLite:translate("settings.p2p.party");
                    end,
                    type = "toggle",
                    width = "full",
                    order = 2,
                    set = function(info, val)
                        GatherLite.db.char.p2p.party = val;
                    end,
                    get = function(info)
                        return GatherLite.db.char.p2p.party
                    end
                },

                actions = {
                    type = "group",
                    name = "Sync actions",
                    inline = true,
                    order = 10,
                    args = {
                        mining = {
                            type = "execute",
                            name = function()
                                return "Guild sync " .. GatherLite.syncedNodes.guild .. "/" .. GatherLite.totalNodes;
                            end,
                            order = 1,
                            disabled = function()
                                return GatherLite.synchronizing or not GatherLite.db.char.p2p.guild
                            end,
                            func = function()
                                GatherLite:p2pDatabase();
                            end
                        }
                    }
                }
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
                        return GatherLite:translate("settings.warning");
                    end,
                    width = "full",
                    order = 1,
                },
                reload = {
                    type = "execute",
                    name = function()
                        return GatherLite:translate("settings.reload");
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
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GatherLite", "GatherLite");