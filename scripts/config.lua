local name, _GatherLite = ...;

GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")

_GatherLite.name = name;
_GatherLite.version = GetAddOnMetadata(name, "version");

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
        nodes = {
            mining = {},
            herbalism = {},
            containers = {}
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
        },
        minimap = {
            enabled = true,
            hide = false,
            size = 12,
            opacity = 1,
            distance = 70,
            loot = true,
            edge = false,
            neighbors = true
        },
        worldmap = {
            enabled = true,
            size = 12,
            opacity = 1,
            loot = true,
            neighbors = true,
            continent = false
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
