local GatherLite = LibStub("AceAddon-3.0"):GetAddon("GatherLite", 1)
if not GatherLite then
    return
end

local SourceName = "Database"

GatherLite.plugins[SourceName] = {}
local source = GatherLite.plugins[SourceName]

local function Setup()
    if GatherLite.db.global.usePredefined then
        GatherLite:print("Loading mining database:", GatherLite:tablelength(GatherLite_PluginsDatabaseMining), "nodes")
        GatherLite:LoadTable("mining", GatherLite_PluginsDatabaseMining)

        GatherLite:print("Loading herbalism database:", GatherLite:tablelength(GatherLite_PluginsDatabaseHerbalism), "nodes")
        GatherLite:LoadTable("herbalism", GatherLite_PluginsDatabaseHerbalism)

        GatherLite:print("Loading containers database:", GatherLite:tablelength(GatherLite_PluginsDatabaseContainers), "nodes")
        GatherLite:LoadTable("containers", GatherLite_PluginsDatabaseContainers)

        GatherLite:print("Loading fishing database:", GatherLite:tablelength(GatherLite_PluginsDatabaseFishing), "nodes")
        GatherLite:LoadTable("fishing", GatherLite_PluginsDatabaseFishing)
    end
end

source.setup = Setup;