local name, _GatherLite = ...;

local GFrame = LibStub("GatherLiteFrame");
local HBD = LibStub("HereBeDragons-2.0");

local minimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("GatherLiteMinimapIcon", {
    type = "data source",
    text = "Gatherlite",
    icon = "Interface\\Icons\\inv_misc_spyglass_02",

    OnClick = function(_, button)
        if button == "LeftButton" then
            -- Button drawers can hide the launcher before the menu receives the click.
            GatherLite:OpenTrackingMenu(UIParent, "minimap")
        elseif button == "RightButton" then
            if not GatherLite:IsGamepadUI() then Menu.GetManager():CloseMenus() end
            GatherLite:ShowSettings()
        end
    end,

    OnTooltipShow = function(tooltip)
        tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('mining'), "white"), GatherLite:tablelength(GatherLite.db.global.nodes.mining));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('herbalism'), "white"), GatherLite:tablelength(GatherLite.db.global.nodes.herbalism));

        if GatherLite.db.global.debug.enabled then
            tooltip:AddLine(" ");
            tooltip:AddLine("             -- Debugging --             ");
            tooltip:AddDoubleLine(GatherLite:Colorize("Used frames", "white"), GatherLite:tablelength(GFrame.usedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("Unused frames", "white"), GatherLite:tablelength(GFrame.unusedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("All frames", "white"), GatherLite:tablelength(GFrame.allFrames));

            local function minimapFilter(node)
                if not GatherLite.db.profile.minimap.enabled then
                    return false
                end
                if not GatherLite:GetNodeTracking("minimap", node.type) then
                    return false
                end
                if node.predefined and not GatherLite.db.global.usePredefined then
                    return false
                end
                if GatherLite:IsIgnored(node.object) then
                    return false
                end
                return true
            end

            local worldX, worldY, instanceID = HBD:GetPlayerWorldPosition()
            local zoneX, zoneY, mapID = HBD:GetPlayerZonePosition()
            local range = GatherLite.db.profile.minimap.range
            local types = { "mining", "herbalism", "containers", "fishing" }
            local totalInRange = 0

            if worldX and worldY and instanceID and zoneX and zoneY and mapID then
                for i = 1, #types do
                    local type = types[i]
                    local nodes = GatherLite:GetNearbyNodes(type, mapID, instanceID, zoneX, zoneY, range)
                    local count = 0
                    for j = 1, #nodes do
                        local node = nodes[j]
                        if node.instance == instanceID and minimapFilter(node) then
                            if not node.worldX or not node.worldY then
                                GatherLite:EnsureNodeWorld(node)
                            end
                            local _, distance = HBD:GetWorldVector(instanceID, worldX, worldY, node.worldX, node.worldY)
                            if distance and distance < range then
                                count = count + 1
                            end
                        end
                    end
                    totalInRange = totalInRange + count
                    tooltip:AddDoubleLine(GatherLite:Colorize("In range " .. type, "white"), count)
                end
                tooltip:AddDoubleLine(GatherLite:Colorize("In range total", "white"), totalInRange)
            else
                tooltip:AddDoubleLine(GatherLite:Colorize("In range total", "white"), "n/a")
            end

            local stats = GatherLite:GetNodeIndexStats()
            for i = 1, #types do
                local type = types[i]
                local stat = stats[type]
                if stat then
                    tooltip:AddLine(" ");
                    tooltip:AddLine(GatherLite:Colorize("Index " .. type, "white"))
                    tooltip:AddDoubleLine("Nodes", stat.nodes)
                    tooltip:AddDoubleLine("Map buckets", stat.byMap)
                    tooltip:AddDoubleLine("Cell buckets", stat.byCell)
                    tooltip:AddDoubleLine("Map/instance", stat.byMapInstance)
                    tooltip:AddDoubleLine("Instance buckets", stat.instanceBuckets)
                    tooltip:AddDoubleLine("Cache maps", stat.cacheMaps)
                    tooltip:AddDoubleLine("Cache instances", stat.cacheInstances)
                end
            end

            local debug = GatherLite.minimapDebug
            if debug then
                local now = GetTime()
                tooltip:AddLine(" ");
                tooltip:AddLine(GatherLite:Colorize("Minimap timing", "white"))
                if debug.lastForceUpdate and debug.lastForceUpdate > 0 then
                    tooltip:AddDoubleLine("Last force", string.format("%.1fs", now - debug.lastForceUpdate))
                end
                if debug.lastNodesUpdate and debug.lastNodesUpdate > 0 then
                    tooltip:AddDoubleLine("Last nodes", string.format("%.1fs", now - debug.lastNodesUpdate))
                end
                if debug.lastIconsUpdate and debug.lastIconsUpdate > 0 then
                    tooltip:AddDoubleLine("Last icons", string.format("%.1fs", now - debug.lastIconsUpdate))
                end
                tooltip:AddDoubleLine("Nodes tick", string.format("%.2fs", debug.lastNodesTick or 0))
                tooltip:AddDoubleLine("Icons tick", string.format("%.2fs", debug.lastIconsTick or 0))
            end
        end

        tooltip:AddLine(" ");
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.left_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.left_click_text"));
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.right_click"), 'gray') .. ": " .. GatherLite:translate("settings.minimap.right_click_text"));
    end,
});

function GatherLite:GatherSlash(input)
    input = string.trim(input, " ");
    if input == "" or not input then
        GatherLite:ShowSettings();
        return ;
    end

    if input == "debugging" then
        if GatherLite.db.char.debugging then
            GatherLite.db.char.debugging = false;
            GatherLite:print("debugging", GatherLite:Colorize("disabled", "red"));
        else
            GatherLite.db.char.debugging = true;
            GatherLite:print("debugging", GatherLite:Colorize("enabled", "green"));
        end
    end
end

local function mergeMissingSettings(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if target[key] == nil then target[key] = {} end
            if type(target[key]) == "table" then mergeMissingSettings(target[key], value) end
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

local function migrateCharacterSettings(storage, currentKey, legacyKey)
    if not storage or not legacyKey or legacyKey == currentKey then return nil end
    local characters = storage.char
    local legacy = characters and characters[legacyKey]
    if legacy then
        if characters[currentKey] then
            mergeMissingSettings(characters[currentKey], legacy)
        else
            characters[currentKey] = legacy
        end
        characters[legacyKey] = nil
    end
    local profiles = storage.profileKeys
    local legacyProfile = profiles and profiles[legacyKey]
    if legacyProfile then
        profiles[currentKey] = legacyProfile
        profiles[legacyKey] = nil
    end
    return legacyProfile
end

_GatherLite.MigrateCharacterSettings = migrateCharacterSettings

local trackingKeys = { "ignore", "tracking", "professionTrackingInitialized", "professionTrackingManual" }
local displayGroups = { "minimap", "worldmap", "hud" }

-- Recover tracking from the character's active profile if an earlier build saved it there.
local function migrateProfileTracking(db)
    for character, name in pairs(db.sv.profileKeys) do
        local profile = db.profiles[name]
        if profile then
            local tracking = {}
            for _, key in ipairs(trackingKeys) do tracking[key] = profile[key] end
            for _, group in ipairs(displayGroups) do
                if profile[group] and profile[group].tracking then
                    tracking[group] = { tracking = profile[group].tracking }
                end
            end
            if next(tracking) then
                db.sv.char = db.sv.char or {}
                db.sv.char[character] = db.sv.char[character] or {}
                mergeMissingSettings(db.sv.char[character], tracking)
            end
        end
    end
    for _, profile in pairs(db.profiles) do
        for _, key in ipairs(trackingKeys) do profile[key] = nil end
        for _, group in ipairs(displayGroups) do
            if profile[group] then profile[group].tracking = nil end
        end
    end
end

-- Preserve legacy display preferences separately for each existing character.
local function migrateProfileSettings(db, saved)
    if not saved.professionTrackingInitialized and (next(saved.tracking or {})
        or next(saved.minimap and saved.minimap.tracking or {})
        or next(saved.worldmap and saved.worldmap.tracking or {})) then
        saved.professionTrackingManual = true
    end
    if saved.profileSettingsMigrated then return end

    local preferences = {}
    for _, group in ipairs(displayGroups) do
        local settings = saved[group]
        if settings then
            local display = {}
            for key, value in pairs(settings) do
                if key ~= "tracking" then display[key] = value end
            end
            if next(display) then
                preferences[group] = display
                saved[group] = settings.tracking and { tracking = settings.tracking } or nil
            end
        end
    end
    if next(preferences) then
        local previous = db:GetCurrentProfile()
        local baseName = db.keys.char
        if strlenutf8(baseName) > 40 then
            baseName = GatherLite:translate("settings.profiles.character")
        end
        local profile = baseName
        local existing = db.profiles
        local suffix = 2
        while existing[profile] or profile == previous do
            profile = baseName .. " (" .. suffix .. ")"
            suffix = suffix + 1
        end
        db:SetProfile(profile)
        if existing[previous] then db:CopyProfile(previous) end
        for key, value in pairs(preferences) do
            db.profile[key] = value
        end
    end
    saved.profileSettingsMigrated = true
end

-- Earlier releases stored the launcher state under profile.minimap.
local function migrateMinimapIcons(db)
    for _, profile in pairs(db.profiles) do
        local minimap = profile.minimap
        if profile.minimapIcon == nil and minimap then
            local icon = { hide = minimap.hide, minimapPos = minimap.minimapPos, lock = minimap.lock }
            if next(icon) then
                profile.minimapIcon = icon
                minimap.hide, minimap.minimapPos, minimap.lock = nil, nil, nil
                if not next(minimap) then profile.minimap = nil end
            end
        end
    end
end

function _GatherLite.MigrateProfileSettings(db)
    migrateMinimapIcons(db)
    migrateProfileTracking(db)
    migrateProfileSettings(db, db.char)
end

function GatherLite:RefreshProfile()
    self.minimap:Refresh("GatherLiteMinimapIcon", self.db.profile.minimapIcon)
    self:Trigger("settings:update")
    LibStub("AceConfigRegistry-3.0"):NotifyChange("GatherLite")
end

local function legacyForeverCharacterKey()
    if not RegionalUniqueNamesEnabled or not RegionalUniqueNamesEnabled() then return nil end
    local ruleset
    if C_GameRules.IsGameRuleActive(Enum.GameRule.HardcoreRuleset) then
        ruleset = "Hardcore"
    elseif C_GameRules.IsGameRuleActive(Enum.GameRule.RPRuleset) then
        ruleset = "RP"
    elseif C_GameRules.IsGameRuleActive(Enum.GameRule.PvPRuleset) then
        ruleset = "PvP"
    else
        ruleset = "PvE"
    end
    return UnitName("player") .. " - " .. ruleset
end

function GatherLite:OnInitialize()
    -- AceDB removes default values on logout. Non-default saved filter values
    -- are existing user overrides and must survive the profession-based defaults.
    -- Ask AceDB for its character key before registering defaults; Forever
    -- uses a ruleset/global-name key rather than the literal realm name.
    self.db = LibStub("AceDB-3.0"):New("GatherLiteSettings", nil, true)
    local legacyProfile = migrateCharacterSettings(GatherLiteSettings, self.db.keys.char,
        legacyForeverCharacterKey())
    if legacyProfile and legacyProfile ~= self.db.keys.profile then
        self.db:SetProfile(legacyProfile)
    end
    _GatherLite.MigrateProfileSettings(self.db)
    self.db:RegisterDefaults(_GatherLite.configsDefaults)
    self.minimap = LibStub("LibDBIcon-1.0")
    self:RegisterSettingsLauncher()

    GatherLite:print(GatherLite:Colorize(_GatherLite.version, "blue"), "has been loaded");
    GatherLite:print("use |cFF00FF00/gather|r or |cFF00FF00/gatherlite|r to access addon settings");
    GatherLite:print("Support GatherLite on " .. _GatherLite.supportLabel .. ": " .. GatherLite:Colorize(_GatherLite.supportUrl, "cyan"));

    self.minimap:Register("GatherLiteMinimapIcon", minimapIcon, self.db.profile.minimapIcon)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

    GatherLite:RegisterEvent("UNIT_SPELLCAST_SENT", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventHandler")
    GatherLite:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventHandler")
    GatherLite:RegisterEvent("LOOT_OPENED", "EventHandler")
    GatherLite:RegisterEvent("PLAYER_LOGIN", "EventHandler")
    GatherLite:RegisterEvent("ZONE_CHANGED", "EventHandler")

    GameTooltip:HookScript("OnShow", GatherLite.ModifyTooltip)
    GameTooltip:HookScript("OnUpdate", GatherLite.ModifyTooltip)

    GatherLite:RegisterChatCommand("gather", "GatherSlash")
    GatherLite:RegisterChatCommand("gatherlite", "GatherSlash")

    GatherLite:RegisterComm(_GatherLite.name .. "Ver", "VersionCheck")
    GatherLite:ScheduleRepeatingTimer("SendVersionCheck", 10)
end

function GatherLite.ModifyTooltip()
    local API = _GatherLite.API
    if GameTooltip.IsForbidden and GameTooltip:IsForbidden() then
        return
    end

    -- Only inspect known gathering objects. Unit/combat tooltips can contain
    -- secret strings on Forever, which must not be compared or concatenated.
    local title = _G.GameTooltipTextLeft1
    local objectName = title and title:GetText()
    if API.IsSecret(objectName) or not objectName then
        return
    end
    local object = GatherLite:GetObject(objectName)
    if not object then return end
    local requirement, profession = GatherLite:GetNodeSkillRequirement(object)
    if not requirement then return end
    local hasProfessionLine = false
    for i = 2, GameTooltip:NumLines() do
        local line = GameTooltip.GetLeftLine and GameTooltip:GetLeftLine(i) or _G["GameTooltipTextLeft" .. i]
        local text = line and line:GetText()
        if not API.IsSecret(text) then
            if text == requirement then
                if line.SetTextColor then
                    local r, g, b = GatherLite:GetNodeSkillRequirementColor(object, profession)
                    -- Preserve client difficulty colors when only the minimum is known.
                    if g ~= 1 or b ~= 1 then line:SetTextColor(r, g, b) end
                end
                return
            elseif text == profession then
                hasProfessionLine = true
            end
        end
    end
    if not hasProfessionLine then
        return
    end

    GameTooltip:AddLine(requirement, GatherLite:GetNodeSkillRequirementColor(object, profession))
    GameTooltip:Show()
end
