local _, addon = ...
local diagnostics = {}
local function debugState(topic, text)
    local debug=GatherLite.db and GatherLite.db.global and GatherLite.db.global.debug
    if not debug or not debug.enabled or not debug.types or not debug.types[addon.DEBUG_DEFAULT] then return end
    if diagnostics[topic]==text then return end
    diagnostics[topic]=text
    GatherLite:debug(addon.DEBUG_DEFAULT,"Gathering checks - "..topic..": "..text)
end

local function updateProfessionFilters()
    local settings=GatherLite.db and GatherLite.db.char
    if not settings then return end
    if not C_SkillInfo or not C_SkillInfo.GetSkillLineInfoByID or not C_SkillInfo.GetNumSkillLines
        or C_SkillInfo.GetNumSkillLines()==0 then
        debugState("professions","Waiting for skill data")
        return
    end
    local function known(id)
        local info=C_SkillInfo.GetSkillLineInfoByID(id)
        local rank=info and info.rank or 0
        debugState("profession "..id,(info and info.name or ({[186]="Mining",[182]="Herbalism",[356]="Fishing"})[id])
            ..": "..(rank>0 and ("learned, rank "..rank) or "not learned"))
        return rank>0
    end
    local wanted={mining=known(186),herbalism=known(182),fishing=known(356),containers=true}
    if settings.professionTrackingManual then
        debugState("profession filters","Preserving manual tracking choices; automatic filter updates skipped")
        return
    end
    local changed=false
    for _,target in ipairs({"minimap","worldmap"}) do
        settings[target]=settings[target] or {}
        settings[target].tracking=settings[target].tracking or {}
        for kind,value in pairs(wanted) do
            if settings[target].tracking[kind]~=value then
                settings[target].tracking[kind]=value
                changed=true
            end
        end
    end
    settings.professionTrackingInitialized=true
    debugState("profession filters",string.format("Profession defaults: ores=%s, herbs=%s, fishing=%s, containers=true",
        tostring(wanted.mining),tostring(wanted.herbalism),tostring(wanted.fishing)))
    if changed then
        GatherLite:Trigger("settings:update")
        if addon.Window then addon.Window:RefreshSettings() end
    end
end

local gatheringKinds = { [2580] = "mining", [2383] = "herbalism" }
local function trackingSpellID(index, info)
    if info.spellID then return info.spellID end
    local filter = C_Minimap.GetTrackingFilter and C_Minimap.GetTrackingFilter(index)
    if filter and filter.spellID then return filter.spellID end
    -- Forever can omit the spell ID. Use client-localized spell data as a fallback.
    if info.type == "spell" and C_Spell then
        for id in pairs(gatheringKinds) do
            local name = C_Spell.GetSpellName and C_Spell.GetSpellName(id)
            local texture = C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(id)
            if (name and info.name == name) or (texture and info.texture == texture) then return id end
        end
    end
end

local dismissed
local function trackingChoices()
    local settings = GatherLite.db and GatherLite.db.char
    if dismissed or not settings or not settings.minimap or not settings.minimap.enabled or not Minimap
        or IsInInstance() or UnitIsDeadOrGhost("player") or InCombatLockdown()
        or not C_Minimap or not C_Minimap.GetNumTrackingTypes or not C_Minimap.GetTrackingInfo
        or not C_Minimap.SetTracking then
        return
    end
    local choices, seen = {}, {}
    local canTrack = false
    for index = 1, C_Minimap.GetNumTrackingTypes() do
        local info = C_Minimap.GetTrackingInfo(index)
        if info then
            local id = trackingSpellID(index, info)
            -- Respect any active spell the player chose, including non-gathering trackers.
            if info.active and (info.type == "spell" or id) then return end
            local kind = gatheringKinds[id]
            if kind and not seen[id] then
                seen[id] = true
                choices[#choices + 1] = { id = id, index = index, kind = kind, name = info.name or GatherLite:translate(kind) }
                canTrack = canTrack or GatherLite:GetNodeTracking("minimap", kind)
            end
        end
    end
    if canTrack then return choices end
end

local function enableTracker(id)
    -- A tracking entry can move or disappear while the menu is open.
    for _, choice in ipairs(trackingChoices() or {}) do
        if choice.id == id then
            C_Minimap.SetTracking(choice.index, true)
            return
        end
    end
end

local function openTrackingChoices(owner)
    local choices = trackingChoices()
    if not choices then return end
    if #choices == 1 then
        enableTracker(choices[1].id)
    elseif GatherLite:IsGamepadUI() then
        -- No Blizzard menu from addon code in the gamepad UI (it taints the
        -- controller binding stack). Enable the first tracker the minimap
        -- filters show; the native tracking menu still switches it.
        for _, choice in ipairs(choices) do
            if GatherLite:GetNodeTracking("minimap", choice.kind) then
                enableTracker(choice.id)
                return
            end
        end
    else
        MenuUtil.CreateContextMenu(owner, function(_, root)
            root:CreateTitle(GatherLite:translate("tracking"))
            for _, choice in ipairs(choices) do
                root:CreateButton(choice.name, enableTracker, choice.id)
            end
        end)
    end
end

local function positionReminder(frame)
    local mapX = Minimap:GetCenter()
    local screenX = UIParent:GetCenter()
    local opensRight = mapX and screenX and mapX * Minimap:GetEffectiveScale() < screenX * UIParent:GetEffectiveScale()
    local point = opensRight and "LEFT" or "RIGHT"
    if frame.side == point then return end
    frame.side = point
    frame:ClearAllPoints()
    frame:SetPoint(point, Minimap, opensRight and "RIGHT" or "LEFT", opensRight and 10 or -10, 0)
end

local reminder
local function updateReminder()
    if not trackingChoices() then
        if reminder then reminder:Hide() end
        return
    end
    if not reminder then
        local UI = addon.UI
        reminder = CreateFrame("Button", nil, Minimap)
        reminder:SetFrameStrata("DIALOG")
        reminder:SetClampedToScreen(true)
        reminder:RegisterForClicks("LeftButtonUp")
        reminder:SetScript("OnClick", openTrackingChoices)
        UI.Background(reminder, .075, .085, .095, .98)
        UI.Border(reminder)

        local highlight = reminder:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, .69, .18, .10)

        local accent = reminder:CreateTexture(nil, "ARTWORK")
        accent:SetColorTexture(1, .69, .18)
        accent:SetPoint("TOPLEFT", 1, -6)
        accent:SetPoint("BOTTOMLEFT", 1, 6)
        accent:SetWidth(3)

        local icon = reminder:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
        icon:SetSize(32, 32)
        icon:SetPoint("TOPLEFT", 13, -12)

        local title = UI.Text(reminder, GatherLite:translate("minimap.tracking_reminder"), "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 56, -11)
        title:SetWidth(190)
        title:SetWordWrap(true)
        local hint = UI.Text(reminder, GatherLite:translate("minimap.tracking_reminder.hint"), "GameFontHighlight")
        hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        hint:SetWidth(212)
        hint:SetWordWrap(true)
        reminder:SetSize(280, math.max(72, title:GetStringHeight() + hint:GetStringHeight() + 27))

        local close = CreateFrame("Button", nil, reminder, "UIPanelCloseButton")
        close:SetSize(24, 24)
        close:SetPoint("TOPRIGHT", -4, -4)
        close:SetScript("OnClick", function()
            dismissed = true
            reminder:Hide()
        end)

        local positionElapsed = 0
        reminder:SetScript("OnUpdate", function(frame, elapsed)
            positionElapsed = positionElapsed + elapsed
            if positionElapsed < .2 then return end
            positionElapsed = 0
            positionReminder(frame)
        end)
    end
    positionReminder(reminder)
    reminder:Show()
end

GatherLite:On("settings:update", updateReminder)

-- Profession defaults apply to GatherLite pins. Spell changes require a click.
local events=CreateFrame("Frame")
for _,event in ipairs({"PLAYER_ENTERING_WORLD","SPELLS_CHANGED","SKILL_LINES_CHANGED"}) do
    events:RegisterEvent(event)
end
local reminderEvents = { MINIMAP_UPDATE_TRACKING = true, PLAYER_DEAD = true, PLAYER_ALIVE = true, PLAYER_UNGHOST = true,
    PLAYER_REGEN_DISABLED = true, PLAYER_REGEN_ENABLED = true }
for event in pairs(reminderEvents) do events:RegisterEvent(event) end
local pending
events:SetScript("OnEvent",function(_,event,initialLogin,reloadingUI)
    if reminderEvents[event] then
        updateReminder()
        return
    end
    if event=="PLAYER_ENTERING_WORLD" and (initialLogin or reloadingUI) then
        diagnostics={}
        debugState("startup",reloadingUI and "UI reload: checking gathering professions" or "Login: checking gathering professions")
    end
    if pending then return end
    pending=true
    C_Timer.After(.2,function()
        pending=nil
        updateProfessionFilters()
        updateReminder()
    end)
end)
