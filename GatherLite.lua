GatherLite = LibStub("AceAddon-3.0"):NewAddon("GatherLite", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")

local name, _GatherLite = ...;

-----------------------------------------------------------------------------------------------------------------------------------
-- MAIN FRAME
-----------------------------------------------------------------------------------------------------------------------------------
_GatherLite.mainFrame = CreateFrame('FRAME', nil, UIParent)
_GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
_GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_FAILED')
_GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
_GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
_GatherLite.mainFrame:RegisterEvent('ADDON_LOADED')
_GatherLite.mainFrame:RegisterEvent('LOOT_OPENED')

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

_GatherLite.updateMiniMapPosition = function()
    _GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end
