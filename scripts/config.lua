local name, _GatherLite = ...;
local events = {};

GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")

GatherLite.modules = {}
GatherLite.plugins = {}

function GatherLite:On(event, callback, runFirst)
    if not events[event] then
        events[event] = {}
    end

    -- Data preparation must finish before map listeners redraw their pins.
    if runFirst then
        table.insert(events[event], 1, callback)
    else
        table.insert(events[event], callback)
    end
end

function GatherLite:Trigger(event, ...)
    if events[event] then
        for key = 1, GatherLite:tablelength(events[event]) do
            events[event][key](...);
        end
    end
end

_GatherLite.name = name;
_GatherLite.version = C_AddOns.GetAddOnMetadata(name, "version");
_GatherLite.supportLabel = "Patreon";
_GatherLite.supportUrl = "https://www.patreon.com/c/Wuild";
_GatherLite.DEBUG_DEFAULT = 1;
_GatherLite.DEBUG_NODE = 2;
_GatherLite.DEBUG_FRAME = 3;
_GatherLite.DEBUG_P2P = 4;

_GatherLite.debug = {
    [_GatherLite.DEBUG_DEFAULT] = "default",
    [_GatherLite.DEBUG_NODE] = "node",
    [_GatherLite.DEBUG_FRAME] = "frame",
    [_GatherLite.DEBUG_P2P] = "p2p",
}

_GatherLite.configsDefaults = {
    global = {
        lastSeenVersion = nil,
        nodes = {
            mining = {},
            herbalism = {},
            containers = {},
            fishing = {}
        },
        usePredefined = true,
        debug = {
            enabled = false,
            types = {
                [_GatherLite.DEBUG_DEFAULT] = true,
                [_GatherLite.DEBUG_NODE] = false,
                [_GatherLite.DEBUG_FRAME] = true,
                [_GatherLite.DEBUG_P2P] = false
            }
        },
    },
    char = {
        debugging = false,
        ignore = {},
        tracking = {
            mining = true,
            herbalism = true,
            containers = true,
            fishing = true
        },
        minimap = {
            enabled = true,
            hide = false,
            range = 400,
            size = 12,
            opacity = 1,
            distance = 70,
            nearbyCircles = true,
            loot = true,
            edge = false,
            neighbors = true,
            tracking = {
                mining = true,
                herbalism = true,
                containers = true,
                fishing = true
            }
        },
        worldmap = {
            enabled = true,
            zoneTooltip = true,
            size = 12,
            opacity = 1,
            loot = true,
            neighbors = false,
            continent = false,
            tracking = {
                mining = true,
                herbalism = true,
                containers = true,
                fishing = true
            }
        },
        p2p = {
            guild = true
        }
    },
    profile = {
        minimap = {
            hide = false
        }
    }
}
