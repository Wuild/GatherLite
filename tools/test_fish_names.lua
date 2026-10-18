local addon={}
local events,timers,requests={},{},{}
function CreateFrame()
    return {RegisterEvent=function(_,event) events[event]=true end,
        SetScript=function(_,_,fn) events.dispatch=fn end}
end
C_Timer={After=function(_,fn) timers[#timers+1]=fn end}
local names={[6291]="Сырая блестящая рыбка"}
C_Item={GetItemNameByID=function(id) return names[id] end,
    RequestLoadItemDataByID=function(id) requests[id]=(requests[id] or 0)+1 end}
assert(loadfile("plugins/fishing/data.lua"))("GatherLite",addon)
assert(loadfile("plugins/fishing/names.lua"))("GatherLite",addon)
local byID={}
for _,fish in ipairs(addon.fishDB) do byID[fish.itemID]=fish end
assert(byID[6291].name==names[6291] and not requests[6291],"cached names must use the client locale")
assert(byID[6289].name=="Raw Longjaw Mud Snapper" and requests[6289]==1,
    "uncached names must retain a usable fallback and request item data")
events.dispatch(nil,"PLAYER_LOGIN")
assert(requests[6289]==1,"login must not duplicate pending requests")
local refreshes,lists=0,0
addon.Fishing={Refresh=function() refreshes=refreshes+1 end}
addon.Window={ready=true,object=byID[6289],selection={SetText=function(self,text) self.text=text end},
    RefreshList=function() lists=lists+1 end}
names[6289]="Сырая острозубая илистая рыба"
events.dispatch(nil,"ITEM_DATA_LOAD_RESULT",6289,true)
assert(byID[6289].name==names[6289])
events.dispatch(nil,"ITEM_DATA_LOAD_RESULT",4603,false)
assert(byID[4603].name=="Raw Spotted Yellowtail","failed item loads must preserve fallback names")
assert(#timers==1,"item data updates must batch UI refreshes")
timers[1]()
assert(refreshes==1 and lists==1 and addon.Window.selection.text==names[6289],
    "late localized data must refresh search, selection and catch pins")
events.dispatch(nil,"ITEM_DATA_LOAD_RESULT",999999,true)
assert(#timers==1,"unrelated item data must not refresh fish UI")
print("Fish names passed: cached Russian names, async localization, batched views and fallback names")
