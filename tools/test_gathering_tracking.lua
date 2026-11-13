local addon={DEBUG_DEFAULT=1}
local events,timers={},{}
local mapX,mapScale=850,1
Minimap={GetCenter=function() return mapX end,GetEffectiveScale=function() return mapScale end}
UIParent={GetCenter=function() return 500 end,GetEffectiveScale=function() return 1 end}
local badge, badgeCount, closeButton
local function noop() end
function CreateFrame(frameType,_,parent,template)
    if badge and parent==badge then
        assert(frameType=="Button" and template=="UIPanelCloseButton")
        closeButton={SetSize=noop, SetPoint=noop, SetScript=function(self,event,fn) self[event]=fn end}
        return closeButton
    end
    if parent then
        assert(frameType=="Button" and parent==Minimap,"clickable reminder must follow the minimap")
        badgeCount=(badgeCount or 0)+1
        badge={labels={}, ClearAllPoints=noop,
            SetPoint=function(self,point,anchor,relativePoint,x)
                assert(anchor==Minimap); self.point,self.relativePoint,self.offset=point,relativePoint,x
            end,
            SetClampedToScreen=noop,
            SetFrameStrata=function(self,strata) self.strata=strata end,
            SetSize=function(self,width,height) self.width,self.height=width,height end,
            RegisterForClicks=noop, SetScript=function(self,event,fn) self[event]=fn end,
            Show=function(self) self.shown=true end, Hide=function(self) self.shown=false end,
            CreateTexture=function() return {SetAllPoints=noop, SetPoint=noop, SetColorTexture=noop,
                SetWidth=noop, SetHeight=noop, SetSize=noop,
                SetTexture=function(_,path) badge.icon=path end} end,
            CreateFontString=function(self,_,_,font)
                local label={font=font, SetPoint=noop, SetWidth=noop, SetWordWrap=noop, SetJustifyH=noop,
                    SetText=function(self,text) self.text=text end, GetStringHeight=function() return 12 end}
                self.labels[#self.labels+1]=label
                return label
            end}
        return badge
    end
    return {RegisterEvent=function(_,event) events[event]=true end,
        SetScript=function(_,_,fn) events.dispatch=fn end}
end
C_Timer={After=function(_,fn) timers[#timers+1]=fn end,
    NewTicker=function() error("native tracking must have no automatic ticker") end}
local trackers,activated={},{}
local clickInProgress,menuItems
C_Minimap={GetNumTrackingTypes=function() return #trackers end,
    GetTrackingInfo=function(index) return trackers[index] end,
    SetTracking=function(index,enabled)
        assert(clickInProgress and enabled,"only an explicit click may enable native tracking")
        activated[#activated+1]=index
        trackers[index].active=true
    end}
MenuUtil={CreateContextMenu=function(owner,generate)
    assert(owner==badge,"the choices menu must belong to the reminder")
    menuItems={}
    generate(owner,{CreateTitle=noop, CreateButton=function(_,name,callback,id)
        menuItems[#menuItems+1]={name=name,click=function() callback(id) end}
    end})
end}
local function click(callback,owner)
    clickInProgress=true
    callback(owner)
    clickInProgress=false
end
local dead,inInstance,combat=false,false,false
function UnitIsDeadOrGhost() return dead end
function IsInInstance() return inInstance end
function InCombatLockdown() return combat end
local skills,ready={},true
C_SkillInfo={GetNumSkillLines=function() return ready and 5 or 0 end,
    GetSkillLineInfoByID=function(id) return skills[id] and {rank=skills[id]} end}
local refreshes,settingsChanged=0,nil
-- An opt-in saved by a previous version must leave native tracking alone.
GatherLite={db={char={autoGatherTracking=true,minimap={enabled=true,tracking={}},worldmap={tracking={}}}},
    On=function(_,event,callback) assert(event=="settings:update"); settingsChanged=callback end,
    Trigger=function(_,event) assert(event=="settings:update"); refreshes=refreshes+1; settingsChanged() end,
    GetNodeTracking=function(self,target,kind) return self.db.char[target].tracking[kind] end,
    translate=function(_,key) return key end,
    IsGamepadUI=function() return InputUtil~=nil and InputUtil.IsGamepadUIEnabled()==true end}
assert(loadfile("scripts/ui.lua"))("GatherLite",addon)
assert(loadfile("scripts/tracking.lua"))("GatherLite",addon)
local function fire(event,...)
    if events[event] then events.dispatch(nil,event,...) end
end
local function flush()
    local queued=timers; timers={}
    for _,fn in ipairs(queued) do fn() end
end
local char=GatherLite.db.char
ready=false; fire("PLAYER_ENTERING_WORLD",true,false); flush()
assert(not char.professionTrackingInitialized,"unavailable skill data must defer initialization")
ready=true
for _,ids in ipairs({{}, {186}, {182}, {186,182}, {356}, {186,182,356}}) do
    skills={}; for _,id in ipairs(ids) do skills[id]=1 end
    local before=refreshes
    fire("SKILL_LINES_CHANGED"); fire("SPELLS_CHANGED")
    assert(#timers==1,"profession events must coalesce")
    flush()
    assert(refreshes==before+1 and char.professionTrackingInitialized,"profession defaults must refresh pins")
    for _,target in ipairs({"minimap","worldmap"}) do
        local state=char[target].tracking
        assert(state.mining==(skills[186]~=nil) and state.herbalism==(skills[182]~=nil))
        assert(state.fishing==(skills[356]~=nil) and state.containers)
    end
end
char.professionTrackingManual=true
char.minimap.tracking.mining=false
skills={}; fire("SKILL_LINES_CHANGED"); flush()
assert(not char.minimap.tracking.mining and char.worldmap.tracking.mining,
    "profession changes must preserve manual per-map filters")

local logs={}
GatherLite.db.global={debug={enabled=true,types={[1]=true}}}
function GatherLite:debug(_,message) logs[#logs+1]=message end
fire("PLAYER_ENTERING_WORLD",false,true); flush()
local output=table.concat(logs,"\n")
assert(output:find("UI reload:",1,true) and output:find("Preserving manual",1,true)
    and output:find("not learned",1,true),"debug logging must still report profession defaults")
local count=#logs
fire("SKILL_LINES_CHANGED"); flush(); assert(#logs==count,"unchanged events must not spam diagnostics")

trackers={{type="other",active=true},{spellID=2580,name="Find Minerals",type="spell",active=false}}
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge,"unchecked Mining must not show a reminder")
char.minimap.tracking.mining=true
settingsChanged()
assert(badge and badge.shown,
    "a learned inactive tracker should show a reminder even when town filters are on")
assert(badge.width==280 and badge.height>=72 and badge.strata=="DIALOG" and badge.icon,
    "tracking reminder must use a full-size card with an icon near the minimap")
assert(badge.labels[1].font=="GameFontNormalLarge" and badge.labels[1].text=="minimap.tracking_reminder"
    and badge.labels[2].text=="minimap.tracking_reminder.hint",
    "tracking card must show a readable heading and instructions")
assert(badge.point=="RIGHT" and badge.relativePoint=="LEFT" and badge.offset==-10,
    "a minimap on the right should open the flyout to its left")
mapScale=.5
badge:OnUpdate(.2)
assert(badge.point=="LEFT" and badge.relativePoint=="RIGHT" and badge.offset==10,
    "the flyout should move to the right when the scaled minimap has more room there")
click(badge.OnClick,badge)
assert(#activated==1 and activated[1]==2 and not menuItems,"a sole tracker should enable directly")
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown,"the reminder must disappear when tracking is enabled")
trackers[2].active=false
trackers[3]={type="spell",active=true}
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown,"any active native spell must suppress the reminder")
trackers[3]=nil
fire("MINIMAP_UPDATE_TRACKING")
assert(badge.shown and badgeCount==1,"turning tracking off must reuse the reminder")

char.minimap.tracking.herbalism=false
trackers[3]={spellID=2383,name="Find Herbs",type="spell",active=false}
click(badge.OnClick,badge)
assert(#activated==1 and #menuItems==2 and menuItems[1].name=="Find Minerals" and menuItems[2].name=="Find Herbs",
    "two learned trackers must open a choice without activating a spell or depending on pin filters")
-- Gamepad UI: no Blizzard menu from addon code; enable the first tracker the filters show.
menuItems=nil
InputUtil={IsGamepadUIEnabled=function() return true end}
char.minimap.tracking.mining=false; char.minimap.tracking.herbalism=true
click(badge.OnClick,badge)
assert(not menuItems and #activated==2 and activated[2]==3,
    "the gamepad UI must enable the first filtered-in tracker instead of opening a menu")
trackers[3].active=false; activated[2]=nil
char.minimap.tracking.mining=true; char.minimap.tracking.herbalism=false
click(badge.OnClick,badge)
assert(not menuItems and #activated==2 and activated[2]==2,
    "the gamepad UI must enable the first tracker when the filters allow it")
trackers[2].active=false; activated[2]=nil
InputUtil=nil
click(badge.OnClick,badge)
assert(#menuItems==2,"the mouse and keyboard UI keeps the native choice menu")
trackers[2],trackers[3]=trackers[3],trackers[2]
click(menuItems[2].click)
assert(#activated==2 and activated[2]==2 and trackers[2].active and not trackers[3].active,
    "a menu selection must enable the chosen spell even if the list has moved")
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown)
trackers[2].active=false
char.minimap.tracking.herbalism=true
fire("MINIMAP_UPDATE_TRACKING")
assert(badge.shown)

combat=true; fire("PLAYER_REGEN_DISABLED"); assert(not badge.shown)
click(menuItems[1].click)
assert(#activated==2,"a stale menu click must not change tracking in combat")
combat=false; fire("PLAYER_REGEN_ENABLED"); assert(badge.shown)

dead=true; fire("PLAYER_DEAD"); assert(not badge.shown)
dead=false; fire("PLAYER_UNGHOST"); assert(badge.shown)
inInstance=true; fire("PLAYER_ENTERING_WORLD"); flush(); assert(not badge.shown)
inInstance=false; fire("PLAYER_ENTERING_WORLD"); flush(); assert(badge.shown)
char.minimap.enabled=false; settingsChanged(); assert(not badge.shown)
char.minimap.enabled=true; settingsChanged(); assert(badge.shown)

trackers={{type="other",active=true}}
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown,"ordinary filters and no learned tracker must keep the reminder hidden")
trackers[2]={type="spell",active=false}
C_Minimap.GetTrackingFilter=function(index) return index==2 and {spellID=2383} or {filterID=1} end
fire("MINIMAP_UPDATE_TRACKING")
assert(badge.shown,"tracking filter metadata must identify learned spells without an ID in the main entry")
C_Minimap.GetTrackingFilter=nil
C_Spell={GetSpellName=function(id) return id==2383 and "Поиск трав" end}
trackers[2].name="Поиск трав"
fire("MINIMAP_UPDATE_TRACKING")
assert(badge.shown,"localized spell names must work when the client omits spell IDs")
local minimapAPI=C_Minimap
C_Minimap=nil
fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown and #timers==0,"an unavailable tracking API must hide the reminder")
C_Minimap=minimapAPI
fire("MINIMAP_UPDATE_TRACKING")
assert(badge.shown)
click(closeButton.OnClick,closeButton)
settingsChanged(); fire("MINIMAP_UPDATE_TRACKING")
assert(not badge.shown and #activated==2,"closing must dismiss the reminder without enabling a tracker")
print("Tracking flyout passed: placement, single and multiple trackers, dismissal and explicit activation")
