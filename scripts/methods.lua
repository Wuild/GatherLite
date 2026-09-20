local name, _GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GatherLite", true)
local GFrame = LibStub("GatherLiteFrame");
local Semver = LibStub("Semver");
local API = _GatherLite.API

local tracker = {
    nodeID = nil,
    spellType = nil,
    spellID = nil,
    target = nil,
    ended = nil
};

local function resetTracker()
    for key in pairs(tracker) do
        tracker[key] = nil
    end
end

_GatherLite.nodes = {
    mining = {},
    herbalism = {},
    containers = {},
    fishing = {},
};

local NODE_RANGE = 0.0065
local NODE_CELL_INV = 1 / NODE_RANGE

local function newNodeIndex()
    return { byMap = {}, byCell = {}, byMapInstance = {} }
end

_GatherLite.nodeIndex = {
    mining = newNodeIndex(),
    herbalism = newNodeIndex(),
    containers = newNodeIndex(),
    fishing = newNodeIndex(),
};

_GatherLite.savedNodeIndex = {
    mining = newNodeIndex(),
    herbalism = newNodeIndex(),
    containers = newNodeIndex(),
    fishing = newNodeIndex(),
};

_GatherLite.mapInstanceCache = {
    mining = {},
    herbalism = {},
    containers = {},
    fishing = {},
};

_GatherLite.mapScaleCache = {}


GatherLite.NewVersionExists = false;

local spellIDs = {
    [2575] = "mining",
    [2366] = "herbalism",
    [3365] = "containers",
    [1804] = "containers", -- Pick Lock: record outdoor training chests on success.
};


local function ucfirst(str)
    return (str:gsub("^%l", string.upper))
end

local function canShowSupportButton()
    return _GatherLite.supportUrl and _GatherLite.supportUrl ~= ""
end

function GatherLite:ShouldShowReleaseThanks()
    local seen = GatherLite.db and GatherLite.db.global and GatherLite.db.global.lastSeenVersion
    if not seen or seen == "" then
        return true
    end
    if seen == _GatherLite.version then
        return false
    end

    local current = Semver:Parse(_GatherLite.version)
    local last = Semver:Parse(seen)
    if current and last then
        return current > last
    end

    return seen ~= _GatherLite.version
end

function GatherLite:ShowSupportUrl()
    if not canShowSupportButton() then
        return
    end
    if not StaticPopupDialogs["GATHERLITE_SUPPORT_URL"] then
        StaticPopupDialogs["GATHERLITE_SUPPORT_URL"] = {
            text = "Support on " .. (_GatherLite.supportLabel or "Patreon") .. ":\n%s",
            button1 = "Close",
            hasEditBox = true,
            editBoxWidth = 260,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1,
            OnShow = function(self, data)
                local editBox = self.GetEditBox and self:GetEditBox() or self.editBox or self.EditBox
                editBox:SetText(data or "")
                editBox:HighlightText()
                editBox:SetFocus()
            end
        }
    end
    StaticPopup_Show("GATHERLITE_SUPPORT_URL", _GatherLite.supportUrl, nil, _GatherLite.supportUrl)
end

function GatherLite:ShowReleaseThanks()
    if not GatherLite:ShouldShowReleaseThanks() then
        return
    end
    GatherLite.db.global.lastSeenVersion = _GatherLite.version

    if not StaticPopupDialogs["GATHERLITE_RELEASE_THANKS"] then
        StaticPopupDialogs["GATHERLITE_RELEASE_THANKS"] = {
            text = "Thank you for using " .. _GatherLite.name .. " v%s!\nYour support and feedback mean a lot and keep this addon growing.\nIf you enjoy it, please consider supporting my work on " .. (_GatherLite.supportLabel or "Patreon") .. ".",
            button1 = "Thanks!",
            button2 = canShowSupportButton() and (_GatherLite.supportLabel or "Patreon") or nil,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1,
            OnCancel = function()
                GatherLite:ShowSupportUrl()
            end
        }
    end

    C_Timer.After(2, function()
        StaticPopup_Show("GATHERLITE_RELEASE_THANKS", _GatherLite.version)
    end)
end

function GatherLite:print(...)
    print(GatherLite:Colorize("<" .. _GatherLite.name .. ">", "yellow"), ...)
end

-- print debug message
function GatherLite:debug(type, ...)
    local db = GatherLite.db
    if not db or not db.global or not db.global.debug or not db.global.debug.types then
        return
    end
    if db.global.debug.enabled and db.global.debug.types[type] then
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

local function nodeCellCoords(posX, posY)
    return math.floor(posX * NODE_CELL_INV), math.floor(posY * NODE_CELL_INV)
end

-- Normalized coordinates occupy cells 0..153. Reject out-of-map neighbors
-- so numeric keys cannot alias an adjacent row. Keep map IDs separate.
local NODE_CELL_STRIDE = math.floor(NODE_CELL_INV) + 1
local function nodeCellKey(cellX, cellY)
    if cellX < 0 or cellY < 0 or cellX >= NODE_CELL_STRIDE or cellY >= NODE_CELL_STRIDE then
        return nil
    end
    return cellX * NODE_CELL_STRIDE + cellY
end

local function indexNodeInstance(index, node)
    if not node or node.instance == nil or not node.mapID then
        return
    end

    if not index.instanceIndexed then
        index.instanceIndexed = setmetatable({}, { __mode = "k" })
    end
    if index.instanceIndexed[node] then
        return
    end

    local mapBucket = index.byMapInstance[node.mapID]
    if not mapBucket then
        mapBucket = {}
        index.byMapInstance[node.mapID] = mapBucket
    end

    local instanceBucket = mapBucket[node.instance]
    if not instanceBucket then
        instanceBucket = {}
        mapBucket[node.instance] = instanceBucket
    end

    instanceBucket[#instanceBucket + 1] = node
    index.instanceIndexed[node] = true
end

local function indexNode(index, node)
    if not node or not node.mapID or not node.posX or not node.posY then
        return
    end

    local mapBucket = index.byMap[node.mapID]
    if not mapBucket then
        mapBucket = {}
        index.byMap[node.mapID] = mapBucket
    end
    mapBucket[#mapBucket + 1] = node

    local cellX, cellY = nodeCellCoords(node.posX, node.posY)
    local cellKey = nodeCellKey(cellX, cellY)
    if not cellKey then return end
    local cells = index.byCell[node.mapID]
    if not cells then
        cells = {}
        index.byCell[node.mapID] = cells
    end
    local cellBucket = cells[cellKey]
    if not cellBucket then
        cellBucket = {}
        cells[cellKey] = cellBucket
    end
    cellBucket[#cellBucket + 1] = node

    if node.instance ~= nil then
        indexNodeInstance(index, node)
    end
end

local function findIndexedNode(index, mapID, posX, posY, objectID)
    if not index or not mapID or not posX or not posY then
        return nil
    end

    local cells = index.byCell[mapID]
    if not cells then return nil end
    local cellX, cellY = nodeCellCoords(posX, posY)
    for dx = -1, 1 do
        for dy = -1, 1 do
            local cellKey = nodeCellKey(cellX + dx, cellY + dy)
            local cellBucket = cells[cellKey]
            if cellBucket then
                for i = 1, #cellBucket do
                    local node = cellBucket[i]
                    if node.mapID == mapID and (not objectID or node.object == objectID)
                        and GatherLite:IsNodeInRange(posX, posY, node.posX, node.posY) then
                        return node
                    end
                end
            end
        end
    end

    return nil
end

function GatherLite:InvalidateNodeCache(type)
    if _GatherLite.mapInstanceCache[type] then
        _GatherLite.mapInstanceCache[type] = {}
    end
end

function GatherLite:Colorize(str, color)
    if not str then
        return
    end

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
    if API.IsSecret(spell) or spell == nil then
        return nil
    end
    if spellIDs[spell] then
        return spellIDs[spell]
    end
    -- Higher ranks share the localized profession name. Resolve lazily so
    -- missing spell data cannot break addon loading with a nil table key.
    local spellName = API.GetSpellName(spell)
    if API.IsSecret(spellName) or not spellName then
        return nil
    end
    for id, spellType in pairs(spellIDs) do
        if API.GetSpellName(id) == spellName then
            return spellType
        end
    end
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
    return distance < NODE_RANGE
end

function GatherLite:EnsureNodeWorld(node)
    if not node or (node.worldX and node.worldY and node.instance) then
        return
    end

    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
    node.worldX = x
    node.worldY = y
    node.instance = instance

    local index = _GatherLite.nodeIndex[node.type]
    if index then
        indexNodeInstance(index, node)
    end
end

function GatherLite:GetNodesForMap(type, mapID)
    if not mapID then
        return _GatherLite.nodes[type] or {}
    end

    local index = _GatherLite.nodeIndex[type]
    if index and index.byMap[mapID] then
        return index.byMap[mapID]
    end

    return {}
end

function GatherLite:GetNodesForMapRect(type, mapID, left, right, bottom, top)
    if not mapID or left == nil or right == nil or bottom == nil or top == nil then
        return GatherLite:GetNodesForMap(type, mapID)
    end

    local index = _GatherLite.nodeIndex[type]
    if not index then
        return GatherLite:GetNodesForMap(type, mapID)
    end

    local minX = math.max(0, math.min(left, right))
    local maxX = math.min(1, math.max(left, right))
    local minY = math.max(0, math.min(bottom, top))
    local maxY = math.min(1, math.max(bottom, top))

    -- A zone has far fewer nodes than the ~24,000 cells in its full rectangle.
    -- Each node occurs once in byMap, so a separate seen table is unnecessary.
    local nodes = index.byMap[mapID] or {}
    local out = {}
    for i = 1, #nodes do
        local node = nodes[i]
        if node.posX >= minX and node.posX <= maxX and node.posY >= minY and node.posY <= maxY then
            out[#out + 1] = node
        end
    end

    return out
end

function GatherLite:GetNodeIndexStats()
    local stats = {}
    for type, index in pairs(_GatherLite.nodeIndex) do
        local byMapCount = 0
        local byCellCount = 0
        local byMapInstanceCount = 0
        local instanceBucketCount = 0

        for _ in pairs(index.byMap or {}) do
            byMapCount = byMapCount + 1
        end
        for _, cells in pairs(index.byCell or {}) do
            for _ in pairs(cells) do byCellCount = byCellCount + 1 end
        end
        for _, mapBucket in pairs(index.byMapInstance or {}) do
            byMapInstanceCount = byMapInstanceCount + 1
            for _ in pairs(mapBucket) do
                instanceBucketCount = instanceBucketCount + 1
            end
        end

        local cacheMapCount = 0
        local cacheInstanceCount = 0
        local cache = _GatherLite.mapInstanceCache[type] or {}
        for _, instanceBucket in pairs(cache) do
            cacheMapCount = cacheMapCount + 1
            for _ in pairs(instanceBucket) do
                cacheInstanceCount = cacheInstanceCount + 1
            end
        end

        stats[type] = {
            nodes = #(_GatherLite.nodes[type] or {}),
            byMap = byMapCount,
            byCell = byCellCount,
            byMapInstance = byMapInstanceCount,
            instanceBuckets = instanceBucketCount,
            cacheMaps = cacheMapCount,
            cacheInstances = cacheInstanceCount,
        }
    end
    return stats
end

function GatherLite:GetNodesForMapInstance(type, mapID, instanceID)
    if not mapID or instanceID == nil then
        return GatherLite:GetNodesForMap(type, mapID)
    end

    local index = _GatherLite.nodeIndex[type]
    if index and index.byMapInstance[mapID] and index.byMapInstance[mapID][instanceID] then
        return index.byMapInstance[mapID][instanceID]
    end

    local cache = _GatherLite.mapInstanceCache[type]
    if cache[mapID] and cache[mapID][instanceID] then
        return cache[mapID][instanceID]
    end

    local nodes = GatherLite:GetNodesForMap(type, mapID)
    local out = {}
    for i = 1, #nodes do
        local node = nodes[i]
        if not node.instance then
            GatherLite:EnsureNodeWorld(node)
        end
        if node.instance == instanceID then
            out[#out + 1] = node
        end
    end

    if not cache[mapID] then
        cache[mapID] = {}
    end
    cache[mapID][instanceID] = out

    return out
end

function GatherLite:GetMapScale(mapID, instanceID, posX, posY)
    if _GatherLite.mapScaleCache[mapID] then
        return _GatherLite.mapScaleCache[mapID]
    end

    if not mapID or not posX or not posY then
        return nil
    end

    local delta = NODE_RANGE
    local posX2 = math.min(posX + delta, 1)
    local posY2 = posY
    if posX2 == posX then
        posX2 = math.max(posX - delta, 0)
    end

    local wx1, wy1, mapInstance1 = HBD:GetWorldCoordinatesFromZone(posX, posY, mapID)
    local wx2, wy2, mapInstance2 = HBD:GetWorldCoordinatesFromZone(posX2, posY2, mapID)
    if not wx1 or not wx2 then
        return nil
    end

    local instance = instanceID or mapInstance1 or mapInstance2
    if not instance then
        return nil
    end

    local _, distance = HBD:GetWorldVector(instance, wx1, wy1, wx2, wy2)
    if not distance or distance == 0 then
        return nil
    end

    local scale = distance / math.abs(posX2 - posX)
    _GatherLite.mapScaleCache[mapID] = scale
    return scale
end

function GatherLite:GetNearbyNodes(type, mapID, instanceID, posX, posY, maxDist)
    if not mapID or posX == nil or posY == nil or not maxDist then
        return {}
    end

    local index = _GatherLite.nodeIndex[type]
    if not index then
        return {}
    end

    local scale = GatherLite:GetMapScale(mapID, instanceID, posX, posY)
    if not scale then
        return {}
    end

    local cellX, cellY = nodeCellCoords(posX, posY)
    local cellRadius = math.ceil(maxDist / (scale * NODE_RANGE))
    if cellRadius >= NODE_CELL_INV then
        local instance = instanceID
        if instance == nil then
            local _, _, mapInstance = HBD:GetWorldCoordinatesFromZone(posX, posY, mapID)
            instance = mapInstance
        end

        if instance == nil then
            return GatherLite:GetNodesForMap(type, mapID)
        end
        return GatherLite:GetNodesForMapInstance(type, mapID, instance)
    end
    local out = {}
    local cells = index.byCell[mapID]
    if not cells then return out end
    for cx = math.max(0, cellX - cellRadius), math.min(NODE_CELL_STRIDE - 1, cellX + cellRadius) do
        for cy = math.max(0, cellY - cellRadius), math.min(NODE_CELL_STRIDE - 1, cellY + cellRadius) do
            local bucket = cells[nodeCellKey(cx, cy)]
            if bucket then
                for i = 1, #bucket do out[#out + 1] = bucket[i] end
            end
        end
    end

    return out
end

function GatherLite:FindExistingNode(type, mapID, x, y, objectID)
    return findIndexedNode(_GatherLite.savedNodeIndex[type], mapID, x, y, objectID)
end

function GatherLite:findExistingLocalNode(type, mapID, x, y, objectID)
    return findIndexedNode(_GatherLite.nodeIndex[type], mapID, x, y, objectID)
end

function GatherLite:RegisterNode(type, nodeID, mapID, posX, posY, loot, coin)
    if not mapID or not posX or not posY then
        return
    end
    if (IsInInstance()) then
        return
    end

    if GatherLite:FindExistingNode(type, mapID, posX, posY, nodeID) then
        return
    end

    local predefined = GatherLite:findExistingLocalNode(type, mapID, posX, posY, nodeID)

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
    indexNode(_GatherLite.savedNodeIndex[type], node)
    if predefined then
        -- Keep one visible pin while persisting a plain gathered-history record.
        predefined.predefined = false
    else
        table.insert(_GatherLite.nodes[type], node)
        indexNode(_GatherLite.nodeIndex[type], node)
    end
    GatherLite:InvalidateNodeCache(type)

    GatherLite:SendMessage("GatherLiteNodeAdded", node)

end

function GatherLite:UpdateNode(type, nodeID, mapID, posX, posY)
    if not mapID or not posX or not posY then
        return
    end
    local loot = {};
    local coin = 0;
    local count = GetNumLootItems()

    if (IsInInstance()) then
        return
    end

    local node = GatherLite:findExistingLocalNode(type, mapID, posX, posY, nodeID);

    if not node then
        return
    end

    node.date = date('*t')

    if count == 0 then
        GatherLite:debug(_GatherLite.DEBUG_NODE, "does not contain any items... skipping");
        return
    end

    for i = 1, count do
        local lIcon, lName, lQuantity, currencyID, lQuality, locked, isQuestItem = GetLootSlotInfo(i)
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

    node.coins = (node.coins or 0) + coin;
    node.loot = node.loot or {}

    for k, item in pairs(loot) do
        local exists = GatherLite:findLoot(node.loot, item.name);
        if not exists then
            table.insert(node.loot, {
                name = item.name,
                count = item.count,
                link = item.link
            })
        else
            if node.loot[exists].count == nil then
                node.loot[exists].count = 0;
            end

            if item.count == nil then
                item.count = 0;
            end

            node.loot[exists].count = node.loot[exists].count + item.count;
        end
    end

    local oldNode = GatherLite:FindExistingNode(type, mapID, posX, posY, nodeID);
    if oldNode then
        oldNode.loot = node.loot;
        oldNode.coins = node.coins;
        oldNode.date = node.date;
    end
    GatherLite:debug(_GatherLite.DEBUG_NODE, "Node loot updated")
end

function GatherLite:EventHandler(event, ...)

    if event == "PLAYER_LOGIN" then
        --GatherLite:ResetMinimap()

        GatherLite:SendVersionCheck()
        GatherLite:Load();
        GatherLite:ShowReleaseThanks();

    elseif event == "LOOT_OPENED" then
        if (tracker.spellID and tracker.ended and GetTime() - tracker.ended < 1) then
            if not IsInInstance() then
                GatherLite:UpdateNode(tracker.spellType, tracker.nodeID, tracker.mapID, tracker.x, tracker.y)
            end
        end
        resetTracker()
    elseif (event == "UNIT_SPELLCAST_SENT") or (event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED") then
        local unit = ...
        if API.IsSecret(unit) or unit ~= "player" then
            return
        end

        if event == "UNIT_SPELLCAST_SENT" then
            resetTracker()
            local _, target, castGUID, spell = ...
            if API.IsSecret(target) or API.IsSecret(castGUID) or API.IsSecret(spell) then
                return
            end
            local spellType = GatherLite:findSpellType(spell)
            if not target or not castGUID or not spellType then
                return
            end
            local nodeID = GatherLite:findNodeType(target)
            if nodeID and not IsInInstance() then
                local x, y, mapID = HBD:GetPlayerZonePosition()
                if not x or not y or not mapID then
                    return
                end
                tracker.nodeID = nodeID
                tracker.target = target
                tracker.spellID = spell
                tracker.spellType = spellType
                tracker.castGUID = castGUID
                tracker.x, tracker.y, tracker.mapID = x, y, mapID
            end
        else
            -- SENT has four arguments; completion/failure has the spell in
            -- argument three. Other units and unrelated casts must not finish
            -- or clear a gathering operation.
            local _, castGUID, spell = ...
            if API.IsSecret(castGUID) or API.IsSecret(spell) then
                resetTracker()
                return
            end
            if not tracker.castGUID or castGUID ~= tracker.castGUID or spell ~= tracker.spellID then
                return
            end
            if event == "UNIT_SPELLCAST_SUCCEEDED" then
                tracker.ended = GetTime()
                GatherLite:RegisterNode(tracker.spellType, tracker.nodeID, tracker.mapID, tracker.x, tracker.y)
            else
                resetTracker()
            end
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

function GatherLite:GetCloseNodes(type, x, y, mapID)

    local nodes = {}
    local frames = GFrame.usedFrames;

    for index, frame in pairs(frames) do
        if frame.type == type and (not mapID or frame.node.mapID == mapID)
            and GatherLite:IsNodeInRange(x, y, frame.node.posX, frame.node.posY) then
            table.insert(nodes, frame.node);
        end
    end

    return nodes;
end

local function addTooltipHistory(tooltipType, nodes, grouped)
    local lootEnabled = GatherLite.db.char[tooltipType].loot
    local loot, seen, lastVisit = {}, {}, nil
    for _, node in ipairs(nodes) do
        local saved = GatherLite:FindExistingNode(node.type, node.mapID, node.posX, node.posY, node.object)
        if saved and not seen[saved] then
            seen[saved] = true
            if saved.date then
                local visited = time(saved.date)
                if not lastVisit or visited > lastVisit then lastVisit = visited end
            end
            if lootEnabled then
                for _, item in ipairs(saved.loot or {}) do
                    if item.link then
                        loot[item.link] = (loot[item.link] or 0) + math.max(item.count or 0, 0)
                    end
                end
            end
        end
    end
    local links = {}
    for link in pairs(loot) do links[#links + 1] = link end
    table.sort(links)
    local indent = grouped and "    " or ""
    for _, link in ipairs(links) do
        local count = loot[link]
        GameTooltip:AddDoubleLine(indent .. link, count > 0 and ("x" .. count) or "",
            1, 1, 1, 0.75, 0.75, 0.75)
    end
    if lastVisit then
        GameTooltip:AddDoubleLine(indent .. GatherLite:translate("tooltip.last_visit"), date(nil, lastVisit),
            0.6, 0.6, 0.6, 0.75, 0.75, 0.75)
    end
end

function GatherLite:NodeTooltip(tooltipType, node)
    local object = GatherLite:GetNodeObject(node.object)
    if not object then return end
    GameTooltip:AddLine("|T" .. object.icon .. ":16:16|t " .. GatherLite:translate("node." .. object.name), 1, 0.82, 0)
    if node.type and node.type ~= "containers" then
        local label = node.type == "fishing" and "fish" or node.type
        GameTooltip:AddLine(GatherLite:translate(label), 0.6, 0.6, 0.6)
    end
    addTooltipHistory(tooltipType, { node }, false)
end

function GatherLite:showTooltip(frame)
    local nearby = GatherLite:GetCloseNodes(frame.type, frame.node.posX, frame.node.posY, frame.node.mapID)
    local groups, byObject, seen, total = {}, {}, {}, 0
    local function addNode(node)
        if seen[node] then return end
        seen[node] = true
        local object = GatherLite:GetNodeObject(node.object)
        if not object then return end
        local id = object.id[1] -- Catalog aliases share one display row.
        local group = byObject[id]
        if not group then
            group = { object = object, name = GatherLite:translate("node." .. object.name), nodes = {} }
            byObject[id] = group
            groups[#groups + 1] = group
        end
        group.nodes[#group.nodes + 1] = node
        total = total + 1
    end
    addNode(frame.node)
    local hovered = groups[1]
    for _, node in ipairs(nearby) do addNode(node) end
    table.sort(groups, function(a, b)
        if a == b then return false end
        if a == hovered then return true end
        if b == hovered then return false end
        if a.name == b.name then return a.object.id[1] < b.object.id[1] end
        return a.name < b.name
    end)

    GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
    GameTooltip:ClearLines()
    if total <= 1 then
        GatherLite:NodeTooltip(frame.type, frame.node)
    else
        GameTooltip:AddLine(GatherLite:translate("tooltip.nearby_nodes", total), 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        for _, group in ipairs(groups) do
            GameTooltip:AddDoubleLine("|T" .. group.object.icon .. ":16:16|t " .. group.name,
                "×" .. #group.nodes, 1, 1, 1, 0.75, 0.75, 0.75)
            addTooltipHistory(frame.type, group.nodes, true)
        end
    end
    GameTooltip:Show()
end

function GatherLite:hideTooltip()
    GameTooltip:Hide();
end

function GatherLite:GetNodeObject(nodeID)

    for i, node in pairs(_GatherLite.nodeDB) do
        if type(node.id) == "table" then
            for k2 = 1, #node.id do
                local id = node.id[k2];
                if id == nodeID then
                    return node
                end
            end
        end
    end

    --for k = 1, #_GatherLite.nodeDB do
    --    local node = _GatherLite.nodeDB[k];
    --
    --end
end

local function ensureMapTracking(target)
    local char = GatherLite.db and GatherLite.db.char
    if not char then
        return nil
    end

    char[target] = char[target] or {}
    char[target].tracking = char[target].tracking or {}

    for _, nodeType in ipairs({ "mining", "herbalism", "containers", "fishing" }) do
        if char[target].tracking[nodeType] == nil then
            if char.tracking and char.tracking[nodeType] ~= nil then
                char[target].tracking[nodeType] = char.tracking[nodeType]
            else
                char[target].tracking[nodeType] = true
            end
        end
    end

    return char[target].tracking
end

function GatherLite:GetNodeTracking(target, nodeType)
    local tracking = ensureMapTracking(target)
    if not tracking then
        return true
    end
    return tracking[nodeType] ~= false
end

function GatherLite:SetNodeTracking(target, nodeType, value)
    local tracking = ensureMapTracking(target)
    if tracking then
        tracking[nodeType] = value and true or false
        GatherLite:Trigger("settings:update")
        LibStub("AceConfigRegistry-3.0"):NotifyChange("GatherLite")
    end
end

function GatherLite:OpenTrackingMenu(owner, target)
    return MenuUtil.CreateContextMenu(owner, function(_, root)
        root:CreateTitle(_GatherLite.name)
        local function isSelected(nodeType)
            return GatherLite:GetNodeTracking(target, nodeType)
        end
        local function toggle(nodeType)
            GatherLite:SetNodeTracking(target, nodeType, not isSelected(nodeType))
        end
        root:CreateCheckbox(GatherLite:translate("mining"), isSelected, toggle, "mining")
        root:CreateCheckbox(GatherLite:translate("herbalism"), isSelected, toggle, "herbalism")
        root:CreateCheckbox(GatherLite:translate("containers"), isSelected, toggle, "containers")
        root:CreateCheckbox(GatherLite:translate("fish"), isSelected, toggle, "fishing")
    end)
end

function GatherLite:IsIgnored(objectID)
    return GatherLite.db.char.ignore[objectID] or false
end

function GatherLite:SetIgnored(object, value)
    for i, id in pairs(object.id) do
        GatherLite.db.char.ignore[id] = value
    end
end

function GatherLite:forEach(table, cb)
    if not table then
        return
    end

    for key in pairs(table) do
        cb(table[key]);
    end
end

local function loadDatabase(type)
    GatherLite:InvalidateNodeCache(type)

    GatherLite:forEach(GatherLite.db.global.nodes[type], function(node)
        indexNode(_GatherLite.savedNodeIndex[type], node)

        local existingNode = GatherLite:findExistingLocalNode(type, node.mapID, node.posX, node.posY, node.object);

        if existingNode then
            existingNode.loot = node.loot;
            existingNode.coins = node.coins;
            existingNode.lastvisit = node.lastvisit;
        else
            local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.posX, node.posY, node.mapID);
            node.predefined = false;
            node.loaded = false;
            node.worldX = x
            node.worldY = y
            node.instance = instance;
            table.insert(_GatherLite.nodes[type], node)
            indexNode(_GatherLite.nodeIndex[type], node)
        end

    end);
end

local isLoaded = false;

function GatherLite:IsLoaded()
    return isLoaded;
end

local function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function GatherLite:GetNodes()
    local nodes = {};

    nodes = TableConcat(nodes, _GatherLite.nodes["mining"])
    nodes = TableConcat(nodes, _GatherLite.nodes["herbalism"])

    return nodes
end

function GatherLite:LoadTable(type, source)
    local list = _GatherLite.nodes[type]
    local index = _GatherLite.nodeIndex[type]
    for i = 1, #source do
        local node = source[i]
        list[#list + 1] = node
        indexNode(index, node)
    end
    GatherLite:InvalidateNodeCache(type)
end

function GatherLite:Load()
    -- Index personal history first so predefined loading can skip saved pins
    -- using spatial buckets instead of scanning all saved nodes per point.
    loadDatabase("mining");
    loadDatabase("herbalism");
    loadDatabase("containers");
    loadDatabase("fishing");

    for i, module in pairs(GatherLite.modules) do
        module.setup();
    end

    for i, plugin in pairs(GatherLite.plugins) do
        plugin.setup();
    end

    isLoaded = true;

end

function GatherLite:SendVersionCheck()
    if IsInGuild() then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "GUILD")
    end

    local inInstance, instanceType = IsInInstance()

    if instanceType == "pvp" then
        GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "BATTLEGROUND")
    else
        if IsInRaid() then
            GatherLite:SendCommMessage(_GatherLite.name .. "Ver", GatherLite:Serialize(_GatherLite.version), "RAID")
        elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
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

    GatherLite:debug(_GatherLite.DEBUG_P2P, "Version check from", channel, sender, message)

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
    return API.GetProfessionLevel(name)
end

function GatherLite:MapLocalize(map)
    return HBD:GetLocalizedMap(map)
end

function GatherLite:Filter(t, filterIter)
    local out = {}

    for k, v in pairs(t) do
        if filterIter(v, k, t) then
            out[k] = v;
        end
    end

    return out
end
