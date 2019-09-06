local name, _GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GatherLite", true)

function GatherLite:translate(key, ...)
    local arg = { ... };
    for i, v in ipairs(arg) do
        arg[i] = tostring(v);
    end
    return string.format(L[key], unpack(arg))
end

-- print message
function GatherLite:print(...)
    print("|cffF0E68C[" .. _GatherLite.name .. "]|cffFFFFFF:", ...)
end

-- print debug message
function GatherLite:debug(...)
    if (GatherLiteConfigCharacter.debugging2) then
        print("|cff008080[" .. _GatherLite.name .. " - Debugging]|cffFFFFFF:", ...)
    end
end

-- count table rows
function GatherLite:tablelength(T)
    local count = 0
    if T then
        for _ in pairs(T) do
            count = count + 1
        end
    end
    return count
end

-- Make string colorized
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
    end

    return c .. str .. "|r"
end

-- copy table into another table
function GatherLite:CopyDefaults(src, dst)
    if type(src) ~= "table" then
        return {}
    end
    if type(dst) ~= "table" then
        dst = {}
    end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = GatherLite:CopyDefaults(v, dst[k])
        elseif type(v) ~= type(dst[k]) then
            dst[k] = v
        end
    end
    return dst
end

-- get translation string
function GatherLite:locale(id)
    return id;
end

--
function GatherLite:GatherSlash(input)
    input = string.trim(input, " ");
    if input == "" or not input then
        GatherLite:ShowSettings();
        return ;
    end

    if input == "debugging" then
        if GatherLiteConfigCharacter.debugging2 then
            GatherLiteConfigCharacter.debugging2 = false;
            GatherLite:print("debugging", GatherLite:Colorize("disabled", "red"));
        else
            GatherLiteConfigCharacter.debugging2 = true;
            GatherLite:print("debugging", GatherLite:Colorize("enabled", "green"));
        end
    end

end

-- find spell type
function GatherLite:findSpellType(spell)
    local spellInfo = GetSpellInfo(spell);

    -- see if spell is in our list
    for k, s in pairs(_GatherLite.spellIDs) do
        if k == spellInfo then
            return s;
        end
    end ;

    -- spell was not found
    return nil;
end

-- find spell
function GatherLite:findSpell(spellID)
    -- check if spell is a mining spell
    for k, s in pairs(_GatherLite.spellIDs["mining"]) do
        if s == spellID then
            return "mining", s;
        end
    end ;

    -- check if spell is a herbalism spell
    for k, s in pairs(_GatherLite.spellIDs["herbalism"]) do
        if s == spellID then
            return "herbalism", s;
        end
    end ;

    -- spell type was not found
    return nil, nil;
end

-- check distance between player and node
function GatherLite:IsNodeInRange(myPosX, myPosY, nodePosX, nodePosY, spellType)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    if spellType == "fish" then
        return distance < _GatherLite.gatherSpellRanges.fish
    else
        return distance < _GatherLite.gatherSpellRanges.default
    end ;
end

-- find existing node nearby
function GatherLite:findExistingNode(spellType, x, y)
    if GatherLiteGlobalSettings.database == nil then
        GatherLiteGlobalSettings.database = {};
    end

    if GatherLiteGlobalSettings.database[spellType] == nil then
        GatherLiteGlobalSettings.database[spellType] = {};
    end

    if GatherLiteGlobalSettings.database ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.database[spellType]) do
            if GatherLite:IsNodeInRange(x, y, node.position.x, node.position.y, spellType) then
                return node;
            end
        end
    end

    return nil;
end

-- found ore, herb or fish
function GatherLite:foundNode()
    if (IsInInstance()) then
        return
    end

    local x, y, mapID = HBD:GetPlayerZonePosition();

    local loot = {};

    local coin = 0;
    local count = GetNumLootItems()

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

    -- dont do anything if loot table length is 0
    if GatherLite:tablelength(loot) == 0 then
        return ;
    end ;

    local icon, target;
    local node = GatherLite:findExistingNode(_GatherLite.tracker.spellType, x, y);
    if not node then
        -- found treasure or node
        if _GatherLite.tracker.spellType == "treasure" then
            local lIcon, lName, lQuantity, lQuality, currencyID, locked, isQuestItem = GetLootSlotInfo(1)
            if not isQuestItem then
                target = _GatherLite.tracker.target
                icon = 132594
            else
                GatherLite:debug("Treasure is quest item, do not add to database");
                return
            end
        else
            local primary = GetLootSlotLink(1)
            if (primary) then
                primary = primary:match("item:(%d+)")
                if (primary) then
                    if _GatherLite.tracker.spellType == "fish" then
                        target = "Fishing spot"
                        icon = GetItemIcon(6303)
                    else
                        target = _GatherLite.tracker.target;
                        icon = GetItemIcon(primary);
                    end
                elseif not primary and _GatherLite.tracker.spellType == "artifacts" then
                    target = _GatherLite.tracker.target;
                    icon = GetItemIcon(1195)
                end ;
            end
        end

        -- do nothing if matching failed
        if not target and not icon then
            return
        end

        GatherLite:insertDatabaseNode(x, y, mapID, _GatherLite.tracker.spellID, _GatherLite.tracker.spellType, target, icon, loot, coin)
    else

        local primary = GetLootSlotLink(1)
        if (primary) then
            primary = primary:match("item:(%d+)")
            if (primary) then
                if _GatherLite.tracker.spellType == "fish" then
                    target = "Fishing spot"
                    icon = GetItemIcon(6303)
                else
                    target = _GatherLite.tracker.target;
                    icon = GetItemIcon(primary);
                end
            elseif not primary and _GatherLite.tracker.spellType == "artifacts" then
                target = _GatherLite.tracker.target;
                icon = GetItemIcon(1195)
            end
        end

        GatherLite:updateDatabaseNode(node, loot, coin, target, icon)
    end
end

-- create new node
function GatherLite:insertDatabaseNode(x, y, mapID, spellID, spellType, target, icon, loot, coin)

    if GatherLiteGlobalSettings.database == nil then
        GatherLiteGlobalSettings.database = {};
    end

    if GatherLiteGlobalSettings.database[spellType] == nil then
        GatherLiteGlobalSettings.database[spellType] = {};
    end

    local locClass, engClass, locRace, engRace, gender, pName = GetPlayerInfoByGUID(UnitGUID('player'));

    -- node data
    local node = {
        GUID = UnitGUID('player'),
        type = spellType,
        spellID = spellID,
        target = string.lower(target),
        name = target,
        icon = icon,
        shared = false,
        loot = {},
        coins = coin,
        position = {
            mapID = mapID,
            x = x,
            y = y
        },
        date = date('*t'),
        player = {
            name = pName,
            class = engClass,
            race = engRace,
            realm = GetRealmName()
        }
    };

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

    table.insert(GatherLiteGlobalSettings.database[spellType], node);

    GatherLite:debug("Adding node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
    GatherLite:createNode(node)

    if IsInGuild() and GatherLiteConfigCharacter.shareGuild then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "GUILD")
        GatherLite:debug("sharing node with guild");
    end

    if IsInGroup() and GatherLiteConfigCharacter.shareParty then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "PARTY")
        GatherLite:debug("sharing node with party");
    end
end

-- update existing node
function GatherLite:updateDatabaseNode(node, loot, coin, target, icon)
    node.date = date('*t');

    if target then
        node.name = target;
        node.target = string.lower(target);
    end

    if icon then
        node.icon = icon;
    end

    if node.loot == nil then
        node.loot = {};
    end

    if node.coins == nil then
        node.coins = 0;
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

    if IsInGuild() and GatherLiteConfigCharacter.shareGuild then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "GUILD")
        GatherLite:debug("sharing node with guild");
    end

    if IsInGroup() and GatherLiteConfigCharacter.shareParty then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "PARTY")
        GatherLite:debug("sharing node with party");
    end
end

-- draw world map nodes
function GatherLite:drawWorldmap()
    _GatherLite.nodes.worldmap = {};
    Pins:RemoveAllWorldMapIcons("GathererClassic");

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnWorldMap then
        return
    end

    GatherLite:debug("drawing world map nodes");

    for type in pairs(GatherLiteGlobalSettings.database) do
        if GatherLiteConfigCharacter[type] then
            for k, node in ipairs(GatherLiteGlobalSettings.database[type]) do
                GatherLite:createWorldmapNode(node, k);
            end
        end
    end
end

-- draw minimap nodes
function GatherLite:drawMinimap()
    _GatherLite.nodes.minimap = {};
    Pins:RemoveAllMinimapIcons("GathererClassic");

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnMinimap then
        return
    end

    GatherLite:debug("Updating mini map nodes");

    for type in pairs(GatherLiteGlobalSettings.database) do
        if GatherLiteConfigCharacter[type] then
            for k, node in ipairs(GatherLiteGlobalSettings.database[type]) do
                GatherLite:createMinimapNode(node, k);
            end
        end
    end
end

-- add leadingZeros to number
function GatherLite:leadingZeros(value)
    value = tonumber(value);
    if (value < 10) then
        return "0" .. value;
    end ;
    return value;
end

-- create tooltip for map node
function GatherLite:createNodeTooltip(f, node, opacity, lootTable)
    f:SetScript('OnEnter', function()

        _GatherLite.tooltip:ClearLines();
        _GatherLite.tooltip:SetOwner(f, "ANCHOR_CURSOR");
        _GatherLite.tooltip:SetText(node.name);
        _GatherLite.tooltip:AddDoubleLine(GatherLite:translate('tooltip.last_visit'), GatherLite:Colorize(GatherLite:leadingZeros(node.date.day) .. '/' .. GatherLite:leadingZeros(node.date.month) .. '/' .. GatherLite:leadingZeros(node.date.year) .. " - " .. GatherLite:leadingZeros(node.date.hour) .. ':' .. GatherLite:leadingZeros(node.date.min) .. ':' .. GatherLite:leadingZeros(node.date.sec), "white"));

        if node.loot and lootTable then
            for k, item in pairs(node.loot) do
                _GatherLite.tooltip:AddDoubleLine(item.link, "x" .. item.count);
            end
        end

        if not node.player then
            local locClass, engClass, locRace, engRace, gender, pName = GetPlayerInfoByGUID(node.GUID);
            node.player = {
                name = pName,
                class = engClass,
                race = engRace,
                realm = GetRealmName()
            }
        end

        if node.player.name and _GatherLite.classColours[node.player.class] then
            _GatherLite.tooltip:AddDoubleLine(GatherLite:translate('tooltip.found_by'), _GatherLite.classColours[node.player.class].fs .. node.player.name .. " - " .. node.player.realm);
        end
        _GatherLite.tooltip:Show();
        _GatherLite.showingTooltip = true;
    end)

    f:SetScript('OnLeave', function()
        _GatherLite.tooltip:Hide()
    end)
    return f;
end

function GatherLite:createFrame(name, parent, size)
    if (_GatherLite.frames[name] == nil) then
        _GatherLite.frames[name] = CreateFrame('Button', name, parent)

        _GatherLite.frames[name]:SetSize(size, size)
        _GatherLite.frames[name]:SetFrameStrata("HIGH")
        _GatherLite.frames[name]:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");
    end
    return _GatherLite.frames[name];
end

-- create world map node frame
function GatherLite:createWorldmapNode(node, ik)
    if not node.position.mapID and not node.position.x and not node.position.y then
        return
    end

    local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);

    if not instanceID and not x and not y then
        return
    end

    local f = GatherLite:createFrame(node.type .. "worldmap" .. ik, WorldMapFrame.ScrollContainer.Child, GatherLiteConfigCharacter.worldmapIconSize);
    f:SetAlpha(GatherLiteConfigCharacter.worldmapOpacity);
    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(node.icon)
    GatherLite:createNodeTooltip(f, node, GatherLiteConfigCharacter.worldmapOpacity, GatherLiteConfigCharacter.worldmapLoot);

    --local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    --Pins:AddWorldMapIconWorld("GathererClassic.Worldmap", f, instanceID, x, y);
    Pins:AddWorldMapIconWorld("GathererClassic", f, instanceID, x, y);
    table.insert(_GatherLite.nodes.worldmap, { frame = f, mapID = node.position.mapID, x = node.position.x, y = node.position.y })
end

-- create mini map node frame
function GatherLite:createMinimapNode(node, ik)
    if not node.position.mapID and not node.position.x and not node.position.y then
        return
    end

    local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);

    if not instanceID and not x and not y then
        return
    end

    local f = GatherLite:createFrame(node.type .. "minimap" .. ik, Minimap, GatherLiteConfigCharacter.minimapIconSize);
    f:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(node.icon)
    GatherLite:createNodeTooltip(f, node, GatherLiteConfigCharacter.minimapOpacity, GatherLiteConfigCharacter.minimapLoot);

    Pins:AddMinimapIconWorld("GathererClassic", f, instanceID, x, y, GatherLiteConfigCharacter.minimapEdge);
    table.insert(_GatherLite.nodes.minimap, { frame = f, mapID = node.position.mapID, x = node.position.x, y = node.position.y });
end

function GatherLite:createNode(node)
    if GatherLiteConfigCharacter.enabled and GatherLiteConfigCharacter.showOnMinimap then
        GatherLite:createMinimapNode(node, GatherLite:tablelength(GatherLiteGlobalSettings.database[node.type]));
    end
    if GatherLiteConfigCharacter.enabled and GatherLiteConfigCharacter.showOnWorldMap then
        GatherLite:createWorldmapNode(node, GatherLite:tablelength(GatherLiteGlobalSettings.database[node.type]));
    end
end

-- check if close to a node on the minimap
function GatherLite:checkNodePositions()
    local x, y, instance = HBD:GetPlayerWorldPosition();
    for k, node in ipairs(_GatherLite.nodes.minimap) do
        local x2, y2 = HBD:GetWorldCoordinatesFromZone(node.x, node.y, node.mapID);
        local distance = HBD:GetWorldDistance(instance, x, y, x2, y2);
        if (distance) then
            if distance < GatherLiteConfigCharacter.minimapHideDistance then
                node.frame:SetAlpha(0);
                node.frame:EnableMouse(false)
            else
                node.frame:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
                node.frame:EnableMouse(true)
            end
        end
    end
end

function GatherLite:p2pNode(event, msg, channel, sender)
    if (sender == UnitName("player")) then
        return
    end

    if channel == "GUILD" and not GatherLiteConfigCharacter.shareGuild then
        return
    end

    if channel == "PARTY" and not GatherLiteConfigCharacter.shareParty then
        return ;
    end

    local success, node = GatherLite:Deserialize(msg);
    if success then
        if not GatherLite:findExistingNode(node.type, node.position.x, node.position.y) then
            node.shared = true;
            node.loot = {};
            table.insert(GatherLiteGlobalSettings.database[node.type], node);
            GatherLite:createNode(node)
            GatherLite:debug("received p2p node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
        end
    end
end

function GatherLite:p2pSync(event, msg, channel, sender)
    if (sender == UnitName("player")) then
        return
    end

    if channel == "GUILD" and not GatherLiteConfigCharacter.shareGuild then
        return
    end

    if channel == "PARTY" and not GatherLiteConfigCharacter.shareParty then
        return ;
    end

    local success, data = GatherLite:Deserialize(msg);
    if success then
        for i2, node in ipairs(data) do
            if not GatherLite:findExistingNode(node.type, node.position.x, node.position.y) then
                node.shared = true;
                node.loot = {};
                table.insert(GatherLiteGlobalSettings.database[node.type], node);
                GatherLite:createNode(node)
                GatherLite:debug("received p2p node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
            end
        end
    end
end

function GatherLite:findLoot(list, name)
    for item, data in pairs(list) do
        if data.name == name then
            return item
        end
    end
end

-- sanitize node to new structure
function GatherLite:sanitizeNode(type, i)
    local node = GatherLiteGlobalSettings.database[type][i];
    
    if not node.position or not node.position.mapID or not node.position.x or not node.position.y then
        -- remove nodes wich has a faulty position data
        GatherLiteGlobalSettings.database[type][i] = nil;
        GatherLite:debug("removing unknown node")
    elseif GatherLite:tablelength(node.loot) == 0 and not node.shared then
        -- remove all nodes thats empty and hasnt been shared with the new p2p system
        -- They are probably old quest items being tracked.
        GatherLiteGlobalSettings.database[type][i] = nil;
        GatherLite:debug("removing empty node")
    else
        -- update node loot table to avoid duplicate items shown.
        local newLoot = {};
        for link, data in pairs(GatherLiteGlobalSettings.database[type][i].loot) do
            if not tonumber(link) then
                local exists = GatherLite:findLoot(newLoot, data.name);
                if not exists then
                    table.insert(newLoot, {
                        name = data.name,
                        count = data.count,
                        link = link
                    })
                else
                    newLoot[exists].count = newLoot[exists].count + data.count;
                end
            else
                table.insert(newLoot, data)
            end
        end
        GatherLiteGlobalSettings.database[type][i].loot = newLoot;
    end
end

-- sanitize database on load
function GatherLite:sanitizeDatabase()
    if not GatherLiteGlobalSettings.database then
        return
    end

    for type in pairs(GatherLiteGlobalSettings.database) do
        for i, node in ipairs(GatherLiteGlobalSettings.database[type]) do
            GatherLite:sanitizeNode(type, i)
        end
    end
end

function GatherLite:OnEnable()
    GatherLite:sanitizeDatabase();

    GatherLite:drawMinimap();
    GatherLite:drawWorldmap();
end