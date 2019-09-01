local name, GatherLite = ...

GatherLite.needMapUpdate = true;

-- tracker data
GatherLite.tracker = {
    spellType = nil,
    spellID = nil,
    target = nil,
    ended = nil
};

-- on main frame update
GatherLite.mainFrame:SetScript('OnUpdate', function(self, elapsed)
    GatherLite.TimeSinceLastUpdate = GatherLite.TimeSinceLastUpdate + elapsed;

    if GatherLite.needMapUpdate then
        GatherLite.drawMinimap();

        if GatherLite.WorldMapOpen then
            GatherLite.drawWorldmap();
        end

        GatherLite.needMapUpdate = false;
    end ;

    if (GatherLite.TimeSinceLastUpdate > GatherLite.UpdateInterval) then
        GatherLite.checkNodePositions();
        GatherLite.TimeSinceLastUpdate = 0;
    end
end);

-- addon events handler
GatherLite.mainFrame:SetScript('OnEvent', function(self, event, ...)

    -- addon is loaded
    if event == "ADDON_LOADED" and select(1, ...) == GatherLite.name then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = {
                database = {
                    mining = {},
                    herbalism = {},
                    treasure = {}
                }
            };
        end

        GatherLiteConfigCharacter = GatherLite.CopyDefaults(GatherLite.defaultConfigs, GatherLiteConfigCharacter);

        GatherLite.migrate();

        GatherLite.print("GatherLite", "|cFF00FF00" .. GatherLite.version .. "|r", "has been loaded");
        GatherLite.debug("Found", "|cFF00FF00" .. GatherLite.tablelength(GatherLiteGlobalSettings.database.mining) .. "|r", "mining nodes");
        GatherLite.debug("Found", "|cFF00FF00" .. GatherLite.tablelength(GatherLiteGlobalSettings.database.herbalism) .. "|r", "herbalism nodes");
        if not GatherLite.isClassic then
            GatherLite.debug("Found", "|cFF00FF00" .. GatherLite.tablelength(GatherLiteGlobalSettings.database.artifacts) .. "|r", "artifact nodes");
        end
        GatherLite.debug("Found", "|cFF00FF00" .. GatherLite.tablelength(GatherLiteGlobalSettings.database.fish) .. "|r", "fishing spots");
        GatherLite.debug("Found", "|cFF00FF00" .. GatherLite.tablelength(GatherLiteGlobalSettings.database.treasure) .. "|r", "treasures");
        GatherLite.updateMiniMapPosition();
        C_ChatInfo.RegisterAddonMessagePrefix(GatherLite.name);
        self:UnregisterEvent("ADDON_LOADED");
    end

    -- loot window opened
    if event == "LOOT_OPENED" then
        if (GatherLite.tracker.spellID and GatherLite.tracker.ended and GetTime() - GatherLite.tracker.ended < 1) then
            GatherLite.debug("loot window opened")
            GatherLite.foundNode();
            GatherLite.tracker.target = nil;
            GatherLite.tracker.spellID = nil;
            GatherLite.tracker.spellType = nil;
        elseif (GatherLite.tracker.spellID and IsFishingLoot()) then
            GatherLite.debug("loot window opened")
            GatherLite.foundNode();
            GatherLite.tracker.target = nil;
            GatherLite.tracker.spellID = nil;
            GatherLite.tracker.spellType = nil;
        end
    end

    -- spell has ended
    if (event == "UNIT_SPELLCAST_SENT") or (event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED") then
        local spell = select(4, ...)
        local target = select(2, ...)

        if (event == "UNIT_SPELLCAST_SENT") then
            local spellType = GatherLite.findSpellType(spell)
            if (spellType) then
                GatherLite.debug("Started " .. GetSpellInfo(spell), spell)
                GatherLite.tracker.target = target
                GatherLite.tracker.spellID = spell
                GatherLite.tracker.spellType = spellType
            end ;
        elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
            GatherLite.tracker.ended = GetTime()
        elseif ((event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED")) then
            -- Spell failed, cancel the tracking
            GatherLite.tracker.target = nil
            GatherLite.tracker.spellID = nil
            GatherLite.tracker.spellType = nil
        end
    end

    -- player has entered the world
    if (event == "PLAYER_ENTERING_WORLD") then
        GatherLite.debug("player entering world")
        GatherLite.needMapUpdate = true;
    end

    -- p2p message
    if event == 'CHAT_MSG_ADDON' then
        if string.find(select(1, ...), GatherLite.name) then
            GatherLite.ParseSentData(select(2, ...), select(5, ...))
        end
    end
end)

-- bind world map event on show
WorldMapFrame.ScrollContainer.Child:SetScript("OnShow", function()
    GatherLite.debug("map open")
    GatherLite.WorldMapOpen = true;
    GatherLite.drawWorldmap();
end)

-- bind world map event on hide
WorldMapFrame.ScrollContainer.Child:SetScript("OnHide", function()
    GatherLite.debug("map closed")
    GatherLite.WorldMapOpen = false;
    GatherLite.removeWorldmapNodes();
end)