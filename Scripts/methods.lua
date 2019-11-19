local name, _GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherLite", true)
local Semver = LibStub("Semver");

--options interface
GatherLite.OptionsPanel = AceGUI:Create("Frame");
_G["GatherLiteOptionPanel"] = GatherLite.OptionsPanel.frame;
table.insert(UISpecialFrames, "GatherLiteOptionPanel");

GatherLite.NewVersionExists = false;

local qNumberOfFrames = 0;

GatherLite.frames = {}

GatherLite.totalNodes = 0;

GatherLite.synchronizing = false
GatherLite.syncedNodes = {
    guild = 0,
    party = 0
}

GatherLite.syncTimer = nil;

local function RefreshConfig()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("GatherLite")
end

function GatherLite:translate(key, ...)
    local arg = { ... };
    for i, v in ipairs(arg) do
        arg[i] = tostring(v);
    end
    return string.format(L[key], unpack(arg))
end

-- print message
function GatherLite:print(...)
    print(GatherLite:Colorize("<" .. _GatherLite.name .. ">", "yellow"), ...)
end

-- print debug message
function GatherLite:debug(...)
    if (GatherLite.db.char.debugging) then
        print(GatherLite:Colorize("<" .. _GatherLite.name .. " - Debugging>", "blue"), ...)
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
    elseif color == 'cyan' then
        c = "|cff00FFFF"
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

function GatherLite:ShowSettings()
    LibStub("AceConfigDialog-3.0"):Open("GatherLite", GatherLite.OptionsPanel)
end

-- slash commands
function GatherLite:GatherSlash(input)
    input = string.trim(input, " ");
    if input == "" or not input then
        GatherLite:ShowSettings();
        return ;
    end

    if input == "debugging" then
        if GatherLite.db.char.debugging then
            GGatherLite.db.char.debugging = false;
            GatherLite:print("debugging", GatherLite:Colorize("disabled", "red"));
        else
            GatherLite.db.char.debugging = true;
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
    for k, node in pairs(_GatherLite.nodes[spellType]) do
        if GatherLite:IsNodeInRange(x, y, node.position.x, node.position.y, spellType) then
            return node;
        end
    end
    return nil;
end

function GatherLite:findExistingNodeLocal(spellType, x, y)
    for k, node in pairs(GatherLite.db.global.nodes[spellType]) do
        if GatherLite:IsNodeInRange(x, y, node.position.x, node.position.y, spellType) then
            return node;
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
    local node = GatherLite:findExistingNodeLocal(_GatherLite.tracker.spellType, x, y);
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

    table.insert(GatherLite.db.global.nodes[spellType], node);
    table.insert(_GatherLite.nodes[spellType], node);

    GatherLite.totalNodes = GatherLite.totalNodes + 1;

    GatherLite:debug("Adding node at " .. "|cff32CD32" .. node.position.x .. " " .. node.position.y .. "|r");
    GatherLite:createNode(node)

    if IsInGuild() and GatherLite.db.char.p2p.guild then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "GUILD")
        GatherLite:debug("sharing node with guild");
    end

    if IsInGroup() and GatherLite.db.char.p2p.party then
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

    if IsInGuild() and GatherLite.db.char.p2p.guild then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "GUILD")
        GatherLite:debug("sharing node with guild");
    end

    if IsInGroup() and GatherLite.db.char.p2p.party then
        GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "PARTY")
        GatherLite:debug("sharing node with party");
    end
end

-- draw world map nodes
function GatherLite:drawWorldmap()
    GatherLite:debug("drawing world map nodes");

    for type in pairs(_GatherLite.nodes) do
        for k, node in pairs(_GatherLite.nodes[type]) do
            GatherLite:createWorldmapNode(node, k);
        end
    end

    for i, frame in ipairs(GatherLite.frames) do
        if frame.type == "worldmap" then
            frame:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
            frame:SetAlpha(GatherLite.db.char.worldmap.opacity)
        end
    end
end

-- draw minimap nodes
function GatherLite:drawMinimap()
    if not GatherLite.db.char.enabled or not GatherLite.db.char.minimap.enabled then
        return
    end

    GatherLite:debug("Updating mini map nodes");

    for type in pairs(_GatherLite.nodes) do
        for k, node in pairs(_GatherLite.nodes[type]) do
            GatherLite:createMinimapNode(node, k);
        end
    end

    for i, frame in ipairs(GatherLite.frames) do
        if frame.type == "minimap" then
            frame:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)
            frame:SetAlpha(GatherLite.db.char.minimap.opacity)
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
function GatherLite:createNodeTooltip(self)
    local node = self.node;
    _GatherLite.tooltip:ClearLines();
    _GatherLite.tooltip:SetOwner(self, "TOP");
    _GatherLite.tooltip:SetText(node.name);
    if node.date then
        _GatherLite.tooltip:AddDoubleLine(GatherLite:translate('tooltip.last_visit'), GatherLite:Colorize(GatherLite:leadingZeros(node.date.day) .. '/' .. GatherLite:leadingZeros(node.date.month) .. '/' .. GatherLite:leadingZeros(node.date.year) .. " - " .. GatherLite:leadingZeros(node.date.hour) .. ':' .. GatherLite:leadingZeros(node.date.min) .. ':' .. GatherLite:leadingZeros(node.date.sec), "white"));
    end
    local lootTable = false

    if self.type == "minimap" then
        lootTable = GatherLite.db.char.minimap.loot;
    elseif self.type == "worldmap" then
        lootTable = GatherLite.db.char.worldmap.loot;
    end

    if node.loot and lootTable then
        for k, item in pairs(node.loot) do
            if item.count > 0 then
                _GatherLite.tooltip:AddDoubleLine(item.link, "x" .. item.count);
            else
                _GatherLite.tooltip:AddDoubleLine(item.link, "");
            end
        end
    end

    if not node.player and node.GUID then
        local locClass, engClass, locRace, engRace, gender, pName = GetPlayerInfoByGUID(node.GUID);
        node.player = {
            name = pName,
            class = engClass,
            race = engRace,
            realm = GetRealmName()
        }
    end

    if node.coins and node.coins > 0 then
        SetTooltipMoney(_GatherLite.tooltip, node.coins)
    end
    if node.player and node.player.name and _GatherLite.classColours[node.player.class] then
        _GatherLite.tooltip:AddDoubleLine(GatherLite:translate('tooltip.found_by'), _GatherLite.classColours[node.player.class].fs .. node.player.name .. " - " .. node.player.realm);
    end

    _GatherLite.tooltip:Show();
    _GatherLite.showingTooltip = true;
end

function GatherLite:createFrame()
    qNumberOfFrames = qNumberOfFrames + 1
    local f = CreateFrame("Button", "GatherLite" .. qNumberOfFrames, nil)

    if MBB_Ignore then
        table.insert(MBB_Ignore, "GatherLite" .. qNumberOfFrames)
    end

    f:SetFrameStrata("TOOLTIP");
    f:SetWidth(16) -- Set these to whatever height/width is needed
    f:SetHeight(16) -- for your Texture

    f.node = {};
    f.type = nil;

    local t = f:CreateTexture(nil, "TOOLTIP")
    t:SetWidth(16)
    t:SetHeight(16)
    t:SetAllPoints(f)
    t:SetTexelSnappingBias(0)
    t:SetSnapToPixelGrid(false)
    f:SetScript("OnEnter", function(self)
        GatherLite:createNodeTooltip(self);
    end)
    f:SetScript("OnLeave", function()
        _GatherLite.tooltip:Hide()
    end)
    f.texture = t;

    function f:FakeHide()
        if not self.hidden then
            self.shouldBeShowing = self:IsShown();
            self._show = self.Show;
            self.Show = function()
                self.shouldBeShowing = true;
            end
            self:Hide();
            self._hide = self.Hide;
            self.Hide = function()
                self.shouldBeShowing = false;
            end
            self.hidden = true
        end
    end

    function f:FakeShow()
        if self.hidden then
            self.hidden = false
            self.Show = self._show;
            self.Hide = self._hide;
            self._show = nil
            self._hide = nil
            if self.shouldBeShowing then
                self:Show();
            end
        end
    end

    function f:Unload()
        self:SetScript("OnUpdate", nil)
        self:SetScript("OnShow", nil)
        self:SetScript("OnHide", nil)
        self.texture:SetVertexColor(1, 1, 1, 1)

        if self ~= nil and self.hidden and self._show ~= nil and self._hide ~= nil then
            self.hidden = false
            self.Show = self._show;
            self.Hide = self._hide;
            self._show = nil
            self._hide = nil
        end
        self.shouldBeShowing = nil
        self.node = {}
        self.type = nil
        Pins:RemoveMinimapIcon(GatherLite, self)
        Pins:RemoveWorldMapIcon(GatherLite, self)
        self:Hide()
    end

    f:Hide()
    table.insert(GatherLite.frames, f)
    return f;
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

    local f = GatherLite:createFrame();
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    f.texture:SetTexture(node.icon)
    f.node = node;
    f.type = "worldmap";

    --local x, y, instanceID = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    --Pins:AddWorldMapIconWorld("GathererClassic.Worldmap", f, instanceID, x, y);

    local flag

    if GatherLite.db.char.worldmap.continent then
        flag = HBD_PINS_WORLDMAP_SHOW_CONTINENT
    end

    if GatherLite.db.char.worldmap.neighbors then
        Pins:AddWorldMapIconWorld(GatherLite, f, instanceID, x, y, flag);
    else
        Pins:AddWorldMapIconMap(GatherLite, f, node.position.mapID, node.position.x, node.position.y, flag);
    end
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

    local f = GatherLite:createFrame();
    f:SetAlpha(GatherLite.db.char.minimap.opacity);
    f:SetSize(GatherLite.db.char.minimap.size, GatherLite.db.char.minimap.size)
    f.texture:SetTexture(node.icon)
    f.node = node;
    f.type = "minimap";

    if GatherLite.db.char.minimap.neighbors then
        Pins:AddMinimapIconWorld(GatherLite, f, instanceID, x, y, GatherLite.db.char.minimap.edge);
    else
        Pins:AddMinimapIconMap(GatherLite, f, node.position.mapID, node.position.x, node.position.y, true, GatherLite.db.char.minimap.edge)
    end
end

function GatherLite:createNode(node)
    GatherLite:createMinimapNode(node, GatherLite:tablelength(_GatherLite.nodes[node.type]));
    GatherLite:createWorldmapNode(node, GatherLite:tablelength(_GatherLite.nodes[node.type]));
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
                    end ;
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
                    end ;
                end
            })

            if not _GatherLite.isClassic then
                GatherLite:addContextItem({
                    text = GatherLite:translate('archaeology'),
                    icon = 134435,
                    checked = GatherLite.db.char.tracking.artifacts,
                    callback = function()
                        if GatherLite.db.char.tracking.artifacts then
                            GatherLite.db.char.tracking.artifacts = false;
                        else
                            GatherLite.db.char.tracking.artifacts = true;
                        end ;
                    end
                })
            end

            GatherLite:addContextItem({
                text = GatherLite:translate('fish'),
                icon = GetItemIcon(6303),
                checked = GatherLite.db.char.tracking.fish,
                callback = function()
                    if GatherLite.db.char.tracking.fish then
                        GatherLite.db.char.tracking.fish = false;
                    else
                        GatherLite.db.char.tracking.fish = true;
                    end ;
                end
            })

            GatherLite:addContextItem({
                text = GatherLite:translate('treasures'),
                icon = 132594,
                checked = GatherLite.db.char.tracking.treasure,
                callback = function()
                    if GatherLite.db.char.tracking.treasure then
                        GatherLite.db.char.tracking.treasure = false;
                    else
                        GatherLite.db.char.tracking.treasure = true;
                    end ;
                end
            })
        end
    end
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
end

function GatherLite:p2pNode(event, msg, channel, sender)
    if (sender == UnitName("player")) then
        return
    end

    if channel == "GUILD" and not GatherLite.db.char.p2p.guild then
        return
    end

    if channel == "PARTY" and not GatherLite.db.char.p2p.party then
        return ;
    end

    local success, node = GatherLite:Deserialize(msg);
    if success then
        if node.position and node.position.mapID and node.position.x and node.position.y then
            if not GatherLite:findExistingNodeLocal(node.type, node.position.x, node.position.y) then
                node.shared = true;
                node.coins = 0;
                local isQuest = false;
                if node.loot and GatherLite:tablelength(node.loot) > 0 then
                    for i, item in ipairs(node.loot) do
                        local name = select(1, GetItemInfo(node.target));
                        local type = select(6, GetItemInfo(node.target))
                        if type == "Quest" then
                            isQuest = true
                        end
                    end
                else
                    node.loot = {};
                end

                if not isQuest then
                    table.insert(GatherLite.db.global.nodes[node.type], node);
                    table.insert(_GatherLite.nodes[node.type], node);
                    GatherLite:createNode(node)
                    GatherLite:debug("received p2p " .. node.type .. " node from " .. sender);
                end
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

        table.insert(GatherLite.db.global.nodes[type], GatherLiteGlobalSettings.database[type][i]);
        GatherLiteGlobalSettings.database[type][i] = nil
    end
end

-- sanitize database on load
function GatherLite:sanitizeDatabase()

    if not GatherLiteGlobalSettings then
        return
    end

    if not GatherLiteGlobalSettings.database then
        return
    end

    for type in pairs(GatherLiteGlobalSettings.database) do
        for i, node in pairs(GatherLiteGlobalSettings.database[type]) do
            GatherLite:sanitizeNode(type, i)
        end
    end
end

function GatherLite:copy(obj, seen)
    if type(obj) ~= 'table' then
        return obj
    end
    if seen and seen[obj] then
        return seen[obj]
    end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do
        res[GatherLite:copy(k, s)] = GatherLite:copy(v, s)
    end
    return res
end

function GatherLite:p2pDatabase()
    GatherLite:CancelTimer(GatherLite.syncTimer)
    if IsInGuild() and GatherLite.db.char.p2p.guild and GatherLite.syncedNodes.guild == 0 and GatherLite:tablelength(GatherLite.db.global.nodes) > 0 then
        GatherLite:debug("Starting synchronization with guild")
        GatherLite.synchronizing = true;
        local totalNodes = GatherLite:copy(GatherLite.totalNodes);
        for i, data in pairs(GatherLite.db.global.nodes) do
            for i, node in pairs(data) do
                GatherLite:SendCommMessage(_GatherLite.name .. "Node", GatherLite:Serialize(node), "GUILD", nil, "BULK", function(args, bytes, totalBytes)
                    if bytes == totalBytes then
                        GatherLite.syncedNodes.guild = GatherLite.syncedNodes.guild + 1;
                        if GatherLite.syncedNodes.guild == totalNodes then
                            GatherLite.syncedNodes.guild = 0;
                            GatherLite.syncTimer = GatherLite:ScheduleTimer("p2pDatabase", 3600)
                            GatherLite.synchronizing = false;
                            GatherLite:debug("Guild synchronization complete")
                        end
                        RefreshConfig();
                    end
                end)
            end
        end
    end
end

function GatherLite:syncCheck()
    if GatherLite.synchronizing then
        GatherLite:debug("Synchronized", GatherLite.syncedNodes.guild .. "/" .. GatherLite.totalNodes)
    end
end

-- event handler
function GatherLite:EventHandler(event, ...)
    -- loot window opened
    if event == "LOOT_OPENED" then
        if (_GatherLite.tracker.spellID and _GatherLite.tracker.ended and GetTime() - _GatherLite.tracker.ended < 1) then
            GatherLite:debug("loot window opened")
            GatherLite:foundNode();
            _GatherLite.tracker.target = nil;
            _GatherLite.tracker.spellID = nil;
            _GatherLite.tracker.spellType = nil;
        elseif (_GatherLite.tracker.spellID and IsFishingLoot()) then
            GatherLite:debug("loot window opened")
            GatherLite:foundNode();
            _GatherLite.tracker.target = nil;
            _GatherLite.tracker.spellID = nil;
            _GatherLite.tracker.spellType = nil;
        end
    end

    -- spell has ended
    if (event == "UNIT_SPELLCAST_SENT") or (event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED") then
        local spell = select(4, ...)
        local target = select(2, ...)

        if (event == "UNIT_SPELLCAST_SENT") then
            local spellType = GatherLite:findSpellType(spell)
            if (spellType) then
                GatherLite:debug("Started " .. GetSpellInfo(spell), spell)
                _GatherLite.tracker.target = target
                _GatherLite.tracker.spellID = spell
                _GatherLite.tracker.spellType = spellType
            end ;
        elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
            _GatherLite.tracker.ended = GetTime()
        elseif ((event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED")) then
            -- Spell failed, cancel the tracking
            _GatherLite.tracker.target = nil
            _GatherLite.tracker.spellID = nil
            _GatherLite.tracker.spellType = nil
        end
    end
end

function GatherLite:UpdateNodes()

    if not GatherLite.db.char.enabled then
        for i, frame in ipairs(GatherLite.frames) do
            frame:FakeHide();
        end
        return
    end

    for i, frame in ipairs(GatherLite.frames) do
        if frame.type == "minimap" and GatherLite.db.char.minimap.enabled then
            local angle, distance = Pins:GetVectorToIcon(frame);
            if GatherLite.db.char.tracking[frame.node.type] and distance and distance < GatherLite.db.char.minimap.distance then
                frame:FakeHide();
            elseif GatherLite.db.char.tracking[frame.node.type] then
                frame:FakeShow();
            else
                frame:FakeHide();
            end
        elseif frame.type == "worldmap" and GatherLite.db.char.worldmap.enabled then
            if GatherLite.db.char.tracking[frame.node.type] then
                frame:FakeShow();
            else
                frame:FakeHide();
            end
        else
            frame:FakeHide();
        end
    end
end

function GatherLite:loadDatabase()
    if GatherLite.db.char.predefined then
        if _GatherLite.database then
            for type, arr in pairs(_GatherLite.database) do
                for i, node in pairs(arr) do
                    table.insert(_GatherLite.nodes[type], node)
                end
            end
        end
    end

    for type, arr in pairs(GatherLite.db.global.nodes) do
        for i, node in pairs(arr) do
            local pre = GatherLite:findExistingNode(node.type, node.position.x, node.position.y);
            if not pre then
                table.insert(_GatherLite.nodes[type], node)
            else
                pre.loot = node.loot;
                pre.coins = node.coins;
            end

            GatherLite.totalNodes = GatherLite.totalNodes + 1;
        end
    end
end

function GatherLite:ResetDatabase()
    for i, frame in ipairs(GatherLite.frames) do
        frame:Unload()
    end

    GatherLite.db.global.nodes = {
        mining = {},
        herbalism = {},
        treasure = {},
        fish = {},
        artifacts = {}
    }

    _GatherLite.nodes = {
        mining = {},
        herbalism = {},
        treasure = {},
        fish = {},
        artifacts = {}
    }

    GatherLite:loadDatabase();
end

function GatherLite:ResetDatabaseType(type)
    for i, frame in ipairs(GatherLite.frames) do
        if frame.node.type == type then
            frame:Unload()
        end
    end

    GatherLite.db.global.nodes[type] = {}
    _GatherLite.nodes[type] = {}
end
