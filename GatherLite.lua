local name, GatherLite = ...;

local CBH = LibStub("CallbackHandler-1.0")


GatherLite.callbacks = CBH:New(GatherLite, nil, nil, false)

SLASH_GATHER1 = '/GATHER'
SLASH_GATHER2 = '/GATHERLITE'
SlashCmdList['GATHER'] = function(msg)
    if msg == 'reload' then
        GatherLite.print("Reloading map");
        GatherLite.needMapUpdate = true;
    elseif msg == "debugging on" then
        GatherLiteConfigCharacter.debugging2 = true
        GatherLite.print("debugging enabled");
    elseif msg == "debugging off" then
        GatherLiteConfigCharacter.debugging2 = false
        GatherLite.print("debugging disabled");
    elseif msg == "reset" then
        GatherLiteGlobalSettings.database = {};
        GatherLite.needMapUpdate = true
    elseif msg == "reset treasure" then
        GatherLiteGlobalSettings.database.treasure = {};
        GatherLite.needMapUpdate = true
    elseif msg == "sync" then
        GatherLite.send_all(true, true, true);
        GatherLite.print("syncing my data");
    elseif msg == "sync guild" then
        GatherLite.send_all(true, false, true);
        GatherLite.print("syncing my data with guild");
    elseif msg == "sync party" then
        GatherLite.send_all(false, true, true);
        GatherLite.print("syncing my data with party");
    end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- MAIN FRAME
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.mainFrame = CreateFrame('FRAME', nil, UIParent)
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_FAILED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
GatherLite.mainFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
GatherLite.mainFrame:RegisterEvent('ADDON_LOADED')
GatherLite.mainFrame:RegisterEvent('CHAT_MSG_ADDON')
GatherLite.mainFrame:RegisterEvent('LOOT_OPENED')

-----------------------------------------------------------------------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.tooltip = CreateFrame("GameTooltip", "GatherLiteTooltip", UIParent, "GameTooltipTemplate")
GatherLite.tooltip:ClearLines()
GatherLite.tooltip:AddFontStrings(GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));
GatherLite.showingTooltip = false;

GatherLite.showTooltip = function(title, ...)
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    GatherLite.tooltip:SetText(title);

    if ... then
        for r, l in ipairs(...) do
            GatherLite.tooltip:AddLine(l);
        end
    end
    GatherLite.tooltip:Show();
    GatherLite.showingTooltip = true;
end

GatherLite.hideTooltip = function()
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:Hide();
    GatherLite.showingTooltip = false;
end

GatherLite.updateMiniMapPosition = function()
    GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end
