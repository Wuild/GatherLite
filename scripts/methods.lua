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

_GatherLite.nodes = {
    mining = {},
    herbalism = {},
    containers = {},
    fishing = {},
};

_GatherLite.WorldmapOpen = false;

GatherLite.NewVersionExists = false;

local spellIDs = {
    [GetSpellInfo(2575)] = "mining", -- Mining
    [GetSpellInfo(2366)] = "herbalism", -- Herbalism
    [GetSpellInfo(3365)] = "containers", -- chest
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

    if L[key] == nil then
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
    return distance < 0.01
end

function GatherLite:findExistingNode(type, mapID, x, y)
    for key, node in pairs(GatherLite.db.global.nodes[type]) do
        if node.mapID == mapID and type == node.type and GatherLite:IsNodeInRange(x, y, node.posX, node.posY, type) then
            return node;
        end
    end
    return nil;
end

function GatherLite:findExistingLocalNode(type, mapID, x, y)
    for k, node in pairs(_GatherLite.nodes[type]) do
        if node.mapID == mapID and type == node.type and GatherLite:IsNodeInRange(x, y, node.posX, node.posY, type) then
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

    local _, _, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
    node.instance = instance;
    table.insert(_GatherLite.nodes[type], node)

    GatherLite:UpdateNode(type, nodeID, mapID, posX, posY)

end

function GatherLite:UpdateNode(type, nodeID, mapID, posX, posY)
    local loot = {};
    local coin = 0;
    local count = GetNumLootItems()

    if (IsInInstance()) then
        return
    end

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

    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED" then
        --GatherLite:ResetMinimap()
    elseif event == "LOOT_OPENED" then
        if (tracker.spellID and tracker.ended and GetTime() - tracker.ended < 1) then
            if (IsInInstance()) then
                return
            end

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
    end
    return value;
end

function GatherLite:showTooltip(self)
    local node = self.node
    local object = self.object

    GameTooltip:ClearLines();
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
    GameTooltip:AddLine(GatherLite:translate("node." .. object.name));
    if self.node.type and self.node.type ~= "containers" then
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

    local coins = 0;
    local lastvisit;

    local existingNode = GatherLite:findExistingNode(self.node.type, self.node.mapID, self.node.posX, self.node.posY);

    if existingNode then
        coins = existingNode.coins;
        lastvisit = existingNode.date;

        if existingNode.loot and lootTable then
            for k, item in pairs(existingNode.loot) do
                if item.count > 0 then
                    GameTooltip:AddDoubleLine(item.link, "x" .. item.count);
                else
                    GameTooltip:AddDoubleLine(item.link, "");
                end
            end
        end
    end

    if lastvisit then
        GameTooltip:AddDoubleLine("Last visit:", GatherLite:Colorize(date(nil, time(lastvisit)), "white"));
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
    for k = 1, #_GatherLite.nodeDB do
        local node = _GatherLite.nodeDB[k];
        if type(node.id) == "table" then
            for k2 = 1, #node.id do
                local id = node.id[k2];
                if id == nodeID then
                    return node
                end
            end
        end
    end
end

function GatherLite:createMinimapNode(node)
    if not GatherLite:isLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    GatherLite:debug(_GatherLite.DEBUG_NODE, "Create node of type", node.type);

    local f = GFrame:getFrame("minimap");
    f:SetAlpha(GatherLite.db.char.minimap.opacity);
    f:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)

    f.texture:SetTexture(object.icon)
    f.node = node;
    f.object = object
    f.type = "minimap";

    f:SetFrameStrata(Minimap:GetFrameStrata());
    --f:SetFrameLevel(Minimap:GetFrameLevel() + 5);

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID)
    Pins:AddMinimapIconWorld(_GatherLite.name, f, instance, x, y, GatherLite.db.char.minimap.edge)
    return f;
end

function GatherLite:createWorldmapNode(node)
    if not GatherLite:isLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    local f = GFrame:getFrame("worldmap");
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    f.texture:SetTexture(object.icon)
    f.texture:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    --f:SetBackdropColor(1, 0, 0, 1);

    f.node = node;
    f.object = object
    f.type = "worldmap";
    f.TimeSinceLastUpdate = 0

    f:SetFrameStrata("TOOLTIP");
    --f:SetFrameLevel(0);

    f:SetScript("OnUpdate", nil)

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
                icon = _GatherLite.iconPath .. "Ore/Copper",
                checked = GatherLite.db.char.tracking.mining,
                callback = function()
                    GatherLite.db.char.tracking.mining = not GatherLite.db.char.tracking.mining
                    GatherLite:ResetMinimap()
                    GatherLite:ResetWorldmap()
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('herbalism'),
                icon = _GatherLite.iconPath .. "Herb/Silverleaf",
                checked = GatherLite.db.char.tracking.herbalism,
                callback = function()
                    GatherLite.db.char.tracking.herbalism = not GatherLite.db.char.tracking.herbalism
                    GatherLite:ResetMinimap()
                    GatherLite:ResetWorldmap()
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('containers'),
                icon = _GatherLite.iconPath .. "Open/Chest",
                checked = GatherLite.db.char.tracking.containers,
                callback = function()
                    GatherLite.db.char.tracking.containers = not GatherLite.db.char.tracking.containers
                    GatherLite:ResetMinimap()
                    GatherLite:ResetWorldmap()
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('fish'),
                icon = _GatherLite.iconPath .. "Fish/Fishhook",
                checked = GatherLite.db.char.tracking.fishing,
                callback = function()
                    GatherLite.db.char.tracking.fishing = not GatherLite.db.char.tracking.fishing
                    GatherLite:ResetMinimap()
                    GatherLite:ResetWorldmap()
                end
            })
        end
    end
end

function GatherLite:LoadWorldmap()
    GatherLite:Trigger("worldmap:update")
end

function GatherLite:IsIgnored(objectID)
    return GatherLite.db.char.ignore[objectID] or false
end

function GatherLite:SetIgnored(object, value)
    for i, id in pairs(object.id) do
        GatherLite.db.char.ignore[id] = value
    end
end

function GatherLite:ResetMinimap()
    if not GatherLite:isLoaded() then
        return
    end

    GatherLite:forEach(GFrame.usedFrames, function(frame)
        if frame.type == "minimap" then
            frame.node.loaded = false;
            frame:Unload()
        end
    end)

    GatherLite:LoadMinimap();
end

function GatherLite:ResetWorldmap()
    GatherLite:forEach(GFrame.usedFrames, function(frame)
        if frame.type == "worldmap" then
            frame.node.loadedWorldmap = false;
            frame:Unload()
        end
    end)

    GatherLiteTracker:Worldmap()
end

function GatherLite:forEach(table, cb)
    if (GatherLite:tablelength(table) > 0) then
        for key in pairs(table) do
            cb(table[key]);
        end
    end
end

function GatherLite:LoadMinimap()
    GatherLiteTracker:Minimap(0, true);
end

local function loadDatabase(type)
    GatherLite:forEach(GatherLite.db.global.nodes[type], function(node)
        node.type = type;
        node.coins = 0
        node.loot = {}
        node.predefined = false;
        node.loaded = false;

        local _, _, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
        node.instance = instance;
        table.insert(_GatherLite.nodes[type], node)
    end);
end

local function LoadTable(type, data)
    if data then

        local tableCount = GatherLite:tablelength(data);

        local i = 0;
        local i2 = 0

        GatherLite:forEach(data, function(node)
            local localNode = GatherLite:findExistingLocalNode(type, node.mapID, node.posX, node.posY);
            local existingNode = GatherLite:findExistingNode(type, node.mapID, node.posX, node.posY);
            if not localNode and not existingNode then
                node.type = type;
                node.coins = 0
                node.loot = {}
                node.predefined = true
                node.loaded = false;

                local _, _, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
                node.instance = instance;

                table.insert(_GatherLite.nodes[type], node)
            end

            i = i + 1
            i2 = i2 + 1

            if (i < tableCount) then
                if (i2 == 100) then
                    coroutine.yield()
                    i2 = 0
                end
            else
                GatherLite:print("Loaded", tableCount, type, "nodes")
                GatherLite:ResetMinimap();
                GatherLite:ResetWorldmap();
            end
        end)
    end
end

local tableMiningThread
local tableHerbThread
local tableContainerThread
local tableFishingThread

function GatherLite:isLoaded()
    if coroutine.status(tableMiningThread) == "dead" and coroutine.status(tableHerbThread) == "dead" and coroutine.status(tableContainerThread) == "dead" and coroutine.status(tableFishingThread) == "dead" then
        return true
    end

    return false
end

function GatherLite:Load()

    loadDatabase("mining");
    loadDatabase("herbalism");
    loadDatabase("containers");
    loadDatabase("fishing");

    if GatherLite.db.global.usePredefined then

        GatherLite:print("Loading predefined database, this may cause the game to lag for a few seconds!")

        tableMiningThread = coroutine.create(function()
            GatherLite:print("Loading mining nodes!")
            LoadTable("mining", GatherLite_localOreNodes)
        end)
        coroutine.resume(tableMiningThread);

        tableHerbThread = coroutine.create(function()
            GatherLite:print("Loading herbalism nodes!")
            LoadTable("herbalism", GatherLite_localHerbNodes);
        end)
        coroutine.resume(tableHerbThread);

        tableContainerThread = coroutine.create(function()
            GatherLite:print("Loading container nodes!")
            LoadTable("containers", GatherLite_localContainerNodes);
        end)
        coroutine.resume(tableHerbThread);

        tableFishingThread = coroutine.create(function()
            GatherLite:print("Loading fishing nodes!")
            LoadTable("fishing", GatherLite_localFishingNodes);
        end)
        coroutine.resume(tableHerbThread);
    end

    GatherLite:ResetMinimap();
    GatherLite:ResetWorldmap();

    GatherLiteToggle:SetScript("OnClick", function()
        GatherLite.db.char.worldmap.enabled = not GatherLite.db.char.worldmap.enabled;
        GatherLite:LoadWorldmap();

        if (GatherLite.db.char.worldmap.enabled) then
            GatherLiteToggle:SetText(GatherLite:translate("worldmap.hide"))
            GatherLite:ResetWorldmap()
        else
            GatherLiteToggle:SetText(GatherLite:translate("worldmap.show"))
            GatherLite:ResetWorldmap()
        end
    end);

    _GatherLite.mainFrame:SetScript("OnUpdate", function()
        coroutine.resume(tableMiningThread);
        coroutine.resume(tableHerbThread);
        coroutine.resume(tableContainerThread);
        coroutine.resume(tableFishingThread);

        if WorldMapFrame:IsVisible() and not _GatherLite.WorldmapOpen then
            _GatherLite.WorldmapOpen = true;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "load worldmap")

            GatherLiteToggle:SetPoint('RIGHT', WorldMapFrameCloseButton, 'LEFT', -20, 0);

            if Questie_Toggle then
                GatherLiteToggle:SetPoint('RIGHT', Questie_Toggle, 'LEFT', 0, 0);
            end

            if (GatherLite.db.char.worldmap.enabled) then
                GatherLiteToggle:SetText(GatherLite:translate("worldmap.hide"))
            else
                GatherLiteToggle:SetText(GatherLite:translate("worldmap.show"))
            end
        end

        if not WorldMapFrame:IsVisible() and _GatherLite.WorldmapOpen then
            _GatherLite.WorldmapOpen = false;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "unload worldmap")
        end
    end)
end

function GatherLite:SendVersionCheck()
    if IsInGuild() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "GUILD")
    end

    if IsInGroup() and not IsActiveBattlefieldArena() then
        if IsInRaid() then
            GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "RAID")
        else
            GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "PARTY")
        end
    end

    GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "YELL")
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
    for k = 1, #_GatherLite.nodeDB do
        local node = _GatherLite.nodeDB[k];
        if name == GatherLite:translate("node." .. node.name) then
            return node.levels
        end
    end
    return nil
end

function GatherLite:GetObject(name)
    for k = 1, #_GatherLite.nodeDB do
        local node = _GatherLite.nodeDB[k];
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
