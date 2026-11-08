local addon={DEBUG_DEFAULT=1}
local events,timers={},{}
function CreateFrame()
    return {RegisterEvent=function(_,event) events[event]=true end,
        SetScript=function(_,_,fn) events.dispatch=fn end}
end
local tickers={}
C_Timer={After=function(_,fn) timers[#timers+1]=fn end,
    NewTicker=function(seconds,fn)
        local ticker={seconds=seconds,tick=fn}
        tickers[#tickers+1]=ticker
        return ticker
    end}
local combat,dead=false,false
function InCombatLockdown() return combat end
function UnitIsDeadOrGhost() return dead end
local skills,ready={},true
C_SkillInfo={GetNumSkillLines=function() return ready and 5 or 0 end,
    GetSkillLineInfoByID=function(id) return skills[id] and {rank=skills[id]} end}
local entries,calls={},{}
local ignoreRequests=false
C_Minimap={GetNumTrackingTypes=function() return #entries end,
    GetTrackingInfo=function(i) return entries[i] end,
    SetTracking=function(i,on)
        assert(not combat and not dead)
        calls[#calls+1]=i
        if ignoreRequests then return end
        if on then
            for _,entry in ipairs(entries) do
                if entry.type~="other" then entry.active=false end
            end
        end
        entries[i].active=on
    end}
local refreshes=0
GatherLite={db={char={minimap={tracking={}},worldmap={tracking={}}}},
    Trigger=function() refreshes=refreshes+1 end,
    GetNodeTracking=function(self,target,kind) return self.db.char[target].tracking[kind]~=false end}
assert(loadfile("scripts/tracking.lua"))("GatherLite",addon)
local tracking=addon.GatheringTracking
local function flush()
    local queued=timers; timers={}
    for _,fn in ipairs(queued) do fn() end
end
for _,event in ipairs({"PLAYER_ENTERING_WORLD","SKILL_LINES_CHANGED","MINIMAP_UPDATE_TRACKING","PLAYER_REGEN_ENABLED"}) do
    assert(events[event])
end
local char=GatherLite.db.char
ready=false; tracking:UpdateProfessionFilters()
assert(not char.professionTrackingInitialized,"unavailable skill data must defer initialization")
ready=true
for _,ids in ipairs({{}, {186}, {182}, {186,182}, {356}, {186,182,356}}) do
    skills={}; for _,id in ipairs(ids) do skills[id]=1 end
    events.dispatch(nil,"SKILL_LINES_CHANGED"); flush()
    for _,target in ipairs({"minimap","worldmap"}) do
        local state=char[target].tracking
        assert(state.mining==(skills[186]~=nil) and state.herbalism==(skills[182]~=nil))
        assert(state.fishing==(skills[356]~=nil) and state.containers)
    end
end
char.professionTrackingManual=true
char.minimap.tracking.mining=false
skills={}; tracking:UpdateProfessionFilters()
assert(not char.minimap.tracking.mining and char.worldmap.tracking.mining,
    "profession changes must preserve manual per-map filters")
entries={{spellID=2580,active=false},{spellID=2383,active=false},{spellID=123,active=false}}
char.gatherTrackingKind="ore" -- Legacy preference must never override the minimap filters.
char.autoGatherTracking=false; tracking:Check(); assert(#calls==0,"explicitly disabled tracking must stay disabled")
char.autoGatherTracking=nil -- Missing preference uses the enabled default.
combat=true; tracking:Check(); assert(#calls==0)
combat=false; dead=true; tracking:Check(); assert(#calls==0)
dead=false; tracking:Check(); assert(#calls==1 and calls[1]==2 and entries[2].active,
    "auto tracking must follow the minimap even when the world map and legacy preference differ")
tracking:Check(); assert(#calls==1,"an unchecked spell must stay off on later checks")
char.minimap.tracking.herbalism=false
tracking:Schedule(); tracking:Schedule(); assert(#timers==1,"events must coalesce")
flush(); assert(#calls==2 and not entries[2].active,"unchecking an active tracker must turn it off")
tracking:Check(); assert(#calls==2,"when both boxes are unchecked, neither spell may be restored")
char.minimap.tracking.mining=true
combat=true; tracking:Schedule(); flush(); assert(#calls==2)
combat=false; events.dispatch(nil,"PLAYER_REGEN_ENABLED"); flush()
assert(#calls==3 and calls[3]==1 and entries[1].active,"checked mode must restore after combat")
char.minimap.tracking.herbalism=true
entries={{spellID=2383,active=false}}; tracking:Check()
assert(#calls==4 and entries[1].active,"a checked but unavailable spell must not block the other tracker")
entries={{spellID=999,active=false}}; tracking:Check(); assert(#calls==4)

-- Never override another active tracker, such as a hunter's tracking ability.
entries={{spellID=999,active=true},{spellID=2580,active=false}}
local beforeOtherTracker=#calls
tracking:Check(); assert(#calls==beforeOtherTracker,"active non-gathering trackers must be preserved")
entries={{spellID=2580,active=false}}
tracking:Check(); assert(#calls==beforeOtherTracker+1 and entries[1].active,
    "gathering tracking may resume once the other tracker is cleared")
print("Gathering tracking passed: profession defaults, learning/unlearning, manual overrides, activation, combat deferral and event coalescing")

local logs={}
GatherLite.db.global={debug={enabled=true,types={[1]=true}}}
function GatherLite:debug(_,message) logs[#logs+1]=message end
char.autoGatherTracking=false
entries={{spellID=2580,active=false},{spellID=2383,active=true}}
events.dispatch(nil,"PLAYER_ENTERING_WORLD",true,false); flush()
local output=table.concat(logs,"\n")
assert(output:find("Login:",1,true) and output:find("Preserving manual",1,true))
assert(output:find("Find Minerals: available, inactive",1,true) and output:find("Find Herbs: active",1,true))
assert(output:find("Automatic activation disabled",1,true) and output:find("not learned",1,true))
local count=#logs
tracking:Schedule(); flush(); assert(#logs==count,"unchanged events must not spam diagnostics")
GatherLite.db.global.debug.enabled=false
entries={}; tracking:Schedule(); flush(); assert(#logs==count,"debug disabled must be silent")
print("Boot diagnostics passed: professions, manual overrides, inactive spells, disabled activation and deduplicated output")

assert(#tickers==1 and tickers[1].seconds==5)
events.dispatch(nil,"PLAYER_ENTERING_WORLD",false,false); flush()
assert(#tickers==1,"zone changes must not create duplicate tickers")
local ticker=tickers[1]
entries={{spellID=2580,active=false}}
local before=#calls
ticker.tick(); assert(#calls==before,"disabled automation must not activate on interval")
char.autoGatherTracking=true
combat=true; ticker.tick(); assert(#calls==before,"interval must respect combat")
combat=false; dead=true; ticker.tick(); assert(#calls==before,"interval must respect death")
dead=false; ticker.tick(); assert(#calls==before+1 and entries[1].active,"interval must restore tracking without an event")
ticker.tick(); assert(#calls==before+1,"interval must leave active tracking alone")
entries[1].active=false
tracking:Schedule(); ticker.tick(); assert(#calls==before+1,"interval must yield to a pending event check")
flush(); assert(#calls==before+2)
assert(char.minimap.tracking.mining and char.minimap.tracking.herbalism,
    "periodic spell checks must preserve manual filters")
print("Periodic tracking passed: five-second recovery, disabled setting, combat/death, active spells and single ticker")

entries={{spellID=2580,active=true},{spellID=2383,active=false}}
before=#calls
for _=1,3 do
    events.dispatch(nil,"MINIMAP_UPDATE_TRACKING"); flush(); ticker.tick()
end
assert(#calls==before and entries[1].active and not entries[2].active,
    "with both boxes checked, periodic checks must not switch spells and trigger the global cooldown")

-- Simulate manually selecting Herbs from WoW's tracking menu, then dying.
entries[1].active,entries[2].active=false,true
events.dispatch(nil,"MINIMAP_UPDATE_TRACKING"); flush(); ticker.tick()
assert(#calls==before and entries[2].active,"a manual switch must stay in effect")
entries[2].active=false
events.dispatch(nil,"PLAYER_UNGHOST"); flush(); ticker.tick()
assert(#calls==before+1 and entries[2].active and not entries[1].active,
    "restore the last active checked tracker once after resurrection")

entries[1].active=true
ticker.tick()
assert(#calls==before+1 and entries[1].active and entries[2].active,
    "concurrent active trackers must be left alone")
char.minimap.tracking.herbalism=false
tracking:Schedule(); flush(); ticker.tick()
assert(#calls==before+2 and entries[1].active and not entries[2].active,
    "disabling one concurrent tracker must leave the other active")
print("Dual tracking passed: stable tracking, manual selection, restoration and independent toggles")

entries={{spellID=2580,active=false},{spellID=2383,active=false}}
before=#calls
ignoreRequests=true
ticker.tick()
for _=1,3 do
    events.dispatch(nil,"MINIMAP_UPDATE_TRACKING"); flush(); ticker.tick()
end
assert(#calls==before+1,"unconfirmed tracking requests must not repeat on feedback events or timer ticks")
ignoreRequests=false
events.dispatch(nil,"PLAYER_REGEN_ENABLED"); flush(); ticker.tick()
assert(#calls==before+2 and entries[1].active,"a new recovery event can retry a refused request")

-- Forever's ordinary filters coexist with profession tracking. They must not
-- suppress recovery after resurrection on a character with Mining only.
entries={{name="Townsfolk",type="other",active=true},{spellID=2580,type="spell",active=false}}
local beforeFilters=#calls
dead=true; ticker.tick(); assert(#calls==beforeFilters)
dead=false; events.dispatch(nil,"PLAYER_UNGHOST"); flush()
assert(#calls==beforeFilters+1 and calls[#calls]==2,
    "ordinary active minimap filters blocked Mining restoration after death")

-- spellID is nullable in Forever. Exercise both filter metadata and localized
-- spell information rather than assuming the ID is always present.
C_Minimap.GetTrackingFilter=function(i) return i==2 and {spellID=2580} or {filterID=1} end
entries={{type="other",active=true},{type="spell",active=false}}
tracking:Check(); assert(calls[#calls]==2 and entries[2].active)
C_Minimap.GetTrackingFilter=nil
C_Spell={GetSpellName=function(id) return id==2580 and "Поиск минералов" or "Поиск трав" end,
    GetSpellTexture=function(id) return id+1000 end}
entries={{name="Поиск минералов",type="spell",active=false},{type="other",active=true}}
tracking:Check(); assert(calls[#calls]==1 and entries[1].active)
entries={{name="localized variant",texture=3580,type="spell",active=false}}
tracking:Check(); assert(entries[1].active)
entries={{name="Track Beasts",type="spell",active=true},{spellID=2580,type="spell",active=false}}
local beforeSpell=#calls
tracking:Check(); assert(#calls==beforeSpell,"a competing tracking spell must still be preserved")
print("Forever tracking passed: ordinary filters, Mining-only resurrection and nullable spell IDs")
