local name, _GatherLite = ...

local GFrame = LibStub("GatherLiteFrame");

local function mapTrackingOptions(target)
    local group = {
        type = "group", name = GatherLite:translate("tracking"),
        inline = true, order = 8, args = {},
    }
    for order, kind in ipairs({ "mining", "herbalism", "containers", "fishing" }) do
        local nodeType = kind
        group.args[nodeType] = {
            name = GatherLite:translate(nodeType == "fishing" and "fish" or nodeType),
            type = "toggle", order = order, width = "full",
            set = function(_, value) GatherLite:SetNodeTracking(target, nodeType, value) end,
            get = function() return GatherLite:GetNodeTracking(target, nodeType) end,
        }
    end
    return group
end

local function hudRange(key, min, max, step, order)
    return {
        name = function() return GatherLite:translate("settings.hud." .. key) end,
        type = "range", min = min, max = max, step = step, order = order, width = "full",
        set = function(_, value) GatherLite.db.char.hud[key] = value end,
        get = function() return GatherLite.db.char.hud[key] end,
    }
end

local function hudToggle(key, order, description)
    return {
        name = function() return GatherLite:translate("settings.hud." .. key) end,
        desc = description and function() return GatherLite:translate("settings.hud." .. key .. ".description") end,
        type = "toggle", order = order, width = "full",
        set = function(_, value)
            GatherLite.db.char.hud[key] = value
            GatherLite:Trigger("settings:update")
        end,
        get = function() return GatherLite.db.char.hud[key] end,
    }
end

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
        GatherLite:Trigger("settings:update")
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
                GatherLite:Trigger("settings:update")
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
        GatherLite:Trigger("settings:update")
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
                GatherLite:Trigger("settings:update")
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
        GatherLite:Trigger("settings:update")
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
                GatherLite:Trigger("settings:update")
            end,
            get = function(info)
                return not GatherLite:IsIgnored(object.id[1])
            end
        }
    end
end

_GatherLite.SettingsOptions = {
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
                        GatherLite:Trigger("settings:update")
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
                        GatherLite:Trigger("settings:update")
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
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function(info)
                        return GatherLite.db.char.worldmap.enabled;
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

            }
        },
        worldmap = {
            name = function()
                return GatherLite:translate("settings.map");
            end,
            type = "group",
            order = 2,
            args = {
                tracking = mapTrackingOptions("worldmap"),
                neighbors = {
                    name = function() return GatherLite:translate("settings.map.neighbors") end,
                    desc = function() return GatherLite:translate("settings.map.neighbors.description") end,
                    type = "toggle", order = 5, width = "full",
                    set = function(_, value)
                        GatherLite.db.char.worldmap.neighbors = value
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.worldmap.neighbors end,
                },
                zoneTooltip = {
                    name = function() return GatherLite:translate("settings.map.zone_tooltip") end,
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.worldmap.zoneTooltip = value
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.worldmap.zoneTooltip end,
                },
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
                        openMapPinZoom = {
                            name = function() return GatherLite:translate("settings.map.openmap_pin_zoom") end,
                            hidden = function() return not (OpenMapAPI and OpenMapAPI.major == 1) end,
                            type = "range", min = 1, max = 16, step = 1, order = 7, width = "full",
                            set = function(_, value) GatherLite.db.char.worldmap.openMapPinZoom = value end,
                            get = function() return GatherLite.db.char.worldmap.openMapPinZoom end,
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
                tracking = mapTrackingOptions("minimap"),
                hideNearbyNodes = {
                    name = function() return GatherLite:translate("settings.minimap.hide_nearby") end,
                    desc = function() return GatherLite:translate("settings.minimap.hide_nearby.description") end,
                    type = "toggle",
                    order = 5,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.minimap.hideNearbyNodes = value
                        if value then
                            GatherLite.db.char.minimap.nearbyCircles = false
                            GatherLite.db.char.minimap.ringMarkers = false
                        end
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.minimap.hideNearbyNodes == true end,
                },
                nearbyCircles = {
                    name = function() return GatherLite:translate("settings.minimap.nearby_circles") end,
                    desc = function() return GatherLite:translate("settings.minimap.nearby_circles.description") end,
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.minimap.nearbyCircles = value
                        if value then
                            GatherLite.db.char.minimap.hideNearbyNodes = false
                            GatherLite.db.char.minimap.ringMarkers = false
                        end
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.minimap.nearbyCircles == true end,
                },
                ringMarkers = {
                    name = function() return GatherLite:translate("settings.minimap.ring_markers") end,
                    desc = function() return GatherLite:translate("settings.minimap.ring_markers.description") end,
                    type = "toggle",
                    order = 4.5,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.minimap.ringMarkers = value
                        if value then
                            GatherLite.db.char.minimap.hideNearbyNodes = false
                            GatherLite.db.char.minimap.nearbyCircles = false
                        end
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.minimap.ringMarkers == true end,
                },
                ringDifficultyColors = {
                    name = function() return GatherLite:translate("settings.minimap.ring_difficulty") end,
                    desc = function() return GatherLite:translate("settings.minimap.ring_difficulty.description") end,
                    type = "toggle",
                    order = 4.6,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.minimap.ringDifficultyColors = value
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.minimap.ringDifficultyColors == true end,
                },
                ringShowIcon = {
                    name = function() return GatherLite:translate("settings.minimap.ring_icon") end,
                    desc = function() return GatherLite:translate("settings.minimap.ring_icon.description") end,
                    type = "toggle",
                    order = 4.7,
                    width = "full",
                    set = function(_, value)
                        GatherLite.db.char.minimap.ringShowIcon = value
                        GatherLite:Trigger("settings:update")
                    end,
                    get = function() return GatherLite.db.char.minimap.ringShowIcon ~= false end,
                },
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
                        GatherLite:Trigger("settings:update")
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
                                GatherLite:Trigger("settings:update")
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
                                local applyLayout = GatherLite.modules.Minimap and GatherLite.modules.Minimap.ApplyLayout
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "minimap" then
                                        if applyLayout then applyLayout(frame) else frame:SetSize(val, val) end
                                    end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.size
                            end
                        },
                        ringSize = {
                            name = function()
                                return GatherLite:translate("settings.minimap.ring_size");
                            end,
                            type = "range",
                            min = 8,
                            max = 40,
                            step = 1,
                            order = 5.5,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.ringSize = val;
                                local applyLayout = GatherLite.modules.Minimap and GatherLite.modules.Minimap.ApplyLayout
                                if not applyLayout then return end
                                for i, frame in ipairs(GFrame.allFrames) do
                                    if frame.type == "minimap" then applyLayout(frame) end
                                end
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.ringSize or 18
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
                            desc = function()
                                return GatherLite:translate("settings.minimap.range.description");
                            end,
                            type = "range",
                            min = 0,
                            max = 200,
                            step = 1,
                            order = 7,
                            width = "full",
                            set = function(info, val)
                                GatherLite.db.char.minimap.distance = val;
                                GatherLite:Trigger("settings:update")
                            end,
                            get = function(info)
                                return GatherLite.db.char.minimap.distance
                            end
                        }
                    }
                }
            }
        },
        hud = {
            name = function() return GatherLite:translate("settings.hud") end,
            type = "group",
            order = 4,
            args = {
                enabled = hudToggle("enabled", 1, true),
                mirrorMinimap = hudToggle("mirrorMinimap", 1.5, true),
                move = {
                    name = function() return GatherLite:translate("settings.hud.move") end,
                    type = "execute", order = 2, width = "full",
                    func = function() GatherLite.modules.HUD:ToggleMove() end,
                },
                reset = {
                    name = function() return GatherLite:translate("settings.hud.reset") end,
                    type = "execute", order = 3, width = "full",
                    func = function()
                        local options, defaults = GatherLite.db.char.hud, _GatherLite.configsDefaults.char.hud
                        options.x, options.y = defaults.x, defaults.y
                        GatherLite:Trigger("settings:update")
                    end,
                },
                range = hudRange("range", 50, 600, 25, 4),
                width = hudRange("width", 240, 700, 10, 5),
                fullWidth = hudToggle("fullWidth", 5.5),
                height = hudRange("height", 16, 48, 1, 5.75),
                pinSize = hudRange("pinSize", 8, 32, 1, 5.875),
                opacity = hudRange("opacity", 0.2, 1, 0.1, 6),
                backgroundColor = {
                    name = function() return GatherLite:translate("settings.hud.backgroundColor") end,
                    type = "execute", order = 7, width = "full",
                    func = function()
                        local picker = ColorPickerFrame
                        if not picker or not picker.SetupColorPickerAndShow then return end
                        local color = GatherLite.db.char.hud.backgroundColor
                        local r, g, b = color.r, color.g, color.b
                        local function setColor(red, green, blue)
                            color.r, color.g, color.b = red, green, blue
                            GatherLite.modules.HUD:UpdateAppearance()
                        end
                        picker:Hide()
                        picker:SetFrameStrata("FULLSCREEN_DIALOG")
                        picker:SetupColorPickerAndShow({
                            r = r, g = g, b = b,
                            swatchFunc = function() setColor(picker:GetColorRGB()) end,
                            cancelFunc = function() setColor(r, g, b) end,
                        })
                    end,
                },
                backgroundOpacity = hudRange("backgroundOpacity", 0, 1, 0.1, 7.5),
                showBorder = hudToggle("showBorder", 7.75),
                visibility = {
                    name = function() return GatherLite:translate("settings.hud.visibility") end,
                    type = "group", inline = true, order = 9,
                    args = {
                        hideInInstances = hudToggle("hideInInstances", 1),
                        hideInCombat = hudToggle("hideInCombat", 2),
                        hideOnWorldMap = hudToggle("hideOnWorldMap", 3),
                    },
                },
            }
        },
        debugging = {
            name = function()
                return GatherLite:translate("settings.debugging");
            end,
            type = "group",
            order = 6,
            args = {
                resetOnboarding = {
                    name = function() return GatherLite:translate("settings.debugging.reset_onboarding") end, type = "execute", order = 4,
                    desc = function() return GatherLite:translate("settings.debugging.reset_onboarding.description") end,
                    func = function()
                        GatherLite.db.global.controlsGuideSeen=nil
                        if _GatherLite.Window then _GatherLite.Window:ShowFirstLogin() end
                    end,
                },
                enabled = {
                    name = function() return GatherLite:translate("settings.debugging.enable") end,
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
                    name = function() return GatherLite:translate("settings.debugging") end,
                    inline = true,
                    order = 7,
                    args = {
                        nodes = {
                            name = function() return GatherLite:translate("settings.debugging.nodes") end,
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
                            name = function() return GatherLite:translate("settings.debugging.frames") end,
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
}

-- Keep the Blizzard addon-settings entry as a launcher for the custom window.
function GatherLite:RegisterSettingsLauncher()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GatherLite", {
        type = "group",
        name = "GatherLite",
        args = {
            openSettings = {
                type = "execute",
                name = GatherLite:translate("window.action.open_settings"),
                desc = "Open the GatherLite window to configure your gathering preferences.",
                order = 1,
                width = "full",
                func = function()
                    local window = _GatherLite.Window
                    if window and window:ShowSettings() and SettingsPanel then HideUIPanel(SettingsPanel) end
                end,
            },
        },
    })
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GatherLite", "GatherLite")
end
