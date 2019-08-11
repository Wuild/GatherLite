-- updated gatherer addon

local name, GatherLite = ...
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local Addon = {
    name = name,
    version = "1.0.3"
}

GatherLite.GatherSpellRange = 0.0065 --this is roughly double the mining spell range HOWEVER this may need checking with time and adjusting, the idea being we can find a matching node even if player stands on opposites sides.

GatherLite.NodeUpdated = false
GatherLite.NeedMapUpdate = false;

GatherLite.Skill = {
    Mining = nil,
    Herbs = nil
};

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
SLASH_GATHER2 = '/GATHERER'
SlashCmdList['GATHER'] = function(msg)
    if msg == 'reload' then
        GatherLite.print("Reloading map");
        GatherLite.NeedMapUpdate = true;
    elseif msg == "debugging on" then
        GatherLiteGlobalSettings.debugging = true
        GatherLite.NeedMapUpdate = true
        GatherLite.print("debugging enabled");
    elseif msg == "debugging off" then
        GatherLiteGlobalSettings.debugging = false
        GatherLite.NeedMapUpdate = true
        GatherLite.print("debugging disabled");
    elseif msg == "reset" then
        GatherLiteGlobalSettings.NodesDatabase = {};
        GatherLite.NeedMapUpdate = true
    elseif msg == "reset mining" then
        GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_ORE] = {};
        GatherLite.NeedMapUpdate = true
    elseif msg == "reset herbs" then
        GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_HERB] = {};
        GatherLite.NeedMapUpdate = true
    elseif msg == "reset treasures" then
        GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_TREASURE] = {};
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
    local icon;

    local smallType = string.lower(node.LootType);

    if GatherLite.icons[node.type] and GatherLite.icons[node.type][smallType] then
        icon = GatherLite.icons[node.type][smallType];
    elseif GatherLite.icons[node.type] then
        icon = GatherLite.icons[node.type]["default"];
    else
        icon = GatherLite.icons["default"];
    end

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
    if GatherLiteConfigCharacter.enabled then
        GatherLite.debug("Updating map markers");
        local count = 0;
        if GatherLiteConfigCharacter.mining and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_ORE] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_ORE]) do
                spawnMarker(node);
                count = k;
            end
            GatherLite.debug("Showing |cff32CD32(" .. count .. ")|r mining nodes");
        end
        count = 0;
        if GatherLiteConfigCharacter.herbs and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_HERB] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_HERB]) do
                spawnMarker(node);
                count = k;
            end
            GatherLite.debug("Showing |cff32CD32(" .. count .. ")|r herb nodes");
        end
        count = 0;
        if GatherLiteConfigCharacter.treasures and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_TREASURE] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_TREASURE]) do
                spawnMarker(node);
                count = k;
            end
            GatherLite.debug("Showing |cff32CD32(" .. count .. ")|r treasure nodes");
        end
    end
end

function GatherLite.UpdateMiniMapPins()
    Pins:RemoveAllMinimapIcons("GathererClassic")
    if GatherLiteConfigCharacter.enabled then
        GatherLite.debug("Updating minimap markers");
        if GatherLiteConfigCharacter.mining and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_ORE] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_ORE]) do
                spawnMarker(node, true);
            end
        end

        if GatherLiteConfigCharacter.herbs and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_HERB] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_HERB]) do
                spawnMarker(node, true);
            end
        end

        if GatherLiteConfigCharacter.treasures and GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_TREASURE] ~= nil then
            for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[GatherLite.locale.CAT_TREASURE]) do
                spawnMarker(node, true);
            end
        end
    end
end

function trim(s)
    -- from PiL2 20.4
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function GatherLite.help()
    GatherLite.print("|cffffffff/gather debugging (on|off)|r - show debug messages");
    GatherLite.print("|cffffffff/gather reload|r - reload nodes");
    GatherLite.print("|cffffffff/gather reset|r - reset gather data");
    GatherLite.print("|cffffffff/gather help|r - show GatherLite commands");
end

function addItem(type, target, oreType, oreClass)

    local CurrentMapID, CurrentMapPosition, CurrentMapName, NodeUpdated;
    CurrentMapID = C_Map.GetBestMapForUnit('player')
    CurrentMapPosition = C_Map.GetPlayerMapPosition(CurrentMapID, 'player')
    CurrentMapName = C_Map.GetMapInfo(CurrentMapID).name

    if (GatherLiteGlobalSettings.NodesDatabase[type] == nil) then
        GatherLiteGlobalSettings.NodesDatabase[type] = {};
    end;

    NodeUpdated = false

    if GatherLiteGlobalSettings.NodesDatabase ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.NodesDatabase[type]) do
            if GatherLite.IsNodeInRange(CurrentMapPosition.x, CurrentMapPosition.y, node.PosX, node.PosY) then
                NodeUpdated = true
            end
        end
    end

    if not NodeUpdated then
        local node = {
            GUID = UnitGUID('player'),
            Target = target,
            type = type,
            MapName = CurrentMapName,
            MapID = CurrentMapID,
            PosX = CurrentMapPosition.x,
            PosY = CurrentMapPosition.y,
            VisitDate = date('*t'),
            LootType = oreType,
            LootClass = oreClass
        }
        table.insert(GatherLiteGlobalSettings.NodesDatabase[type], node)
        GatherLite.NeedMapUpdate = true;
        GatherLite.debug("Adding new marker");
    else
        GatherLite.debug("Found existing marker");
    end
end

function Gather_OnLoad(self)
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('UNIT_SPELLCAST_SENT')
    self:RegisterEvent('ADDON_LOADED')
end

function Gather_OnUpdate()
    if GatherLite.NeedMapUpdate then
        GatherLite.UpdateMiniMapPins();
        GatherLite.UpdateMapPins();
        GatherLite.NeedMapUpdate = false;
    end;
end

function Gather_OnEvent(self, event, ...)
    if event == 'UNIT_SPELLCAST_SENT' then

        GatherLite.debug("Casting spell " .. select(4, ...));

        if select(4, ...) == 2575 then -- mining
            local LootItemID = select(2, ...)
            local oreTypeClass = string.gsub(string.gsub(string.gsub(string.gsub(LootItemID, "br\195\188hschlammbedecktes ", ""), "kleines ", ""), "reiches ", ""), "br\195\188hschlammbedeckte ", "");
            local oreType, oreClass;
            if string.find(LootItemID, GatherLite.locale.ORE_CLASS_VEIN) then
                oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass) - string.len(GatherLite.locale.ORE_CLASS_VEIN));
                oreClass = GatherLite.locale.ORE_CLASS_VEIN;
            end

            if string.find(LootItemID, GatherLite.locale.ORE_CLASS_DEPOSIT) then
                oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass) - string.len(GatherLite.locale.ORE_CLASS_DEPOSIT));
                oreClass = GatherLite.locale.ORE_CLASS_DEPOSIT;
            end
            addItem(GatherLite.locale.CAT_ORE, trim(LootItemID), trim(oreType), trim(oreClass));

        elseif select(4, ...) == 2366 then --herbs
            local LootItemID = select(2, ...)
            addItem(GatherLite.locale.CAT_HERB, trim(LootItemID), trim(LootItemID), nil);
        elseif select(4, ...) == 3365 then --chests
            local LootItemID = select(2, ...)
            addItem(GatherLite.locale.CAT_TREASURE, trim(LootItemID), "Chest", nil);
        end
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        GatherLite.NeedMapUpdate = true;
        GatherLite.help();
    end;

    if event == "ADDON_LOADED" and select(1, ...) == "GatherLite" then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = { NodesDatabase = {}, debugging = false }
        end

        GatherLite.print("Version " .. Addon.version .. ' Loaded')
        -- Unregister this event, since there is no further use for it:
        self:UnregisterEvent("ADDON_LOADED")
    end
end