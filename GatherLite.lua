local name, GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");

GatherLite.name = name;
GatherLite.version = "@project-version@";

GatherLite.gatherSpellRange = 0.0065;
GatherLite.nodeUpdated = false;
GatherLite.needMapUpdate = false;

GatherLite.tracker = {};
GatherLite.tracker.spellType = nil;
GatherLite.tracker.spellID = nil;

GatherLite.spellIDs = {
    [GetSpellInfo(2575)] = "mining",
    [GetSpellInfo(2366)] = "herbalism"
};

GatherLite.classColours = {
    DEATHKNIGHT = { r = 0.77, g = 0.12, b = 0.23, fs = '|cffC41F3B' },
    DRUID = { r = 1.00, g = 0.49, b = 0.04, fs = '|cffFF7D0A' },
    HUNTER = { r = 0.67, g = 0.83, b = 0.45, fs = '|cffABD473' },
    MAGE = { r = 0.25, g = 0.78, b = 0.92, fs = '|cff40C7EB' },
    PALADIN = { r = 0.96, g = 0.55, b = 0.73, fs = '|cffF58CBA' },
    PRIEST = { r = 1.00, g = 1.00, b = 1.00, fs = '|cffFFFFFF' },
    ROGUE = { r = 1.00, g = 0.96, b = 0.41, fs = '|cffFFF569' },
    SHAMAN = { r = 0.00, g = 0.44, b = 0.87, fs = '|cff0070DE' },
    WARLOCK = { r = 0.53, g = 0.53, b = 0.93, fs = '|cff8787ED' },
    WARRIOR = { r = 0.78, g = 0.61, b = 0.43, fs = '|cffC79C6E' },
    Total = { r = 1, g = 1, b = 1 }
}

GatherLite.defaultConfigs = {
    enabled = true,
    debugging = true,
    mining = true,
    herbalism = true,
    treasures = true,
    showOnMinimap = true,
    showOnWorldMap = true,
    minimapIconSize = 12,
    worldmapIconSize = 12,
    MiniMapPosition = 45,
    shareGuild = false;
    shareParty = false
}

-----------------------------------------------------------------------------------------------------------------------------------
-- MAIN FRAME
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.mainFrame = CreateFrame('FRAME', nil, UIParent)
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_FAILED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
GatherLite.mainFrame:RegisterEvent('UNIT_SPELLCAST_SENT')
GatherLite.mainFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
GatherLite.mainFrame:RegisterEvent('ADDON_LOADED')
GatherLite.mainFrame:RegisterEvent('CHAT_MSG_ADDON')
GatherLite.mainFrame:RegisterEvent('LOOT_OPENED')

-----------------------------------------------------------------------------------------------------------------------------------
-- MINI MAP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.minimap = CreateFrame("Button", "GatherLite_MinimapButton", Minimap);
GatherLite.minimap:EnableMouse(true);
GatherLite.minimap:SetMovable(true);
GatherLite.minimap:SetSize(33, 33);
GatherLite.minimap:SetPoint("TOPLEFT");
GatherLite.minimap:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
GatherLite.minimap:RegisterForClicks("LeftButtonUp", "RightButtonUp");
GatherLite.minimap:RegisterForDrag("LeftButton");


local t = GatherLite.minimap:CreateTexture(nil, "OVERLAY");
t:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
t:SetSize(56, 56);
t:SetPoint("TOPLEFT");

local t = GatherLite.minimap:CreateTexture(nil, "background");
t:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
t:SetSize(21, 21);
t:SetPoint("CENTER");

GatherLite.minimapFrame = CreateFrame("FRAME", nil, GatherLite.minimap);
GatherLite.minimapFrame:SetScript("OnUpdate", function()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70 -- get coordinates as differences from the center of the minimap
    ypos = ypos / UIParent:GetScale() - ymin - 70

    GatherLiteConfigCharacter.MiniMapPosition = math.deg(math.atan2(ypos, xpos))
    GatherLite.updateMiniMapPosition()
end);
GatherLite.minimapFrame:Hide();

GatherLite.minimap:SetScript("OnDragStart", function(self)
    self:LockHighlight();
    GatherLite.minimapFrame:Show();
    GatherLite.tooltip:Hide();
end);

GatherLite.minimap:SetScript("OnDragStop", function(self)
    self:UnlockHighlight();
    GatherLite.minimapFrame:Hide();
    if (GatherLite.showingTooltip) then
        GatherLite.tooltip:Show();
    end;
end);

GatherLite.minimap:SetScript("OnEnter", function()
    GatherLite.showTooltip(GatherLite.name, {
        "|cffC0C0C0Left click|r: Toggle on|off",
        "|cffC0C0C0Right click|r: Show menu"
    });
end);

GatherLite.minimap:SetScript("OnLeave", function()
    GatherLite.hideTooltip();
end);

GatherLite.minimap:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        if GatherLiteConfigCharacter.enabled then
            GatherLiteConfigCharacter.enabled = false;
        else
            GatherLiteConfigCharacter.enabled = true;
        end
        GatherLite.needMapUpdate = true;
    elseif button == "RightButton" then
        local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(dropDown, MinimapContextMenu, "MENU")
        ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
    end;
end);

GatherLite.minimap:Show()

-----------------------------------------------------------------------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.tooltip = CreateFrame("GameTooltip", nil, UIParent, "GameTooltipTemplate")
GatherLite.tooltip:ClearLines()
GatherLite.tooltip:AddFontStrings(GatherLite.tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), GatherLite.tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));
GatherLite.showingTooltip = false;

GatherLite.print = function(...)
    print("|cffF0E68C[" .. GatherLite.name .. "]|cffFFFFFF:", ...)
end

GatherLite.debug = function(...)
    if (GatherLiteConfigCharacter.debugging) then
        print("|cff008080[" .. GatherLite.name .. " - Debugging]|cffFFFFFF:", ...)
    end
end

SLASH_GATHER1 = '/GATHER'
SLASH_GATHER2 = '/GATHERER'
SlashCmdList['GATHER'] = function(msg)
    if msg == 'reload' then
        GatherLite.print("Reloading map");
        GatherLite.needMapUpdate = true;
    elseif msg == "debugging on" then
        GatherLiteConfigCharacter.debugging = true
        GatherLite.print("debugging enabled");
    elseif msg == "debugging off" then
        GatherLiteConfigCharacter.debugging = false
        GatherLite.print("debugging disabled");
    elseif msg == "reset" then
        GatherLiteGlobalSettings.database = {
            mining = {},
            herbalism = {},
        };
        GatherLite.needMapUpdate = true
    end
end

function GatherLite.findSpellType(spell)
    local spellInfo = GetSpellInfo(spell);

    for k, s in pairs(GatherLite.spellIDs) do
        if k == spellInfo then
            return s;
        end
    end;

    return nil;
end

function GatherLite.findSpell(spellID)
    for k, s in pairs(GatherLite.spellIDs["mining"]) do
        if s == spellID then
            return "mining", s;
        end
    end;

    for k, s in pairs(GatherLite.spellIDs["herbalism"]) do
        if s == spellID then
            return "herbalism", s;
        end
    end;

    return nil, nil;
end

function GatherLite.showTooltip(title, ...)
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    GatherLite.tooltip:SetText(title);

    if ... then
        for r, l in ipairs(...) do
            GatherLite.tooltip:AddLine(l);
        end
    end
    GatherLite.tooltip:Show();
    GatherLite.showingTooltip = true;
end

function GatherLite.hideTooltip()
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:Hide();
    GatherLite.showingTooltip = false;
end

function GatherLite.IsNodeInRange(myPosX, myPosY, nodePosX, nodePosY)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    if distance < GatherLite.gatherSpellRange then
        return true
    else
        return false
    end
end

function GatherLite.addNode(spellID, spellType, target, icon)
    local CurrentMapID, CurrentMapPosition, CurrentMapName, NodeIcon, NodeUpdated;

    CurrentMapID = C_Map.GetBestMapForUnit('player');
    CurrentMapPosition = C_Map.GetPlayerMapPosition(CurrentMapID, 'player');
    CurrentMapName = C_Map.GetMapInfo(CurrentMapID).name;
    NodeUpdated = false;

    local newNode = {};

    if GatherLiteGlobalSettings.database ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.database[spellType]) do
            if GatherLite.IsNodeInRange(CurrentMapPosition.x, CurrentMapPosition.y, node.position.x, node.position.y) then
                node.date = date('*t');
                newNode = node;
                NodeUpdated = true;
                GatherLite.debug("Found node at " .. "|cff32CD32" .. newNode.position.x .. " " .. newNode.position.y .. "|r");
            end
        end
    end

    if not NodeUpdated then
        newNode = {
            GUID = UnitGUID('player'),
            type = spellType,
            spellID = spellID,
            target = string.lower(target),
            name = target,
            icon = icon,
            position = {
                mapID = CurrentMapID,
                x = CurrentMapPosition.x,
                y = CurrentMapPosition.y
            },
            date = date('*t'),
        };

        table.insert(GatherLiteGlobalSettings.database[spellType], newNode);
        GatherLite.needMapUpdate = true;

        GatherLite.debug("Found node at " .. "|cff32CD32" .. newNode.position.x .. " " .. newNode.position.y .. "|r");
    end

    local dataString = tostring('newdata' .. ':' .. UnitGUID('player') .. ":" .. newNode.type .. ":" .. newNode.spellID .. ":" .. newNode.target .. ":" .. newNode.target .. ":" .. newNode.icon .. ":" .. newNode.position.mapID .. ":" .. newNode.position.x .. ":" .. newNode.position.y)

    if IsInGuild() and GatherLiteConfigCharacter.shareGuild then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'GUILD')
        GatherLite.debug("sharing node with guild");
    end

    if IsInGroup() and GatherLiteConfigCharacter.shareParty then
        C_ChatInfo.SendAddonMessage(GatherLite.name, dataString, 'PARTY')
        GatherLite.debug("sharing node with party");
    end
end

function GatherLite.CopyDefaults(src, dst)
    if type(src) ~= "table" then return {} end
    if type(dst) ~= "table" then dst = {} end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = CopyDefaults(v, dst[k])
        elseif type(v) ~= type(dst[k]) then
            dst[k] = v
        end
    end
    return dst
end

function GatherLite.updateMiniMapPosition()
    GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end

function GatherLite.spawnMarker(node, minimap)
    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    local f = CreateFrame('FRAME', nil, WorldMapFrame.ScrollContainer.Child)

    f:SetPoint("TOPLEFT", x, (y * -1))

    if minimap then
        f:SetSize(GatherLiteConfigCharacter.minimapIconSize, GatherLiteConfigCharacter.minimapIconSize)
    else
        f:SetSize(GatherLiteConfigCharacter.worldmapIconSize, GatherLiteConfigCharacter.worldmapIconSize)
    end;
    f:SetFrameLevel(1)
    f:SetFrameStrata("HIGH")
    f:EnableKeyboard(true)
    f:SetPropagateKeyboardInput(true)

    GetPlayerInfoByGUID(node.GUID);
    f:SetScript('OnEnter', function()

        local locClass, engClass, locRace, engRace, gender, name = GetPlayerInfoByGUID(node.GUID);
        local classColor = GatherLite.classColours[engClass];

        GatherLite.showTooltip(GetItemInfo(node.icon), {
            "|cffffffffLast visit: " .. node.date.day .. '/' .. node.date.month .. '/' .. node.date.year .. " - " .. node.date.hour .. ':' .. node.date.min .. ':' .. node.date.sec .. "|r",
            "Found by: " .. classColor.fs .. name
        });
    end)

    f:SetScript('OnLeave', function()
        GatherLite.tooltip:Hide()
    end)

    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(GetItemIcon(node.icon))

    if minimap then
        Pins:AddMinimapIconWorld("GathererClassic", f, instance, x, y, false);
    else
        Pins:AddWorldMapIconWorld("GathererClassic", f, instance, x, y);
    end;
end

function GatherLite.UpdateMapNodes()
    Pins:RemoveAllWorldMapIcons("GathererClassic")

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnWorldMap then
        return
    end

    GatherLite.debug("Updating world map nodes");

    if GatherLiteConfigCharacter.mining then
        if GatherLiteGlobalSettings.database["mining"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["mining"]) do
                GatherLite.spawnMarker(node);
            end
        end
    end

    if GatherLiteConfigCharacter.herbalism then
        if GatherLiteGlobalSettings.database["herbalism"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["herbalism"]) do
                GatherLite.spawnMarker(node);
            end
        end
    end
end

function GatherLite.UpdateMinimapNodes()
    Pins:RemoveAllMinimapIcons("GathererClassic")

    if not GatherLiteConfigCharacter.enabled or not GatherLiteConfigCharacter.showOnMinimap then
        return
    end

    GatherLite.debug("Updating mini map nodes");

    if GatherLiteConfigCharacter.mining then
        if GatherLiteGlobalSettings.database["mining"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["mining"]) do
                GatherLite.spawnMarker(node, true);
            end
        end
    end

    if GatherLiteConfigCharacter.herbalism then
        if GatherLiteGlobalSettings.database["herbalism"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["herbalism"]) do
                GatherLite.spawnMarker(node, true);
            end
        end
    end
end

function addContextItem(args)
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

function MinimapContextMenu(frame, level, menuList)

    if level == 1 then

        addContextItem({
            text = "GatherLite",
            isTitle = true,
            notCheckable = true
        });

        addContextItem({
            text = "Mining nodes",
            icon = GetItemIcon(2770),
            checked = GatherLiteConfigCharacter.mining,
            callback = function()
                if GatherLiteConfigCharacter.mining then
                    GatherLiteConfigCharacter.mining = false;
                else
                    GatherLiteConfigCharacter.mining = true;
                end;

                GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = "Herbalism nodes",
            icon = GetItemIcon(765),
            checked = GatherLiteConfigCharacter.herbalism,
            callback = function()
                if GatherLiteConfigCharacter.herbalism then
                    GatherLiteConfigCharacter.herbalism = false;
                else
                    GatherLiteConfigCharacter.herbalism = true;
                end;
                GatherLite.needMapUpdate = true;
            end
        })
    end
end

function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

function GatherLite.ParseSentData(msg, sender)
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

    if not NodeUpdated then
        local node = {
            GUID = data[1],
            type = data[2],
            spellID = tonumber(data[3]),
            target = data[4],
            name = data[5],
            icon = data[6],
            position = {
                mapID = tonumber(data[7]),
                x = tonumber(data[8]),
                y = tonumber(data[9])
            },
            date = date('*t'),
        };

        table.insert(GatherLiteGlobalSettings.database[spellType], node);
        GatherLite.needMapUpdate = true;
    end
end

GatherLite.mainFrame:SetScript('OnEvent', function(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == GatherLite.name then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = {
                database = {
                    mining = {},
                    herbalism = {},
                    treasures = {}
                }
            };
        end

        GatherLiteConfigCharacter = GatherLite.CopyDefaults(GatherLite.defaultConfigs, GatherLiteConfigCharacter);

        GatherLite.print("addon is loaded");
        GatherLite.updateMiniMapPosition();
        C_ChatInfo.RegisterAddonMessagePrefix(GatherLite.name);

        self:UnregisterEvent("ADDON_LOADED");
    elseif event == "LOOT_OPENED" then
        if (GatherLite.tracker.spellID and GatherLite.tracker.ended and GetTime() - GatherLite.tracker.ended < 1) then
            local primary = GetLootSlotLink(1)
            if (primary) then
                primary = primary:match("item:(%d+)")
                if (primary) then
                    GatherLite.addNode(GatherLite.tracker.spellID, GatherLite.tracker.spellType, GatherLite.tracker.target, primary);
                end
            end

            GatherLite.tracker.target = nil;
            GatherLite.tracker.spellID = nil;
            GatherLite.tracker.spellType = nil;
        end;
    elseif (event == "UNIT_SPELLCAST_SENT") or (event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED") then
        GatherLite.handleSpell(event, select(4, ...), select(2, ...));
    elseif (event == "PLAYER_ENTERING_WORLD") then
        GatherLite.needMapUpdate = true;
    elseif event == 'CHAT_MSG_ADDON' then
        if string.find(select(1, ...), GatherLite.name) then
            local msg = select(2, ...)
            local sender = select(5, ...)
            GatherLite.ParseSentData(msg, sender)
        end
    end
end);

local isCasting = false
function GatherLite.handleSpell(event, spell, target)
    if (event == "UNIT_SPELLCAST_SENT") then
        local spellType = GatherLite.findSpellType(spell);
        if (spellType) then
            GatherLite.debug("Started gathering from " .. target .. " with " .. GetSpellInfo(spell));
            GatherLite.tracker.target = target;
            GatherLite.tracker.spellID = spell;
            GatherLite.tracker.spellType = spellType;
            isCasting = true;
        end;
    elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
        GatherLite.tracker.ended = GetTime();
        isCasting = false;
    elseif ((event == "UNIT_SPELLCAST_INTERRUPTED") or (event == "UNIT_SPELLCAST_FAILED")) then
        isCasting = false
        -- Spell failed, cancel the tracking
        GatherLite.tracker.target = nil;
        GatherLite.tracker.spellID = nil;
        GatherLite.tracker.spellType = nil;
    end
end

GatherLite.mainFrame:SetScript('OnUpdate', function()
    if GatherLite.needMapUpdate then
        GatherLite.UpdateMinimapNodes();
        GatherLite.UpdateMapNodes();
        GatherLite.needMapUpdate = false;
    end;
end);