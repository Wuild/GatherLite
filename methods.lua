local name, GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");

GatherLite.WorldMapOpen = false;

-- print message
GatherLite.print = function(...)
    print("|cffF0E68C[" .. GatherLite.name .. "]|cffFFFFFF:", ...)
end

-- print debug message
GatherLite.debug = function(...)
    if (GatherLiteConfigCharacter.debugging) then
        print("|cff008080[" .. GatherLite.name .. " - Debugging]|cffFFFFFF:", ...)
    end
end

-- count table rows
GatherLite.tablelength = function(T)
    local count = 0
    if T then
        for _ in pairs(T) do count = count + 1 end
    end
    return count
end

-- copy table into another table
GatherLite.CopyDefaults = function(src, dst)
    if type(src) ~= "table" then return {} end
    if type(dst) ~= "table" then dst = {} end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = GatherLite.CopyDefaults(v, dst[k])
        elseif type(v) ~= type(dst[k]) then
            dst[k] = v
        end
    end
    return dst
end

-- get translation string
GatherLite.locale = function(id)
    return id;
end

-- find spell type
GatherLite.findSpellType = function(spell)
    local spellInfo = GetSpellInfo(spell);

    -- see if spell is in our list
    for k, s in pairs(GatherLite.spellIDs) do
        if k == spellInfo then
            return s;
        end
    end;

    -- spell was not found
    return nil;
end

-- find spell
GatherLite.findSpell = function(spellID)
    -- check if spell is a mining spell
    for k, s in pairs(GatherLite.spellIDs["mining"]) do
        if s == spellID then
            return "mining", s;
        end
    end;

    -- check if spell is a herbalism spell
    for k, s in pairs(GatherLite.spellIDs["herbalism"]) do
        if s == spellID then
            return "herbalism", s;
        end
    end;

    -- spell type was not found
    return nil, nil;
end

GatherLite.checkMinimapNodes = function()
    local x, y, instance = HBD:GetPlayerWorldPosition();
    for k, node in ipairs(GatherLite.nodes.minimap) do
        local x2, y2 = HBD:GetWorldCoordinatesFromZone(node.x, node.y, node.mapID);
        local distance = HBD:GetWorldDistance(instance, x, y, x2, y2);
        if (distance) then
            if distance < 70 then
                node.frame:SetAlpha(0);
            else
                node.frame:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
            end;
        end
    end
end

GatherLite.IsNodeInRange = function(myPosX, myPosY, nodePosX, nodePosY, spellType)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    if spellType == "fish" then
        return distance < GatherLite.gatherSpellRanges.fish
    else
        return distance < GatherLite.gatherSpellRanges.default
    end;
end

GatherLite.findExistingNode = function(spellType, x, y)
    if GatherLiteGlobalSettings.database == nil then
        GatherLiteGlobalSettings.database = {};
    end

    if GatherLiteGlobalSettings.database[spellType] == nil then
        GatherLiteGlobalSettings.database[spellType] = {};
    end

    if GatherLiteGlobalSettings.database ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.database[spellType]) do
            if GatherLite.IsNodeInRange(x, y, node.position.x, node.position.y, spellType) then
                GatherLite.debug("Found node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
                return node;
            end
        end
    end

    return nil;
end

-- found ore, herb or fish
GatherLite.foundNode = function()
    local x, y, mapID = HBD:GetPlayerZonePosition();

    local loot = {};

    local coin;
    local count = GetNumLootItems()
    for i = 1, count do
        local lIcon, lName, lQuantity, lQuality, locked, isQuestItem = GetLootSlotInfo(i)
        local slotType = GetLootSlotType(i)
        local lLink = GetLootSlotLink(i)
        if not isQuestItem then
            if (not lLink and slotType == LOOT_SLOT_MONEY) then
                local i, j, val
                i, j, val = string.find(lName, COPPER_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then coin = coin + val end
                i, j, val = string.find(lName, SILVER_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then coin = coin + (val * 100) end
                i, j, val = string.find(lName, GOLD_AMOUNT:gsub("%%d", "(%%d+)", 1))
                if (i) then coin = coin + (val * 10000) end
                if (coin == 0) then
                    loot[lLink] = { name = lName, count = tonumber(lQuantity) }
                end
            else
                loot[lLink] = { name = lName, count = tonumber(lQuantity) }
            end
        end
    end

    -- dont do anything if loot table length is 0
    if GatherLite.tablelength(loot) == 0 then
        return;
    end;

    local node = GatherLite.findExistingNode(GatherLite.tracker.spellType, x, y);
    if not node then
        local icon, target;
        -- found treasure or node
        if GatherLite.tracker.spellType == "treasure" then
            local lIcon, lName, lQuantity, lQuality, currencyID, locked, isQuestItem = GetLootSlotInfo(1)
            if not isQuestItem then
                target = GatherLite.tracker.target
                icon = 132594
            else
                GatherLite.debug("Treasure is quest item, do not add to database");
            end
        else
            local primary = GetLootSlotLink(1)
            if (primary) then
                primary = primary:match("item:(%d+)")
                if (primary) then
                    if GatherLite.tracker.spellType == "fish" then
                        target = "Fishing spot"
                        icon = GetItemIcon(6303)
                    else
                        target = GatherLite.tracker.target;
                        icon = GetItemIcon(primary);
                    end
                elseif not primary and GatherLite.tracker.spellType == "artifacts" then
                    target = GatherLite.tracker.target;
                    icon = GetItemIcon(1195)
                end;
            end
        end

        -- do nothing if matching failed
        if not target and not icon then
            return
        end

        GatherLite.insertDatabaseNode(x, y, mapID, GatherLite.tracker.spellID, GatherLite.tracker.spellType, target, icon, loot)
    else
        GatherLite.updateDatabaseNode(node, loot)
    end
end

-- create new node / update node nearby
GatherLite.insertDatabaseNode = function(x, y, mapID, spellID, spellType, target, icon, loot)

    if GatherLiteGlobalSettings.database == nil then
        GatherLiteGlobalSettings.database = {};
    end

    if GatherLiteGlobalSettings.database[spellType] == nil then
        GatherLiteGlobalSettings.database[spellType] = {};
    end

    -- node data
    local node = {
        GUID = UnitGUID('player'),
        type = spellType,
        spellID = spellID,
        target = string.lower(target),
        name = target,
        icon = icon,
        loot = {},
        position = {
            mapID = mapID,
            x = x,
            y = y
        },
        date = date('*t'),
    };

    for k, item in pairs(loot) do
        if node.loot[k] then
            node.loot[k].count = item.count;
        else
            node.loot[k] = item;
        end;
    end

    table.insert(GatherLiteGlobalSettings.database[spellType], node);
    GatherLite.needMapUpdate = true;
    GatherLite.debug("Adding node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");

    local dataString = tostring('newdata' .. ':' .. UnitGUID('player') .. ":" .. node.type .. ":" .. node.spellID .. ":" .. node.target .. ":" .. node.target .. ":" .. node.icon .. ":" .. node.position.mapID .. ":" .. node.position.x .. ":" .. node.position.y)

    if IsInGuild() and GatherLiteConfigCharacter.shareGuild then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'GUILD')
        GatherLite.debug("sharing node with guild");
    end

    if IsInGroup() and GatherLiteConfigCharacter.shareParty then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'PARTY')
        GatherLite.debug("sharing node with party");
    end

end

GatherLite.updateDatabaseNode = function(node, loot)
    node.date = date('*t');
    if node.loot == nil then
        node.loot = {};
    end

    for k, item in pairs(loot) do
        if node.loot[k] then
            node.loot[k].count = node.loot[k].count + item.count;
        else
            node.loot[k] = item;
        end;
    end
    GatherLite.needMapUpdate = true;

    local dataString = tostring('newdata' .. ':' .. UnitGUID('player') .. ":" .. node.type .. ":" .. node.spellID .. ":" .. node.target .. ":" .. node.target .. ":" .. node.icon .. ":" .. node.position.mapID .. ":" .. node.position.x .. ":" .. node.position.y)

    if IsInGuild() and GatherLiteConfigCharacter.shareGuild then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'GUILD')
        GatherLite.debug("sharing node with guild");
    end

    if IsInGroup() and GatherLiteConfigCharacter.shareParty then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'PARTY')
        GatherLite.debug("sharing node with party");
    end
end

GatherLite.drawWorldmap = function()
    GatherLite.nodes.worldmap = {};
    GatherLite.removeWorldmapNodes();

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnWorldMap then
        return
    end

    GatherLite.debug("drawing world map nodes");

    if GatherLiteConfigCharacter.mining then
        if GatherLiteGlobalSettings.database["mining"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["mining"]) do
                GatherLite.createWorldmapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.herbalism then
        if GatherLiteGlobalSettings.database["herbalism"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["herbalism"]) do
                GatherLite.createWorldmapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.treasure then
        if GatherLiteGlobalSettings.database["treasure"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["treasure"]) do
                GatherLite.createWorldmapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.artifacts then
        if GatherLiteGlobalSettings.database["artifacts"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["artifacts"]) do
                GatherLite.createWorldmapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.fish then
        if GatherLiteGlobalSettings.database["fish"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["fish"]) do
                GatherLite.createWorldmapNode(node, k);
            end
        end
    end
end

GatherLite.drawMinimap = function()
    GatherLite.nodes.minimap = {};
    Pins:RemoveAllMinimapIcons("GathererClassic.Worldmap");

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnMinimap then
        return
    end

    GatherLite.debug("Updating mini map nodes");

    if GatherLiteConfigCharacter.mining then
        if GatherLiteGlobalSettings.database["mining"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["mining"]) do
                GatherLite.createMinimapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.herbalism then
        if GatherLiteGlobalSettings.database["herbalism"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["herbalism"]) do
                GatherLite.createMinimapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.treasure then
        if GatherLiteGlobalSettings.database["treasure"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["treasure"]) do
                GatherLite.createMinimapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.artifacts then
        if GatherLiteGlobalSettings.database["artifacts"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["artifacts"]) do
                GatherLite.createMinimapNode(node, k);
            end
        end
    end

    if GatherLiteConfigCharacter.fish then
        if GatherLiteGlobalSettings.database["fish"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["fish"]) do
                GatherLite.createMinimapNode(node, k);
            end
        end
    end
end

function leadingZeros(value)
    value = tonumber(value);
    if (value < 10) then
        return "0" .. value;
    end;
    return value;
end

GatherLite.createNodeTooltip = function(f, node)
    GetPlayerInfoByGUID(node.GUID)
    f:SetScript('OnEnter', function()
        if (f:GetAlpha() == 0) then
            return
        end

        local locClass, engClass, locRace, engRace, gender, name = GetPlayerInfoByGUID(node.GUID);
        local classColor = GatherLite.classColours[engClass];
        local addLoot = false;

        if node.loot and GatherLiteConfigCharacter.minimapLoot then
            addLoot = true;
        end

        f:SetAlpha(1);
        GatherLite.tooltip:ClearLines();

        GatherLite.tooltip:SetOwner(f, "ANCHOR_CURSOR");

        GatherLite.tooltip:SetText(node.name);
        GatherLite.tooltip:AddDoubleLine("Last visit:", "|cffffffff" .. leadingZeros(node.date.day) .. '/' .. leadingZeros(node.date.month) .. '/' .. leadingZeros(node.date.year) .. " - " .. leadingZeros(node.date.hour) .. ':' .. leadingZeros(node.date.min) .. ':' .. leadingZeros(node.date.sec) .. "|r");

        if addLoot then
            for k, item in pairs(node.loot) do
                GatherLite.tooltip:AddDoubleLine(k, "x" .. item.count);
            end
        end

        GatherLite.tooltip:AddDoubleLine("Found by:", classColor.fs .. name);

        GatherLite.tooltip:Show();
        GatherLite.showingTooltip = true;
    end)

    f:SetScript('OnLeave', function()
        if minimap then
            f:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
        else
            f:SetAlpha(GatherLiteConfigCharacter.worldmapOpacity);
        end;
        GatherLite.tooltip:Hide()
    end)

    return f;
end

GatherLite.createWorldmapNode = function(node, ik)
    local f
    if (GatherLite.frames[node.type .. "worldmap" .. ik] == nil) then
        GatherLite.frames[node.type .. "worldmap" .. ik] = CreateFrame('Button', name, WorldMapFrame.ScrollContainer.Child)
    end
    f = GatherLite.frames[node.type .. "worldmap" .. ik];
    f:SetSize(GatherLiteConfigCharacter.worldmapIconSize, GatherLiteConfigCharacter.worldmapIconSize)
    f:SetFrameLevel(1)
    f:SetFrameStrata("HIGH")
    f:EnableKeyboard(true)
    f:SetPropagateKeyboardInput(true)
    f:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");
    f:SetAlpha(GatherLiteConfigCharacter.worldmapOpacity);
    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(node.icon)
    GatherLite.createNodeTooltip(f, node);

    local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    Pins:AddWorldMapIconWorld("GathererClassic.Worldmap", f, instanceID, x, y);
    table.insert(GatherLite.nodes.worldmap, { frame = f, mapID = node.position.mapID, x = node.position.x, y = node.position.y })
end

GatherLite.createMinimapNode = function(node, ik)
    local f;
    if (GatherLite.frames[node.type .. "minimap" .. ik] == nil) then
        GatherLite.frames[node.type .. "minimap" .. ik] = CreateFrame('Button', "GatherLite.Minimap." .. ik, Minimap)
    end
    f = GatherLite.frames[node.type .. "minimap" .. ik];

    f:SetSize(GatherLiteConfigCharacter.minimapIconSize, GatherLiteConfigCharacter.minimapIconSize)
    f:SetFrameLevel(1)
    f:SetFrameStrata("HIGH")
    f:EnableKeyboard(true)
    f:SetPropagateKeyboardInput(true)
    f:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");
    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(node.icon)
    f:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
    GatherLite.createNodeTooltip(f, node);

    local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    Pins:AddMinimapIconWorld("GathererClassic.Worldmap", f, instanceID, x, y, GatherLiteConfigCharacter.minimapEdge);
    table.insert(GatherLite.nodes.minimap, { frame = f, mapID = node.position.mapID, x = node.position.x, y = node.position.y });
end

GatherLite.checkNodePositions = function()
    local x, y, instance = HBD:GetPlayerWorldPosition();
    for k, node in ipairs(GatherLite.nodes.minimap) do
        local x2, y2 = HBD:GetWorldCoordinatesFromZone(node.x, node.y, node.mapID);
        local distance = HBD:GetWorldDistance(instance, x, y, x2, y2);
        if (distance) then
            if distance < 70 then
                node.frame:SetAlpha(0);
            else
                node.frame:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
            end;
        end
    end
end

GatherLite.removeWorldmapNodes = function()
    Pins:RemoveAllWorldMapIcons("GathererClassic.Worldmap");
end

GatherLite.ParseSentData = function(msg, sender)
    if not GatherLiteConfigCharacter.shareGuild and not GatherLiteConfigCharacter.sharePart then
        return;
    end

    local data = {}
    local l = 0;
    for i, d in string.gmatch(msg, '[^:]+') do
        data[l] = i
        l = l + 1
    end

    local newNode;
    local NodeUpdated = false;
    local spellType = data[2];

    if GatherLiteGlobalSettings.database ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.database[spellType]) do
            if GatherLite.IsNodeInRange(data[8], data[9], node.position.x, node.position.y) then
                NodeUpdated = true;
            end
        end
    end

    if not GatherLite.findExistingNode(spellType, data[8], data[9]) then
        local node = {
            GUID = data[1],
            type = data[2],
            spellID = tonumber(data[3]),
            target = data[4],
            name = data[5],
            icon = data[6],
            loot = {},
            position = {
                mapID = tonumber(data[7]),
                x = tonumber(data[8]),
                y = tonumber(data[9])
            },
            date = date('*t'),
        };

        table.insert(GatherLiteGlobalSettings.database[spellType], node);
        GatherLite.needMapUpdate = true;
        GatherLite.debug("received p2p node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
    end
end
