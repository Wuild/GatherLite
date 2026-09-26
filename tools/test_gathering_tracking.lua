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
C_Minimap={GetNumTrackingTypes=function() return #entries end,
    GetTrackingInfo=function(i) return entries[i] end,
    SetTracking=function(i,on)
        assert(not combat and not dead)
        calls[#calls+1]=i
        for _,entry in ipairs(entries) do entry.active=false end
        entries[i].active=on
    end}
local refreshes=0
GatherLite={db={char={minimap={tracking={}},worldmap={tracking={}}}},
    Trigger=function() refreshes=refreshes+1 end}
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
entries={{spellID=2580,active=false},{spellID=2383,active=false},{spellID=123,active=true}}
char.autoGatherTracking=false; tracking:Check(); assert(#calls==0,"explicitly disabled tracking must stay disabled")
char.autoGatherTracking=nil -- Missing preference uses the enabled default.
combat=true; tracking:Check(); assert(#calls==0)
combat=false; dead=true; tracking:Check(); assert(#calls==0)
dead=false; tracking:Check(); assert(#calls==1 and calls[1]==1)
tracking:Check(); assert(#calls==1,"active mode must not be reactivated")
tracking:Prefer("herb"); tracking:Schedule(); assert(#timers==1,"events must coalesce")
flush(); assert(#calls==2 and calls[2]==2)
tracking:Check(); assert(#calls==2,"mutually exclusive modes must not alternate")
combat=true; tracking:Prefer("ore"); flush(); assert(#calls==2)
combat=false; events.dispatch(nil,"PLAYER_REGEN_ENABLED"); flush()
assert(#calls==3 and calls[3]==1,"preferred mode must restore after combat")
entries={{spellID=2383,active=false}}; tracking:Check()
assert(#calls==4 and entries[1].active,"unlearned preference must fall back to an available gathering spell")
entries={{spellID=999,active=false}}; tracking:Check(); assert(#calls==4)
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
char.gatherTrackingKind="ore"
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
assert(not char.minimap.tracking.mining,"periodic spell checks must preserve manual filters")
print("Periodic tracking passed: five-second recovery, disabled setting, combat/death, active spells and single ticker")
