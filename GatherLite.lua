local name, _GatherLite = ...;


-----------------------------------------------------------------------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
_GatherLite.tooltip = CreateFrame("GameTooltip", "GatherLiteTooltip", UIParent, "GameTooltipTemplate")
_GatherLite.tooltip:ClearLines()
_GatherLite.tooltip:AddFontStrings(_GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), _GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));
_GatherLite.showingTooltip = false;

_GatherLite.showTooltip = function(title, ...)
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    _GatherLite.tooltip:SetText(title);

    if ... then
        for r, l in ipairs(...) do
            _GatherLite.tooltip:AddLine(l);
        end
    end
    _GatherLite.tooltip:Show();
    _GatherLite.showingTooltip = true;
end

_GatherLite.hideTooltip = function()
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:Hide();
    _GatherLite.showingTooltip = false;
end

function GatherLite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GatherLiteConfig", _GatherLite.configsDefaults, true)
    self.minimap = LibStub("LibDBIcon-1.0");

    GatherLite:sanitizeDatabase();

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    -- register synchronization
    GatherLite:RegisterComm(_GatherLite.name .. "Sync", "p2pSync")
    GatherLite:RegisterComm(_GatherLite.name .. "Node", "p2pNode")
    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")

    GatherLite:ScheduleTimer("p2pDatabase", 10)
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 5)
    GatherLite:ScheduleRepeatingTimer("p2pDatabase", 1800)
    GatherLite:ScheduleRepeatingTimer("checkNodePositions", 1);

    GatherLite:RegisterEvent("UNIT_SPELLCAST_SENT", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventHandler")
    GatherLite:RegisterEvent("LOOT_OPENED", "EventHandler")

    GatherLite:drawMinimap();
    GatherLite:drawWorldmap();

    GatherLite:print(GatherLite:Colorize(_GatherLite.version, "blue"), "has been loaded");
    GatherLite:print("use |cFF00FF00/gather|r or |cFF00FF00/gatherlite|r to access addon settings");
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(GatherLite.db.global.nodes.mining) .. "|r", "mining nodes");
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(GatherLite.db.global.nodes.herbalism) .. "|r", "herbalism nodes");
    if not _GatherLite.isClassic then
        GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(GatherLite.db.global.nodes.artifacts) .. "|r", "artifact nodes");
    end
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(GatherLite.db.global.nodes.fish) .. "|r", "fishing spots");
    GatherLite:debug("Found", "|cFF00FF00" .. GatherLite:tablelength(GatherLite.db.global.nodes.treasure) .. "|r", "treasures");

end