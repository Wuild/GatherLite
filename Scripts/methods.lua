local name, _GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GatherLite", true)
local GFrame = LibStub("GatherLiteFrame");
local Semver = LibStub("Semver");

local tracker = {
    nodeID = nil,
    spellType = nil,
    spellID = nil,
    target = nil,
    ended = nil
};

_GatherLite.db = {
    mining = {},
    herbalism = {}
};

GatherLite.NewVersionExists = false;

local spellIDs = {
    [GetSpellInfo(2575)] = "mining", -- Mining
    [GetSpellInfo(2366)] = "herbalism" -- Herbalism
};

_GatherLite.mainFrame = CreateFrame("Frame", nil, UIParent)

local function ucfirst(str)
    return (str:gsub("^%l", string.upper))
end

function GatherLite:print(...)
    print(GatherLite:Colorize("<" .. _GatherLite.name .. ">", "yellow"), ...)
end

-- print debug message
function GatherLite:debug(type, ...)
    if (GatherLite.db.global.debug.enabled) and GatherLite.db.global.debug.types[type] then
        print(GatherLite:Colorize("<" .. _GatherLite.name .. " - " .. (_GatherLite.debug[type] or _GatherLite.debug[_GatherLite.DEBUG_DEFAULT]) .. ">", "blue"), ...)
    end
end

function GatherLite:translate(key, ...)
    local arg = { ... };

    if not L[key] then
        return key
    end

    for i, v in ipairs(arg) do
        arg[i] = tostring(v);
    end
    return string.format(L[key], unpack(arg))
end

function GatherLite:tablelength(T)
    local count = 0
    if T then
        for _ in pairs(T) do
            count = count + 1
        end
    end
    return count
end

function GatherLite:Colorize(str, color)
    local c = '';
    if color == 'red' then
        c = '|cffff0000';
    elseif color == 'gray' then
        c = '|cFFCFCFCF';
    elseif color == 'purple' then
        c = '|cFFB900FF';
    elseif color == 'blue' then
        c = '|cB900FFFF';
    elseif color == 'yellow' then
        c = '|cFFFFB900';
    elseif color == 'green' then
        c = "|cFF00FF00";
    elseif color == 'white' then
        c = "|cffffffff"
    elseif color == 'cyan' then
        c = "|cff00FFFF"
    end
    return c .. str .. "|r"
end

function GatherLite:findSpellType(spell)
    local spellInfo = GetSpellInfo(spell);

    -- see if spell is in our list
    for k, s in pairs(spellIDs) do
        if k == spellInfo then
            return s;
        end
    end ;

    -- spell was not found
    return nil;
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function GatherLite:findLoot(list, name)
    for item, data in pairs(list) do
        if data.name == name then
            return item
        end
    end
end

function GatherLite:findNodeType(target)
    for index, object in pairs(_GatherLite.nodeDB) do
        if (string.lower(target) == string.lower(GatherLite:translate("node." .. object.name))) then
            return object.id[1];
        end
    end

    return nil;
end

function GatherLite:IsNodeInRange(myPosX, myPosY, nodePosX, nodePosY, spellType)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    return distance < 0.0065
end

function GatherLite:findExistingNode(type, mapID, x, y)
    for k, node in pairs(_GatherLite.db[type]) do
        if node.mapID == mapID and GatherLite:IsNodeInRange(x, y, node.posX, node.posY, type) then
            return node;
        end
    end
    return nil;
end

function GatherLite:findExistingLocalNode(type, mapID, x, y)
    for k, node in pairs(self.db.global.nodes[type]) do
        if node.mapID == mapID and GatherLite:IsNodeInRange(x, y, node.posX, node.posY, type) then
            return node;
        end
    end
    return nil;
end

function GatherLite:RegisterNode(type, nodeID, mapID, posX, posY, loot, coin)
    if (IsInInstance()) then
        return
    end

    if (GatherLite:findExistingLocalNode(type, mapID, posX, posY)) then
        return
    end

    local node = {
        type = type,
        object = nodeID,
        mapID = mapID,
        posX = posX,
        posY = posY,
        loot = {},
        coins = 0,
        date = date('*t')
    };

    table.insert(GatherLite.db.global.nodes[type], node);

    GatherLite:createMinimapNode(node);
    GatherLite:createWorldmapNode(node);
end

function GatherLite:UpdateNode(type, nodeID, mapID, posX, posY)
    local loot = {};
    local coin = 0;
    local count = GetNumLootItems()

    local node = GatherLite:findExistingLocalNode(type, mapID, posX, posY);

    if not node then
        return
    end

    node.date = date('*t')

    if count == 0 then
        GatherLite:debug(_GatherLite.DEBUG_NODE, "does not contain any items... skipping");
        return
    end

    for i = 1, count do
        local lIcon, lName, lQuantity, lQuality, locked, isQuestItem = GetLootSlotInfo(i)
        local slotType = GetLootSlotType(i)
        local lLink = GetLootSlotLink(i)
        if not isQuestItem then
            if (not lLink and slotType == LOOT_SLOT_MONEY) then
                local i, j, val
                i, j, val = string.find(lName, COPPER_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then
                    coin = coin + val
                end
                i, j, val = string.find(lName, SILVER_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then
                    coin = coin + (val * 100)
                end
                i, j, val = string.find(lName, GOLD_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then
                    coin = coin + (val * 10000)
                end
                if (coin == 0) then
                    table.insert(loot, {
                        name = lName,
                        count = tonumber(lQuantity),
                        link = lLink
                    })
                end
            else
                table.insert(loot, {
                    name = lName,
                    count = tonumber(lQuantity),
                    link = lLink
                })
            end
        end
    end

    node.coins = node.coins + coin;

    for k, item in pairs(loot) do
        local exists = GatherLite:findLoot(node.loot, item.name);
        if not exists then
            table.insert(node.loot, {
                name = item.name,
                count = item.count,
                link = item.link
            })
        else
            node.loot[exists].count = node.loot[exists].count + item.count;
        end
    end

    local oldNode = GatherLite:findExistingNode(type, mapID, posX, posY);
    if oldNode then


        oldNode.loot = node.loot;
        oldNode.coins = node.coins;
    end
    GatherLite:debug(_GatherLite.DEBUG_NODE, "Node loot updated")
end

function GatherLite:EventHandler(event, ...)

    if event == "PLAYER_ENTERING_WORLD" then
        GatherLite:LoadMinimap()
    elseif event == "LOOT_OPENED" then
        if (tracker.spellID and tracker.ended and GetTime() - tracker.ended < 1) then
            local x, y, mapID = HBD:GetPlayerZonePosition()
            GatherLite:UpdateNode(tracker.spellType, tracker.nodeID, mapID, x, y);
            tracker.nodeID = nil;
            tracker.target = nil;
            tracker.spellID = nil;
            tracker.spellType = nil;
        end
    elseif (event == "UNIT_SPELLCAST_SENT") or (event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED") then
        local spell = select(4, ...)
        local target = select(2, ...)
        local spellType = GatherLite:findSpellType(spell)

        if (event == "UNIT_SPELLCAST_SENT" and target and spellType) then
            local nodeID = GatherLite:findNodeType(target)
            if (nodeID) then
                local x, y, mapID = HBD:GetPlayerZonePosition()
                GatherLite:RegisterNode(spellType, nodeID, mapID, x, y)
                tracker.nodeID = nodeID
                tracker.target = target
                tracker.spellID = spell
                tracker.spellType = spellType
            end
        elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
            tracker.ended = GetTime()
        elseif ((event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED")) then
            tracker.nodeID = nil
            tracker.target = nil
            tracker.spellID = nil
            tracker.spellType = nil
        end
    end
end

function GatherLite:leadingZeros(value)
    value = tonumber(value);
    if (value < 10) then
        return "0" .. value;
    end ;
    return value;
end

function GatherLite:showTooltip(self)
    local node = self.node
    local object = self.object

    GameTooltip:ClearLines();
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
    GameTooltip:AddLine(GatherLite:translate("node." .. object.name));
    if self.node.type then
        GameTooltip:AddLine(ucfirst(self.node.type), "gray")
    end
    GameTooltipTextLeft2:SetTextColor(190, 190, 190)

    local type = self.node.type

    if type == "herb" then
        type = "herbalism"
    end

    local lootTable = false

    if self.type == "minimap" then
        lootTable = GatherLite.db.char.minimap.loot;
    elseif self.type == "worldmap" then
        lootTable = GatherLite.db.char.worldmap.loot;
    end

    local coins = node.coins

    if node.loot and lootTable then
        for k, item in pairs(node.loot) do
            if item.count > 0 then
                GameTooltip:AddDoubleLine(item.link, "x" .. item.count);
            else
                GameTooltip:AddDoubleLine(item.link, "");
            end
        end
    end

    if node.date then
        GameTooltip:AddDoubleLine("Last visit:", GatherLite:Colorize(GatherLite:leadingZeros(node.date.day) .. '/' .. GatherLite:leadingZeros(node.date.month) .. '/' .. GatherLite:leadingZeros(node.date.year) .. " - " .. GatherLite:leadingZeros(node.date.hour) .. ':' .. GatherLite:leadingZeros(node.date.min) .. ':' .. GatherLite:leadingZeros(node.date.sec), "white"));
    end

    if coins and coins > 0 then
        SetTooltipMoney(GameTooltip, coins)
    end

    GameTooltip:Show();
end

function GatherLite:hideTooltip()
    GameTooltip:Hide();
end

function GatherLite:GetNodeObject(nodeID)
    for index, node in pairs(_GatherLite.nodeDB) do
        if type(node.id) == "table" then
            for idIndex, id in pairs(node.id) do
                if id == nodeID then
                    return node
                end
            end
        end
    end
end

function GatherLite:createMinimapNode(node, id)
    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    local f = GFrame:getFrame("minimap");
    f:SetAlpha(GatherLite.db.char.minimap.opacity);
    f:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)
    f.texture:SetTexture(object.icon)

    f.node = node;
    f.object = object
    f.type = "minimap";

    f.TimeSinceLastUpdate = 0

    f:SetScript("OnUpdate", function(self, elapsed)
        local angle, distance = Pins:GetVectorToIcon(self);
        if GatherLite.db.char.tracking[self.node.type] and distance and distance < GatherLite.db.char.minimap.distance then
            self:SetAlpha(0)
            self:EnableMouse(false)
        else
            self:SetAlpha(GatherLite.db.char.minimap.opacity)
            self:EnableMouse(true)
        end
    end)

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID)
    Pins:AddMinimapIconWorld(_GatherLite.name, f, instance, x, y, false)
    return f;
end

function GatherLite:createWorldmapNode(node)
    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    local f = GFrame:getFrame("worldmap");
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    f.texture:SetTexture(object.icon)
    f:SetBackdropColor(1, 0, 0, 1);

    f.node = node;
    f.object = object
    f.type = "worldmap";
    f.TimeSinceLastUpdate = 0

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    Pins:AddWorldMapIconMap(_GatherLite.name, f, node.mapID, node.posX, node.posY);
    return f;
end

function GatherLite:addContextItem(args)
    local info = UIDropDownMenu_CreateInfo()
    info.text = args.text;
    info.checked = args.checked;
    info.func = args.callback;
    info.icon = args.icon;
    info.isTitle = args.isTitle;
    info.disabled = args.disabled;
    info.notCheckable = args.notCheckable;
    UIDropDownMenu_AddButton(info)
end

function GatherLite:MinimapContextMenu()
    return function(frame, level, menuList)
        if level == 1 then
            GatherLite:addContextItem({
                text = _GatherLite.name,
                isTitle = true,
                notCheckable = true
            });

            GatherLite:addContextItem({
                text = GatherLite:translate('mining'),
                icon = GetItemIcon(2770),
                checked = GatherLite.db.char.tracking.mining,
                callback = function()
                    GatherLite.db.char.tracking.mining = not GatherLite.db.char.tracking.mining
                    GatherLite:LoadMinimap()
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('herbalism'),
                icon = GetItemIcon(765),
                checked = GatherLite.db.char.tracking.herbalism,
                callback = function()
                    GatherLite.db.char.tracking.herbalism = not GatherLite.db.char.tracking.herbalism
                    GatherLite:LoadMinimap()
                end
            })
        end
    end
end

function GatherLite:LoadWorldmapNode(node, mapID)
    if not GatherLite.db.char.tracking[node.type] then
        node.loadedWorldmap = false
        return false
    end

    if node.predefined and not GatherLite.db.global.usePredefined then
        node.loadedWorldmap = false
        return false
    end

    if GatherLite:IsIgnored(node.object) then
        node.loadedWorldmap = false
        return false
    end

    if mapID == node.mapID then

    else
        node.loadedWorldmap = false
        return false
    end

    if mapID == node.mapID and not node.loadedWorldmap then
        node.loadedWorldmap = true
        GatherLite:createWorldmapNode(node)
        return true
    end

end

function GatherLite:LoadWorldmap()
    local mapID = WorldMapFrame.mapID;
    for a, nodes in pairs(_GatherLite.db) do
        for k, node in pairs(nodes) do
            if GatherLite:LoadWorldmapNode(node, mapID) then
            end
        end
    end

    for b, frame in pairs(GFrame.usedFrames) do
        if frame.type == "worldmap" and not frame.node.loadedWorldmap then
            frame:Unload()
        end
    end
end

function GatherLite:IsIgnored(objectID)
    return GatherLite.db.char.ignore[objectID] or false
end

function GatherLite:SetIgnored(object, value)
    for i, id in pairs(object.id) do
        GatherLite.db.char.ignore[id] = value
    end
end

function GatherLite:LoadMinimapNode(node, x, y, instanceID)
    local x2, y2 = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
    local angle, distance = HBD:GetWorldVector(instanceID, x, y, x2, y2)

    if not GatherLite.db.char.tracking[node.type] then
        node.loaded = false
        return false
    end

    if node.predefined and not GatherLite.db.global.usePredefined then
        node.loaded = false
        return false
    end

    if GatherLite:IsIgnored(node.object) then
        node.loaded = false
        return false
    end

    if distance < 500 and not node.loaded then
        node.loaded = true
        GatherLite:createMinimapNode(node)
        return true
    end

    if node.loaded and distance >= 500 then
        node.loaded = false
        return false
    end
end

local worldmapOpen = false;

function GatherLite:LoadMinimap()
    local i = 0
    local x, y, instanceID = HBD:GetPlayerWorldPosition()

    if (IsInInstance()) then
        for b, frame in pairs(GFrame.usedFrames) do
            if frame.type == "minimap" and not frame.node.loaded then
                frame:Unload()
            end
        end
        return
    end

    for a, nodes in pairs(_GatherLite.db) do
        for k, node in pairs(nodes) do
            if GatherLite:LoadMinimapNode(node, x, y, instanceID) then
                i = i + 1
            end
        end
    end

    for b, frame in pairs(GFrame.usedFrames) do
        if frame.type == "minimap" and not frame.node.loaded then
            frame:Unload()
        end
    end

    GatherLite:debug(_GatherLite.DEBUG_FRAME, GatherLite:tablelength(GFrame.usedFrames), "used,", GatherLite:tablelength(GFrame.unusedFrames), "unused")
end

function GatherLite:Load()
    for k, node in pairs(GatherLite_localOreNodes) do
        node.coins = 0
        node.loot = {}
        node.predefined = true
        table.insert(_GatherLite.db.mining, node)
    end

    for k, node in pairs(GatherLite_localHerbNodes) do
        node.coins = 0
        node.loot = {}
        node.predefined = true
        table.insert(_GatherLite.db.herbalism, node)
    end

    for k, node in pairs(self.db.global.nodes.mining) do
        local oldNode = GatherLite:findExistingNode("mining", node.mapID, node.posX, node.posY);
        if oldNode then
            oldNode.loot = node.loot
            oldNode.coins = 0
            oldNode.date = node.date
            oldNode.predefined = false;
        else
            table.insert(_GatherLite.db.mining, node)
        end
    end

    for k, node in pairs(self.db.global.nodes.herbalism) do
        local oldNode = GatherLite:findExistingNode("herbalism", node.mapID, node.posX, node.posY);
        if oldNode then
            oldNode.loot = node.loot
            oldNode.coins = 0
            oldNode.date = node.date
            oldNode.predefined = false;
        else
            table.insert(_GatherLite.db.herbalism, node)
        end
    end

    local WorldmapOpen = false;

    _GatherLite.mainFrame:SetScript("OnUpdate", function()
        if WorldMapFrame:IsVisible() and not WorldmapOpen then
            WorldmapOpen = true;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "load worldmap")
        end

        if WorldmapOpen then
            GatherLite:LoadWorldmap()
        end

        if not WorldMapFrame:IsVisible() and WorldmapOpen then
            WorldmapOpen = false;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "unload worldmap")
            for b, frame in pairs(GFrame.usedFrames) do
                if frame.type == "worldmap" then
                    frame:Unload()
                end
            end
        end
    end)
end

function GatherLite:SendVersionCheck()
    if IsInGuild() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "GUILD")
    end

    if IsInGroup() and not IsInRaid() and not IsActiveBattlefieldArena() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "PARTY")
    end

    if IsInRaid() and not IsActiveBattlefieldArena() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "RAID")
    end
end

function GatherLite:VersionCheck(event, msg, channel, sender)
    local success, message = GatherLite:Deserialize(msg);
    if not success then
        return
    end

    local removeVersion = Semver:Parse(message);
    if not removeVersion then
        return
    end

    local localVersion = Semver:Parse(_GatherLite.version);
    if not localVersion then
        return
    end

    if localVersion < removeVersion and not GatherLite.NewVersionExists then
        GatherLite.NewVersionExists = true;
        GatherLite:print("A new version of", _GatherLite.name, "has been detected, please visit curseforge.com to download the latest version, or use the twitch app to keep you addons updated")
    end

    GatherLite:debug(_GatherLite.DEBUG_P2P, "Version check from", channel, sender, message)
end

function GatherLite:ShowSettings()
    LibStub("AceConfigDialog-3.0"):Open("GatherLite", GatherLite.OptionsPanel)
end

function GatherLite:GetRequiredLevel(name)
    for index, node in pairs(_GatherLite.nodeDB) do
        if name == GatherLite:translate("node." .. node.name) then
            return node.levels
        end
    end
    return nil
end

function GatherLite:GetObject(name)
    for index, node in pairs(_GatherLite.nodeDB) do
        if name == GatherLite:translate("node." .. node.name) then
            return node
        end
    end
    return nil
end

function GatherLite:GetProfessionLevel(name)
    local numSkills = GetNumSkillLines();
    for i = 1, numSkills do
        local skillname, _, _, skillrank, _, skillmodifier = GetSkillLineInfo(i)
        if skillname:lower() == name:lower() then
            return (skillrank or 0 + skillmodifier or 0)
        end
    end

    return 0
end