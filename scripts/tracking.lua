local _, addon = ...
local Tracking = {}
addon.GatheringTracking = Tracking
local spells = {ore=2580, herb=2383}
local spellNames = {[2580]="Find Minerals",[2383]="Find Herbs"}
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

function Tracking:Check()
    local settings = GatherLite.db and GatherLite.db.char
    if not settings then return end
    debugState("spell preference","automatic="..tostring(settings.autoGatherTracking~=false)
        ..", preferred="..(spellNames[spells[settings.gatherTrackingKind]] or "keep active / first available"))
    if not C_Minimap or not C_Minimap.GetNumTrackingTypes or not C_Minimap.GetTrackingInfo
        or not C_Minimap.SetTracking then
        debugState("spells","Tracking API unavailable")
        return
    end
    local available, active = {}, nil
    for index=1,C_Minimap.GetNumTrackingTypes() do
        local info=C_Minimap.GetTrackingInfo(index)
        if info and (info.spellID==2580 or info.spellID==2383) then
            available[info.spellID]={index=index,active=info.active}
            if info.active then active=info.spellID end
        end
    end
    for _,id in ipairs({2580,2383}) do
        local entry=available[id]
        debugState("spell "..id,spellNames[id]..": "..(entry and (entry.active and "active" or "available, inactive") or "not available"))
    end
    if settings.autoGatherTracking==false then
        debugState("spell action","Automatic activation disabled")
        return
    end
    if InCombatLockdown() then debugState("spell action","Deferred until combat ends"); return end
    if UnitIsDeadOrGhost("player") then debugState("spell action","Deferred while dead or a ghost"); return end
    -- Only enable entries offered by the client. Never cast an unlearned spell
    -- or alternate two mutually exclusive gathering modes.
    local preferred=spells[settings.gatherTrackingKind]
    local spell=preferred and available[preferred] and preferred or active
        or (available[2580] and 2580) or (available[2383] and 2383)
    local entry=spell and available[spell]
    if not entry then
        debugState("spell action","No available gathering tracking spell")
    elseif entry.active then
        debugState("spell action",spellNames[spell].." already active; no change")
    else
        debugState("spell action","Requesting activation: "..spellNames[spell].." (index "..entry.index..")")
        C_Minimap.SetTracking(entry.index,true)
        local result=C_Minimap.GetTrackingInfo(entry.index)
        debugState("activation result",spellNames[spell]..": "..(result and result.active and "active" or "awaiting tracking update"))
    end
end

function Tracking:Schedule()
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

function Tracking:Prefer(kind)
    if not spells[kind] or not GatherLite.db then return end
    GatherLite.db.char.gatherTrackingKind=kind
    self:Schedule()
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
    Tracking:Schedule()
end)
