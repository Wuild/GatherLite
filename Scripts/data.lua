GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
local name, _GatherLite = ...

_GatherLite.name = name;
_GatherLite.version = "@project-version@";

_GatherLite.isClassic = select(4, GetBuildInfo()) < 20000;

_GatherLite.frames = {};

_GatherLite.gatherSpellRanges = {
    default = 0.0065,
    fish = 0.0130
};

_GatherLite.TimeSinceLastUpdate = 0;
_GatherLite.UpdateInterval = 1.0;
_GatherLite.nodes = {
    minimap = {},
    worldmap = {}
};

-- tracker data
_GatherLite.tracker = {
    spellType = nil,
    spellID = nil,
    target = nil,
    ended = nil
};

if (_GatherLite.isClassic) then
    _GatherLite.spellIDs = {
        [GetSpellInfo(2575)] = "mining", -- Mining
        [GetSpellInfo(2366)] = "herbalism", -- Herbalism
        [GetSpellInfo(7620)] = "fish", -- Fishing(Apprentice)
        [GetSpellInfo(1804)] = "treasure", -- Pick Lock()
        [GetSpellInfo(3365)] = "treasure", -- Opening()
        [GetSpellInfo(3366)] = "treasure", -- Opening()
        [GetSpellInfo(6247)] = "treasure", -- Opening()
        [GetSpellInfo(6249)] = "treasure", -- Opening()
        [GetSpellInfo(6477)] = "treasure", -- Opening()
        [GetSpellInfo(6478)] = "treasure", -- Opening()
    };
else
    _GatherLite.spellIDs = {
        [GetSpellInfo(2575)] = "mining", -- Mining
        [GetSpellInfo(2366)] = "herbalism", -- Herbalism
        [GetSpellInfo(7620)] = "fish", -- Fishing(Apprentice)
        [GetSpellInfo(1804)] = "treasure", -- Pick Lock()
        [GetSpellInfo(3365)] = "treasure", -- Opening()
        [GetSpellInfo(3366)] = "treasure", -- Opening()
        [GetSpellInfo(6247)] = "treasure", -- Opening()
        [GetSpellInfo(6249)] = "treasure", -- Opening()
        [GetSpellInfo(6477)] = "treasure", -- Opening()
        [GetSpellInfo(6478)] = "treasure", -- Opening()
        [GetSpellInfo(6509)] = "treasure", -- Opening()
        [GetSpellInfo(6658)] = "treasure", -- Opening()
        [GetSpellInfo(6802)] = "treasure", -- Opening()
        [GetSpellInfo(8917)] = "treasure", -- Opening()
        [GetSpellInfo(21248)] = "treasure", -- Opening()
        [GetSpellInfo(21288)] = "treasure", -- Opening()
        [GetSpellInfo(21651)] = "treasure", -- Opening()
        [GetSpellInfo(24390)] = "treasure", -- Opening()
        [GetSpellInfo(24391)] = "treasure", -- Opening()
        [GetSpellInfo(26868)] = "treasure", -- Opening()
        [GetSpellInfo(39220)] = "treasure", -- Opening()
        [GetSpellInfo(39264)] = "treasure", -- Opening()
        [GetSpellInfo(45137)] = "treasure", -- Opening()
        [GetSpellInfo(22810)] = "treasure", -- Opening - No Text()
        [GetSpellInfo(73979)] = "artifacts", -- Searching for Artifacts(Apprentice)
    };
end ;

_GatherLite.classColours = {
    DEATHKNIGHT = { r = 0.77, g = 0.12, b = 0.23, fs = '|cffC41F3B' },
    DEMONHUNTER = { r = 0.64, g = 0.19, b = 0.79, fs = '|cffA330C9' },
    DRUID = { r = 1.00, g = 0.49, b = 0.04, fs = '|cffFF7D0A' },
    HUNTER = { r = 0.67, g = 0.83, b = 0.45, fs = '|cffABD473' },
    MAGE = { r = 0.25, g = 0.78, b = 0.92, fs = '|cff40C7EB' },
    PALADIN = { r = 0.96, g = 0.55, b = 0.73, fs = '|cffF58CBA' },
    PRIEST = { r = 1.00, g = 1.00, b = 1.00, fs = '|cffFFFFFF' },
    ROGUE = { r = 1.00, g = 0.96, b = 0.41, fs = '|cffFFF569' },
    SHAMAN = { r = 0.00, g = 0.44, b = 0.87, fs = '|cff0070DE' },
    WARLOCK = { r = 0.53, g = 0.53, b = 0.93, fs = '|cff8787ED' },
    WARRIOR = { r = 0.78, g = 0.61, b = 0.43, fs = '|cffC79C6E' }
}

_GatherLite.configsDefaults = {
    global = {
        nodes = {
            mining = {},
            herbalism = {},
            treasure = {},
            fish = {},
            artifacts = {}
        }
    },
    char = {
        enabled = true,
        debugging = false,
        tracking = {
            mining = true,
            herbalism = true,
            treasures = true,
            fish = true,
            artifacts = true
        },
        minimap = {
            enabled = true,
            hide = false,
            size = 12,
            opacity = 1,
            distance = 70,
            loot = true,
            edge = false
        },
        worldmap = {
            enabled = true,
            size = 12,
            opacity = 1,
            loot = true
        },
        p2p = {
            guild = true,
            party = false
        }
    },
    profile = {
    }
}