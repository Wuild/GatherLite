-- updated gatherer addon

local name, GatherLite = ...
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local Addon = {
    name = name,
    version = "1.0.0"
}

GatherLite.MapNodeCache = {}

GatherLite.MainFrame = CreateFrame('FRAME', nil, UIParent)
GatherLite.MainFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
GatherLite.MainFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
GatherLite.MainFrame:RegisterEvent('CHAT_MSG_LOOT')
GatherLite.MainFrame:RegisterEvent('ADDON_LOADED')

GatherLite.CurrentMapID = nil;
GatherLite.CurrentMapPosition = nil;
GatherLite.CurrentMapName = nil;

GatherLite.GatherSpellRange = 0.0065 --this is roughly double the mining spell range HOWEVER this may need checking with time and adjusting, the idea being we can find a matching node even if player stands on opposites sides.

GatherLite.IsForagingSpellCast = false --was last cast a loot node spell
GatherLite.NodeUpdated = false
GatherLite.LootUpdated = false
GatherLite.LastLootSpell = nil; -- mining or herbs
GatherLite.ForagingTarget = nil; -- what was spell cast at (vein, herb)
GatherLite.NeedMapUpdate = false;

GatherLite.print = function(text)
    print("|cffF0E68C[" .. Addon.name .. "]|cffFFFFFF: " .. text .. "|r")
end

GatherLite.debug = function(text)
    if (GatherLiteGlobalSettings.debugging) then
        print("|cff008080[" .. Addon.name .. " - Debugging]|cffFFFFFF: " .. text .. "|r")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- WORLD MAP TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.tooltip = CreateFrame("GameTooltip", nil, UIParent, "GameTooltipTemplate")
GatherLite.tooltip:ClearLines()
GatherLite.tooltip:AddFontStrings(GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));

-----------------------------------------------------------------------------------------------------------------------------------
-- SLASH COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------
SLASH_GATHER1 = '/GATHER'
SlashCmdList['GATHER'] = function(msg)
    if msg == "on" then
        GatherLiteGlobalSettings.Enabled = "On"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("enabled");
    elseif msg == "off" then
        GatherLiteGlobalSettings.Enabled = "Off"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("|cffff0017disabled");
    elseif msg == 'reload' then
        GatherLite.print("Reloading map");
        GatherLite.NeedMapUpdate = true;
    elseif msg == "map on" then
        GatherLiteGlobalSettings.UseMap = "On"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("Showing map markers");
    elseif msg == "map off" then
        GatherLiteGlobalSettings.UseMap = "Off"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("|cffff0017Hiding map markers");
    elseif msg == "debugging on" then
        GatherLiteGlobalSettings.debugging = true
        GatherLite.NeedMapUpdate = true
        GatherLite.print("debugging enabled");
    elseif msg == "debugging off" then
        GatherLiteGlobalSettings.debugging = false
        GatherLite.NeedMapUpdate = true
        GatherLite.print("debugging disabled");
    elseif msg == "minimap on" then
        GatherLiteGlobalSettings.UseMiniMap = "On"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("Showing minimap markers");
    elseif msg == "minimap off" then
        GatherLiteGlobalSettings.UseMiniMap = "Off"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("|cffff0017Hiding minimap markers");
    end
end

--find the item id from the hyperlink string
function GatherLite.ItemIDFromLootString(str)
    local s = string.find(str, 'Hitem:')
    local t = string.sub(str, s + 6)
    local f = string.find(t, ':')
    local n = string.sub(t, 1, f - 1)
    --print(n)
    return n
end

function GatherLite.ItemLootCountFromString(str)
    local s = string.find(str, '|r')
    --print('|r is at', s, 'length is', string.len(str))
    local c = string.sub(str, s + 1)
    --print(c)
    if string.find(c, 'x') then
        return tonumber(string.sub(str, s + 3, string.len(str) - 1)) --ignore full stop '.' at end
    else
        return 1 -- return 1 if no 'x?' in string
    end
end

--check node coords with current coords, if within double spell range then assume same node (not often to find 2 nodes together and if player does then loot info will be combined)
function GatherLite.IsNodeInRange(myPosX, myPosY, nodePosX, nodePosY)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    if distance < GatherLite.GatherSpellRange then
        return true
    else
        return false
    end
end


function GatherLite.UpdateMapPins()
    Pins:RemoveAllWorldMapIcons("GathererClassic")
    GatherLite.debug("Updating map markers");
    if GatherLiteGlobalSettings.NodesDatabase ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase) do
            local icon = GetItemIcon(node.LootItem);
            local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.PosX, node.PosY, node.MapID);
            local f = CreateFrame('FRAME', 'GatherLiteMapNodePin' .. k, WorldMapFrame.ScrollContainer.Child)

            f:SetPoint("TOPLEFT", x, (y * -1)) -- convert Y axis to negative number to draw pin from top left anchor
            f:SetSize(12, 12)
            f:SetFrameLevel(4)
            f:SetFrameStrata("HIGH")
            f:EnableKeyboard(true)
            f:SetPropagateKeyboardInput(true)

            f:SetScript('OnEnter', function()
                GatherLite.tooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
                GatherLite.tooltip:SetText(node.LootLink)
                GatherLite.tooltip:Show()
            end)

            f:SetScript('OnLeave', function()
                GatherLite.tooltip:Hide()
            end)

            f.texture = f:CreateTexture(nil, 'ARTWORK')
            f.texture:SetAllPoints(f)
            f.texture:SetTexture(icon)

            Pins:AddWorldMapIconWorld("GathererClassic", f, instance, x, y);
        end
    end
end

function GatherLite.UpdateMiniMapPins()
    Pins:RemoveAllMinimapIcons("GathererClassic")
    GatherLite.debug("Updating minimap markers");
    if GatherLiteGlobalSettings.NodesDatabase ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMiniMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase) do
            local icon = GetItemIcon(node.LootItem);
            local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.PosX, node.PosY, node.MapID);
            local f = CreateFrame('FRAME', 'GatherLiteMapNodePin' .. k, WorldMapFrame.ScrollContainer.Child)

            f:SetPoint("TOPLEFT", x, (y * -1)) -- convert Y axis to negative number to draw pin from top left anchor
            f:SetSize(12, 12)
            f:SetFrameLevel(4)
            f:SetFrameStrata("HIGH")
            f:EnableKeyboard(true)
            f:SetPropagateKeyboardInput(true)
            f.texture = f:CreateTexture(nil, 'ARTWORK')
            f.texture:SetAllPoints(f)
            f.texture:SetTexture(icon)

            f:SetScript('OnEnter', function()
                GatherLite.tooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
                GatherLite.tooltip:SetText(node.LootLink)
                GatherLite.tooltip:Show()
            end)

            f:SetScript('OnLeave', function()
                GatherLite.tooltip:Hide()
            end)

            Pins:AddMinimapIconWorld("GathererClassic", f, instance, x, y, false);
        end
    end
end

function GatherLite.OnUpdate()
    if GatherLite.NeedMapUpdate then
        GatherLite.UpdateMiniMapPins();
        GatherLite.UpdateMapPins();
        GatherLite.NeedMapUpdate = false;
    end;
end

function GatherLite.OnEvent(self, event, ...)
    if event == 'UNIT_SPELLCAST_SENT' then

        GatherLite.debug("Casting spell " .. select(4, ...));

        if select(4, ...) == 2575 then -- mining
            GatherLite.LastLootSpell = 2575
            GatherLite.IsForagingSpellCast = true
            GatherLite.ForagingTarget = select(2, ...)
        elseif select(4, ...) == 2366 then --herbs
            GatherLite.LastLootSpell = 2366
            GatherLite.IsForagingSpellCast = true
            GatherLite.ForagingTarget = select(2, ...)
        else
            GatherLite.LastLootSpell = nil
            GatherLite.IsForagingSpellCast = false
            GatherLite.ForagingTarget = nil;
        end
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        GatherLite.NeedMapUpdate = true;
    end;

    if event == 'CHAT_MSG_LOOT' and GatherLite.IsForagingSpellCast == true then
        --grab current position
        GatherLite.CurrentMapID = C_Map.GetBestMapForUnit('player')
        GatherLite.CurrentMapPosition = C_Map.GetPlayerMapPosition(GatherLite.CurrentMapID, 'player')
        GatherLite.CurrentMapName = C_Map.GetMapInfo(GatherLite.CurrentMapID).name

        if (GatherLiteGlobalSettings.NodesDatabase == nil) then
            GatherLiteGlobalSettings.NodesDatabase = {};
        end;

        --variables just for ease of reading
        local LootItemID = GatherLite.ItemIDFromLootString(select(1, ...))

        --reset the bool check
        GatherLite.NodeUpdated = false
        GatherLite.LootUpdated = false

        if GatherLiteGlobalSettings.NodesDatabase ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase) do
                if GatherLite.IsNodeInRange(GatherLite.CurrentMapPosition.x, GatherLite.CurrentMapPosition.y, node.PosX, node.PosY) then
                    GatherLite.NodeUpdated = true
                    GatherLite.debug("Found existing marker");
                end
            end
        end

        if GatherLite.NodeUpdated == false then
            local node = {
                GUID = UnitGUID('player'),
                Target = GatherLite.ForagingTarget,
                LootSpell = GatherLite.LastLootSpell,
                MapName = GatherLite.CurrentMapName,
                MapID = GatherLite.CurrentMapID,
                PosX = GatherLite.CurrentMapPosition.x,
                PosY = GatherLite.CurrentMapPosition.y,
                VisitDate = date('*t'),
                LootItem = LootItemID,
                LootLink = select(2, GetItemInfo(LootItemID))
            }
            table.insert(GatherLiteGlobalSettings.NodesDatabase, node)
            GatherLite.NeedMapUpdate = true;
            GatherLite.debug("Adding new marker");
        end
    end

    if event == 'ADDON_LOADED' and select(1, ...) == 'GatherLite' then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = { AddonName = 'GatherLite', NodesDatabase = {}, debugging = false, Enabled = "On", UseMap = "On", UseMiniMap = "On" }
        end
        print('|cff628B57' .. Addon.name .. " version " .. Addon.version .. ' Loaded')
    end
end

GatherLite.MainFrame:SetScript('OnEvent', GatherLite.OnEvent)
GatherLite.MainFrame:SetScript('OnUpdate', GatherLite.OnUpdate)