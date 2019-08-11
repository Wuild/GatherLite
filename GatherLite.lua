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
        GatherLite.print("Showing map nodes");
    elseif msg == "map off" then
        GatherLiteGlobalSettings.UseMap = "Off"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("|cffff0017Hiding map nodes");
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
        GatherLite.print("Showing minimap nodes");
    elseif msg == "minimap off" then
        GatherLiteGlobalSettings.UseMiniMap = "Off"
        GatherLite.NeedMapUpdate = true
        GatherLite.print("|cffff0017Hiding minimap nodes");
    elseif msg == "reset" then
        GatherLiteGlobalSettings.NodesDatabase = {};
        GatherLite.NeedMapUpdate = true
    elseif msg == "mining" then
        if (GatherLiteGlobalSettings.ShowMining) then
            GatherLiteGlobalSettings.ShowMining = false
            GatherLite.print("|cffff0017Mining nodes disabled");
        else
            GatherLiteGlobalSettings.ShowMining = true
            GatherLite.print("Mining nodes enabled");
        end;
        GatherLite.NeedMapUpdate = true
    elseif msg == "herbs" then
        if (GatherLiteGlobalSettings.ShowHerbs) then
            GatherLiteGlobalSettings.ShowHerbs = false
            GatherLite.print("|cffff0017Herb nodes disabled");
        else
            GatherLiteGlobalSettings.ShowHerbs = true
            GatherLite.print("Herb nodes enabled");
        end;
        GatherLite.NeedMapUpdate = true
    elseif msg == "treasures" then
        if (GatherLiteGlobalSettings.ShowTreasure) then
            GatherLiteGlobalSettings.ShowTreasure = false
            GatherLite.print("|cffff0017Treasure nodes disabled");
        else
            GatherLiteGlobalSettings.ShowTreasure = true
            GatherLite.print("Treasure nodes enabled");
        end;
        GatherLite.NeedMapUpdate = true
    elseif msg == "help" then
        GatherLite.help();
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

function spawnMarker(node, minimap)
    local icon = "Interface\\AddOns\\GatherLite\\Icons\\" .. node.type .. node.LootType .. ".tga";
    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.PosX, node.PosY, node.MapID);
    local f = CreateFrame('FRAME', 'GatherLiteMapNodePin', WorldMapFrame.ScrollContainer.Child)

    f:SetPoint("TOPLEFT", x, (y * -1)) -- convert Y axis to negative number to draw pin from top left anchor
    f:SetSize(12, 12)
    f:SetFrameLevel(4)
    f:SetFrameStrata("HIGH")
    f:EnableKeyboard(true)
    f:SetPropagateKeyboardInput(true)

    f:SetScript('OnEnter', function()
        GatherLite.tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
        GatherLite.tooltip:SetText(node.Target)
        if not minimap then
            GatherLite.tooltip:AddLine(node.VisitDate.day .. '/' .. node.VisitDate.month .. '/' .. node.VisitDate.year .. " - " .. node.VisitDate.hour .. ':' .. node.VisitDate.min .. ':' .. node.VisitDate.sec, 1, 1, 1)
        end
        GatherLite.tooltip:Show()
    end)

    f:SetScript('OnLeave', function()
        GatherLite.tooltip:Hide()
    end)

    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(icon)

    if minimap then
        Pins:AddMinimapIconWorld("GathererClassic", f, instance, x, y, false);
    else
        Pins:AddWorldMapIconWorld("GathererClassic", f, instance, x, y);
    end;
end

function GatherLite.UpdateMapPins()
    Pins:RemoveAllWorldMapIcons("GathererClassic")
    GatherLite.debug("Updating map markers");
    if GatherLiteGlobalSettings.ShowMining and GatherLiteGlobalSettings.NodesDatabase["Ore"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Ore"]) do
            spawnMarker(node);
        end
    end

    if GatherLiteGlobalSettings.ShowHerbs and GatherLiteGlobalSettings.NodesDatabase["Herb"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Herb"]) do
            spawnMarker(node);
        end
    end

    if GatherLiteGlobalSettings.ShowTreasures and GatherLiteGlobalSettings.NodesDatabase["Treasure"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Treasure"]) do
            spawnMarker(node);
        end
    end
end

function GatherLite.UpdateMiniMapPins()
    Pins:RemoveAllMinimapIcons("GathererClassic")
    GatherLite.debug("Updating minimap markers");
    if GatherLiteGlobalSettings.ShowMining and GatherLiteGlobalSettings.NodesDatabase["Ore"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMiniMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Ore"]) do
            spawnMarker(node, true);
        end
    end

    if GatherLiteGlobalSettings.ShowHerbs and GatherLiteGlobalSettings.NodesDatabase["Herb"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMiniMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Herb"]) do
            spawnMarker(node, true);
        end
    end

    if GatherLiteGlobalSettings.ShowTreasures and GatherLiteGlobalSettings.NodesDatabase["Treasure"] ~= nil and GatherLiteGlobalSettings.Enabled == "On" and GatherLiteGlobalSettings.UseMiniMap == "On" then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase["Treasure"]) do
            spawnMarker(node, true);
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

function trim(s)
    -- from PiL2 20.4
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function GatherLite.OnEvent(self, event, ...)
    if event == 'UNIT_SPELLCAST_SENT' then

        GatherLite.debug("Casting spell " .. select(4, ...));

        -- 3365 chests
        if select(4, ...) == 2575 then -- mining
            local LootItemID = select(2, ...)
            local oreTypeClass = string.gsub(string.gsub(string.gsub(string.gsub(LootItemID, "br\195\188hschlammbedecktes ", ""), "kleines ", ""), "reiches ", ""), "br\195\188hschlammbedeckte ", "");
            local oreType, oreClass;
            if string.find(LootItemID, "Vein") then
                oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass) - string.len("Vein"));
                oreClass = "Vein";
            end

            if string.find(LootItemID, "Deposite") then
                oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass) - string.len("Deposite"));
                oreClass = "Deposite";
            end
            addItem("Ore", trim(LootItemID), trim(oreType), trim(oreClass));

        elseif select(4, ...) == 2366 then --herbs
            local LootItemID = select(2, ...)
            addItem("Herb", trim(LootItemID), trim(LootItemID), nil);
        elseif select(4, ...) == 3365 then --chests
            local LootItemID = select(2, ...)
            addItem("Treasure", trim(LootItemID), "Chest", nil);
        end
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        GatherLite.NeedMapUpdate = true;
        GatherLite.help();
    end;

    if event == 'ADDON_LOADED' and select(1, ...) == 'GatherLite' then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = { AddonName = 'GatherLite', NodesDatabase = {}, debugging = false, Enabled = "On", UseMap = "On", UseMiniMap = "On", ShowMining = true, ShowHerbs = true, ShowTreasure = true }
        end
        GatherLite.print("Version " .. Addon.version .. ' Loaded')
    end
end

function GatherLite.help()
    print("|cffffffff/gather (on|off)|r - turns the gather display on and off");
    print("|cffffffff/gather minimap (on|off)|r - turns the gather minimap display on and off");
    print("|cffffffff/gather mining|r - toggle showing mining nodes");
    print("|cffffffff/gather herbs|r - toggle showing herbs nodes");
    print("|cffffffff/gather treasures|r - toggle showing treasures nodes");
    print("|cffffffff/gather debugging (on|off)|r - show debug messages");
    print("|cffffffff/gather reload|r - reload nodes");
    print("|cffffffff/gather reset|r - reset gather data");
    print("|cffffffff/gather help|r - show GatherLite commands");
end

function addItem(type, target, oreType, oreClass)
    GatherLite.CurrentMapID = C_Map.GetBestMapForUnit('player')
    GatherLite.CurrentMapPosition = C_Map.GetPlayerMapPosition(GatherLite.CurrentMapID, 'player')
    GatherLite.CurrentMapName = C_Map.GetMapInfo(GatherLite.CurrentMapID).name

    if (GatherLiteGlobalSettings.NodesDatabase[type] == nil) then
        GatherLiteGlobalSettings.NodesDatabase[type] = {};
    end;

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
            Target = target,
            type = type,
            MapName = GatherLite.CurrentMapName,
            MapID = GatherLite.CurrentMapID,
            PosX = GatherLite.CurrentMapPosition.x,
            PosY = GatherLite.CurrentMapPosition.y,
            VisitDate = date('*t'),
            LootType = oreType,
            LootClass = oreClass
        }
        table.insert(GatherLiteGlobalSettings.NodesDatabase[type], node)
        GatherLite.NeedMapUpdate = true;
        GatherLite.debug("Adding new marker");
    end
end

GatherLite.MainFrame:SetScript('OnEvent', GatherLite.OnEvent)
GatherLite.MainFrame:SetScript('OnUpdate', GatherLite.OnUpdate)