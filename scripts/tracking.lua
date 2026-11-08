local _, addon = ...
local Tracking = {}
addon.GatheringTracking = Tracking
local spellIDs = {2580,2383}
local spells = {
    [2580]={kind="mining",name="Find Minerals"},
    [2383]={kind="herbalism",name="Find Herbs"},
}
local requested = {}
local function trackingSpell(index, info)
    if info.spellID then return info.spellID end
    local filter=C_Minimap.GetTrackingFilter and C_Minimap.GetTrackingFilter(index)
    if filter and filter.spellID then return filter.spellID end
    -- Some Forever entries omit spellID. Match client-localized spell data,
    -- never English names, and never mistake a normal minimap filter for a spell.
    if info.type=="spell" and C_Spell then
        for _,id in ipairs(spellIDs) do
            local name=C_Spell.GetSpellName and C_Spell.GetSpellName(id)
            local texture=C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(id)
            if (name and info.name==name) or (texture and info.texture==texture) then return id end
        end
    end
end
local function debugState(topic, text)
    local debug=GatherLite.db and GatherLite.db.global and GatherLite.db.global.debug
    if not debug or not debug.enabled or not debug.types or not debug.types[addon.DEBUG_DEFAULT] then return end
    Tracking.debugState=Tracking.debugState or {}
    if Tracking.debugState[topic]==text then return end
    Tracking.debugState[topic]=text
    GatherLite:debug(addon.DEBUG_DEFAULT,"Gathering checks - "..topic..": "..text)
end

function Tracking:UpdateProfessionFilters()
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

local function requestTracking(id, entry, enabled)
    -- Wait for the client to report the change before sending another request.
    if requested[id]==enabled then return end
    requested[id]=enabled
    local name=spells[id].name
    debugState("spell action",(enabled and "Turning on " or "Turning off ")..name)
    C_Minimap.SetTracking(entry.index,enabled)
    local result=C_Minimap.GetTrackingInfo(entry.index)
    if result and result.active==enabled then requested[id]=nil end
end

function Tracking:Check()
    local settings = GatherLite.db and GatherLite.db.char
    if not settings then return end
    debugState("spell preference","automatic="..tostring(settings.autoGatherTracking~=false))
    if not C_Minimap or not C_Minimap.GetNumTrackingTypes or not C_Minimap.GetTrackingInfo
        or not C_Minimap.SetTracking then
        debugState("spells","Tracking API unavailable")
        return
    end
    local available, otherActive = {}, false
    for index=1,C_Minimap.GetNumTrackingTypes() do
        local info=C_Minimap.GetTrackingInfo(index)
        if info then
            local id=trackingSpell(index,info)
            if spells[id] then
                available[id]={index=index,active=info.active}
            elseif info.active and (info.type=="spell" or id) then
                otherActive=true
            end
        end
    end
    for _,id in ipairs(spellIDs) do
        local entry=available[id]
        if not entry or entry.active==requested[id] then requested[id]=nil end
        debugState("spell "..id,spells[id].name..": "..(entry and (entry.active and "active" or "available, inactive") or "not available"))
    end
    if settings.autoGatherTracking==false then
        debugState("spell action","Automatic activation disabled")
        return
    end
    if InCombatLockdown() then debugState("spell action","Deferred until combat ends"); return end
    if UnitIsDeadOrGhost("player") then debugState("spell action","Deferred while dead or a ghost"); return end
    local active, candidate
    local previous=settings.lastGatherTrackingSpell
    for _,id in ipairs(spellIDs) do
        local entry=available[id]
        if entry then
            if not GatherLite:GetNodeTracking("minimap",spells[id].kind) then
                if entry.active then
                    requestTracking(id,entry,false)
                end
            elseif entry.active then
                if not active or id==previous then active=id end
            elseif not candidate or id==previous then
                candidate=id
            end
        end
    end
    if active then settings.lastGatherTrackingSpell=active end
    if otherActive then
        debugState("spell action","Preserving active non-gathering tracker")
        return
    end
    -- Forever switches tracking spells on the global cooldown. Keep any
    -- checked tracker already active and restore only when tracking is lost.
    if active or not candidate then return end
    requestTracking(candidate,available[candidate],true)
end

function Tracking:Schedule(preserveRequests)
    if not preserveRequests then requested={} end
    if self.pending then return end
    self.pending=true
    C_Timer.After(.2,function()
        self.pending=nil
        self:UpdateProfessionFilters()
        self:Check()
    end)
end

-- Event checks stay responsive; this single ticker recovers missed changes
-- without repeatedly scanning professions or rebuilding node filters.
function Tracking:StartInterval()
    if self.ticker then return end
    self.ticker=C_Timer.NewTicker(5,function()
        local settings=GatherLite.db and GatherLite.db.char
        if settings and settings.autoGatherTracking~=false and not self.pending then
            self:Check()
        end
    end)
end

local events=CreateFrame("Frame")
for _,event in ipairs({"PLAYER_ENTERING_WORLD","MINIMAP_UPDATE_TRACKING","SPELLS_CHANGED",
    "PLAYER_REGEN_ENABLED","PLAYER_ALIVE","PLAYER_UNGHOST","SKILL_LINES_CHANGED"}) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent",function(_,event,initialLogin,reloadingUI)
    if event=="PLAYER_ENTERING_WORLD" then Tracking:StartInterval() end
    if event=="PLAYER_ENTERING_WORLD" and (initialLogin or reloadingUI) then
        Tracking.debugState=nil
        debugState("startup",reloadingUI and "UI reload: checking professions and tracking spells" or "Login: checking professions and tracking spells")
    end
    local preserveRequests=event=="MINIMAP_UPDATE_TRACKING" or event=="SPELLS_CHANGED" or event=="SKILL_LINES_CHANGED"
    Tracking:Schedule(preserveRequests)
end)
