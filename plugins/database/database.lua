local GatherLite = LibStub("AceAddon-3.0"):GetAddon("GatherLite", 1)
if not GatherLite then
    return
end

local SourceName = "Database"

GatherLite.plugins[SourceName] = {}
local source = GatherLite.plugins[SourceName]

local loaded = {
    mining = false,
    herbalism = false,
    containers = false,
    fishing = false,
}

local predefinedTables = {
    mining = "GatherLite_PluginsDatabaseMining",
    herbalism = "GatherLite_PluginsDatabaseHerbalism",
    containers = "GatherLite_PluginsDatabaseContainers",
    fishing = "GatherLite_PluginsDatabaseFishing",
}

local function loadType(type)
    if loaded[type] then
        return
    end

    local tableName = predefinedTables[type]
    local data = tableName and _G[tableName] or nil
    if not data then
        return
    end

    GatherLite:print("Loading", type, "database:", GatherLite:tablelength(data), "nodes")
    GatherLite:LoadTable(type, data)
    loaded[type] = true
end

local function ensurePredefinedLoaded()
    if not GatherLite.db.global.usePredefined then
        return
    end

    if GatherLite.db.char.tracking.mining then
        loadType("mining")
    end
    if GatherLite.db.char.tracking.herbalism then
        loadType("herbalism")
    end
    if GatherLite.db.char.tracking.containers then
        loadType("containers")
    end
    if GatherLite.db.char.tracking.fishing then
        loadType("fishing")
    end
end

local function Setup()
    ensurePredefinedLoaded()

    GatherLite:On("settings:update", function()
        ensurePredefinedLoaded()
    end)
end

source.setup = Setup;
