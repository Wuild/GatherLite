local _, addon = ...
local pending = {}
local refreshPending

local function refreshViews()
    if refreshPending then return end
    refreshPending=true
    C_Timer.After(0,function()
        refreshPending=nil
        local window=addon.Window
        if window and window.ready then
            window:RefreshList()
            if window.object and window.object.type=="fish" then
                window.selection:SetText(window.object.name)
            end
        end
        if addon.Fishing then addon.Fishing:Refresh() end
    end)
end

local function localize(fish)
    local localized=C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(fish.itemID)
    if localized and localized~="" then
        local changed=fish.name~=localized
        fish.name=localized
        pending[fish.itemID]=nil
        return changed,true
    end
end

local function loadNames()
    for _,fish in ipairs(addon.fishDB) do
        local _,resolved=localize(fish)
        if not resolved and not pending[fish.itemID] and C_Item and C_Item.RequestLoadItemDataByID then
            pending[fish.itemID]=fish
            C_Item.RequestLoadItemDataByID(fish.itemID)
        end
    end
end

local events=CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("ITEM_DATA_LOAD_RESULT")
events:SetScript("OnEvent",function(_,event,itemID,success)
    if event=="PLAYER_LOGIN" then
        loadNames()
        refreshViews()
    elseif pending[itemID] then
        local fish=pending[itemID]
        pending[itemID]=nil
        if success and localize(fish) then refreshViews() end
    end
end)
loadNames()
