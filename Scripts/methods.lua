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

_GatherLite.tooltip = CreateFrame("GameTooltip", "GatherLiteTooltip", UIParent, "GameTooltipTemplate")
_GatherLite.tooltip:ClearLines()
_GatherLite.tooltip:AddFontStrings(_GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), _GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));

function GatherLite:print(...)
    print(GatherLite:Colorize("<" .. _GatherLite.name .. ">", "yellow"), ...)
end

-- print debug message
function GatherLite:debug(...)
    if (GatherLite.db.char.debugging) then
        print(GatherLite:Colorize("<" .. _GatherLite.name .. " - Debugging>", "blue"), ...)
    end
end

function GatherLite:translate(key, ...)
    local arg = { ... };
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
    for name, id in pairs(_GatherLite.nodes.names) do
        if (string.lower(target) == string.lower(name)) then
            return id;
        end

        --if (string.find(string.lower(target), string.lower(index))) then
        --    return ore;
        --end
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
        GatherLite:debug("Found existing node.")
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
    GatherLite:debug("Node saved")

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
        GatherLite:debug("Node does not contain any items... skipping");
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
    GatherLite:debug("Node loot updated")
end

function GatherLite:EventHandler(event, ...)
    if event == "LOOT_OPENED" then
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
                GatherLite:debug(mapID)
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

function GatherLite:findNodeName(objectID)
    for name, index in pairs(_GatherLite.nodes.names) do
        if (objectID == index) then
            return name;
        end
    end

    return nil;
end

function GatherLite:leadingZeros(value)
    value = tonumber(value);
    if (value < 10) then
        return "0" .. value;
    end ;
    return value;
end

function GatherLite:showTooltip(self)
    local node = self.node;
    local nodeName = GatherLite:findNodeName(self.node.object);

    if not nodeName then
        return
    end

    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:SetOwner(self, "TOP");
    _GatherLite.tooltip:SetText(nodeName);

    if node.date then
        _GatherLite.tooltip:AddDoubleLine("Last visit:", GatherLite:Colorize(GatherLite:leadingZeros(node.date.day) .. '/' .. GatherLite:leadingZeros(node.date.month) .. '/' .. GatherLite:leadingZeros(node.date.year) .. " - " .. GatherLite:leadingZeros(node.date.hour) .. ':' .. GatherLite:leadingZeros(node.date.min) .. ':' .. GatherLite:leadingZeros(node.date.sec), "white"));
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
                _GatherLite.tooltip:AddDoubleLine(item.link, "x" .. item.count);
            else
                _GatherLite.tooltip:AddDoubleLine(item.link, "");
            end
        end
    end

    if coins and coins > 0 then
        SetTooltipMoney(_GatherLite.tooltip, coins)
    end

    _GatherLite.tooltip:Show();
end

function GatherLite:hideTooltip()
    _GatherLite.tooltip:Hide();
end

function GatherLite:UpdateNodes()
    local x, y, mapID = HBD:GetPlayerZonePosition()
    for index, frame in pairs(GFrame.allFrames) do
        if frame.node.predefined and not self.db.global.predefined then
            frame:FakeHide();
        elseif GatherLite.db.char.ignoreOres[frame.node.object] or GatherLite.db.char.ignoreHerbs[frame.node.object] then
            frame:FakeHide();
        else
            if (frame.type == "minimap") and frame.node.mapID == mapID then
                local angle, distance = Pins:GetVectorToIcon(frame);
                if GatherLite.db.char.tracking[frame.node.type] and distance and distance < GatherLite.db.char.minimap.distance then
                    frame:FakeHide();
                elseif GatherLite.db.char.tracking[frame.node.type] then
                    frame:FakeShow();
                else
                    frame:FakeHide();
                end
            end
            if (frame.type == "worldmap") then
                if GatherLite.db.char.tracking[frame.node.type] then
                    frame:FakeShow();
                else
                    frame:FakeHide();
                end
            end
        end
    end
end

function GatherLite:createMinimapNode(node)
    local f = GFrame:getFrame("minimap");
    f:SetAlpha(GatherLite.db.char.minimap.opacity);
    f:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)

    if _GatherLite.nodes.icons[node.object] then
        f.texture:SetTexture("Interface\\AddOns\\GatherLite\\icons\\" .. _GatherLite.nodes.icons[node.object])
    else
        f.texture:SetTexture("Interface\\AddOns\\GatherLite\\icons\\notfound")
    end

    f.node = node;
    f.type = "minimap";

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID)
    Pins:AddMinimapIconWorld(GatherLite, f, instance, x, y, false)
    return f;
end

function GatherLite:createWorldmapNode(node)
    local f = GFrame:getFrame("worldmap");
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)

    if _GatherLite.nodes.icons[node.object] then
        f.texture:SetTexture("Interface\\AddOns\\GatherLite\\icons\\" .. _GatherLite.nodes.icons[node.object])
    else
        f.texture:SetTexture("Interface\\AddOns\\GatherLite\\icons\\notfound")
    end
    f.node = node;
    f.type = "worldmap";

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    Pins:AddWorldMapIconMap(GatherLite, f, node.mapID, node.posX, node.posY);
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
                    if GatherLite.db.char.tracking.mining then
                        GatherLite.db.char.tracking.mining = false;
                    else
                        GatherLite.db.char.tracking.mining = true;
                    end

                    GatherLite:UpdateNodes()
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('herbalism'),
                icon = GetItemIcon(765),
                checked = GatherLite.db.char.tracking.herbalism,
                callback = function()
                    if GatherLite.db.char.tracking.herbalism then
                        GatherLite.db.char.tracking.herbalism = false;
                    else
                        GatherLite.db.char.tracking.herbalism = true;
                    end

                    GatherLite:UpdateNodes()
                end
            })
        end
    end
end

function GatherLite:LoadWorldmap()
    local mapID = WorldMapFrame.mapID;

    for k, frame in pairs(GFrame.allFrames) do
        if frame.type == "worldmap" then
            frame:Unload();
        end
    end

    for k, node in pairs(_GatherLite.db.mining) do
        if node.mapID == mapID then
            local frame = GatherLite:createWorldmapNode(node);

            if frame.node.predefined and not self.db.global.predefined then
                frame:FakeHide();
            end
        end
    end

    for k, node in pairs(_GatherLite.db.herbalism) do
        if node.mapID == mapID then
            local frame = GatherLite:createWorldmapNode(node);

            if frame.node.predefined and not self.db.global.predefined then
                frame:FakeHide();
            end
        end
    end

    GatherLite:UpdateNodes()
end

function GatherLite:LoadMinimap()
    for k, node in pairs(_GatherLite.db.mining) do
        if node.mapID then
            GatherLite:createMinimapNode(node);
        end
    end

    for k, node in pairs(_GatherLite.db.herbalism) do
        if node.mapID then
            GatherLite:createMinimapNode(node);
        end
    end
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

    GatherLite:LoadMinimap()
end

function GatherLite:SendVersionCheck()
    if IsInGuild() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "GUILD")
    end

    if IsInGroup() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "PARTY")
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

    GatherLite:debug("[GatherLite:VersionCheck] from", sender, message)
end