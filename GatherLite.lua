local name, GatherLite = ...;
local HBD = LibStub("HereBeDragons-2.0");
local Pins = LibStub("HereBeDragons-Pins-2.0");
local Semver = LibStub("Semver");

local function IsClassic()
    local v = GetBuildInfo();
    return Semver.parse(v) < Semver.parse("2.0.0")
end

local function IsRetail()
    local v = GetBuildInfo();
    return Semver.parse(v) > Semver.parse("2.0.0")
end

GatherLite.name = name;
GatherLite.version = "@project-version@";
GatherLite.isClassic = IsClassic();
GatherLite.isRetail = IsRetail();

GatherLite.gatherSpellRanges = {
    default = 0.0065,
    fish = 0.0130
};
GatherLite.nodeUpdated = false;
GatherLite.needMapUpdate = false;

GatherLite.TimeSinceLastUpdate = 0;
GatherLite.UpdateInterval = 1.0;
GatherLite.nodes = {
    minimap = {},
    worldmap = {}
};

GatherLite.tracker = {};
GatherLite.tracker.spellType = nil;
GatherLite.tracker.spellID = nil;

if (GatherLite.isClassic) then
    GatherLite.spellIDs = {
        [GetSpellInfo(2575)] = "mining", -- Mining
        [GetSpellInfo(2366)] = "herbalism", -- Herbalism
        [GetSpellInfo(7620)] = "fish", -- Fishing(Apprentice)
        [GetSpellInfo(1804)] = "treasure", -- Pick Lock()
        [GetSpellInfo(3365)] = "treasure", -- Opening()
        [GetSpellInfo(3366)] = "treasure", -- Opening()
        [GetSpellInfo(6247)] = "treasure", -- Opening()
        [GetSpellInfo(6249)] = "treasure", -- Opening()
        [GetSpellInfo(6477)] = "treasure", -- Opening()
        [GetSpellInfo(6478)] = "treasure", -- Opening()
    };
elseif GatherLite.isRetail then
    GatherLite.spellIDs = {
        [GetSpellInfo(2575)] = "mining", -- Mining
        [GetSpellInfo(2366)] = "herbalism", -- Herbalism
        [GetSpellInfo(7620)] = "fish", -- Fishing(Apprentice)
        [GetSpellInfo(1804)] = "treasure", -- Pick Lock()
        [GetSpellInfo(3365)] = "treasure", -- Opening()
        [GetSpellInfo(3366)] = "treasure", -- Opening()
        [GetSpellInfo(6247)] = "treasure", -- Opening()
        [GetSpellInfo(6249)] = "treasure", -- Opening()
        [GetSpellInfo(6477)] = "treasure", -- Opening()
        [GetSpellInfo(6478)] = "treasure", -- Opening()
        [GetSpellInfo(6509)] = "treasure", -- Opening()
        [GetSpellInfo(6658)] = "treasure", -- Opening()
        [GetSpellInfo(6802)] = "treasure", -- Opening()
        [GetSpellInfo(8917)] = "treasure", -- Opening()
        [GetSpellInfo(21248)] = "treasure", -- Opening()
        [GetSpellInfo(21288)] = "treasure", -- Opening()
        [GetSpellInfo(21651)] = "treasure", -- Opening()
        [GetSpellInfo(24390)] = "treasure", -- Opening()
        [GetSpellInfo(24391)] = "treasure", -- Opening()
        [GetSpellInfo(26868)] = "treasure", -- Opening()
        [GetSpellInfo(39220)] = "treasure", -- Opening()
        [GetSpellInfo(39264)] = "treasure", -- Opening()
        [GetSpellInfo(45137)] = "treasure", -- Opening()
        [GetSpellInfo(22810)] = "treasure", -- Opening - No Text()
        [GetSpellInfo(73979)] = "artifacts", -- Searching for Artifacts(Apprentice)
    };
end;


GatherLite.classColours = {
    DEATHKNIGHT = { r = 0.77, g = 0.12, b = 0.23, fs = '|cffC41F3B' },
    DEMONHUNTER = { r = 0.64, g = 0.19, b = 0.79, fs = '|cffA330C9' },
    DRUID = { r = 1.00, g = 0.49, b = 0.04, fs = '|cffFF7D0A' },
    HUNTER = { r = 0.67, g = 0.83, b = 0.45, fs = '|cffABD473' },
    MAGE = { r = 0.25, g = 0.78, b = 0.92, fs = '|cff40C7EB' },
    PALADIN = { r = 0.96, g = 0.55, b = 0.73, fs = '|cffF58CBA' },
    PRIEST = { r = 1.00, g = 1.00, b = 1.00, fs = '|cffFFFFFF' },
    ROGUE = { r = 1.00, g = 0.96, b = 0.41, fs = '|cffFFF569' },
    SHAMAN = { r = 0.00, g = 0.44, b = 0.87, fs = '|cff0070DE' },
    WARLOCK = { r = 0.53, g = 0.53, b = 0.93, fs = '|cff8787ED' },
    WARRIOR = { r = 0.78, g = 0.61, b = 0.43, fs = '|cffC79C6E' }
}

GatherLite.defaultConfigs = {
    enabled = true,
    debugging = false,
    mining = true,
    fish = true,
    herbalism = true,
    treasure = true,
    artifacts = true,
    showOnMinimap = true,
    showOnWorldMap = true,
    minimapIconSize = 12,
    worldmapIconSize = 12,
    MiniMapPosition = 45,
    shareGuild = false;
    shareParty = false,
    minimapOpacity = 1,
    worldmapOpacity = 1,
    minimapLoot = true,
    worldmapLoot = true
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

function tablelength(T)
    local count = 0
    if T then
        for _ in pairs(T) do count = count + 1 end
    end
    return count
end

GatherLite.minimap:SetScript("OnEnter", function()
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:SetOwner(GatherLite.minimap, "ANCHOR_LEFT");
    GatherLite.tooltip:SetText(GatherLite.name .. " |cFF00FF00" .. GatherLite.version .. "|r");

    GatherLite.tooltip:AddDoubleLine("|cffffffffMining:|r", tablelength(GatherLiteGlobalSettings.database.mining));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(2770), { width = 14, height = 14 })

    GatherLite.tooltip:AddDoubleLine("|cffffffffHerbalism:|r", tablelength(GatherLiteGlobalSettings.database.herbalism));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(765), { width = 14, height = 14 })

    if not GatherLite.isClassic then
        GatherLite.tooltip:AddDoubleLine("|cffffffffArtifacts:|r", tablelength(GatherLiteGlobalSettings.database.artifacts));
        --        GatherLite.tooltip:AddTexture(GetItemIcon(1195), { width = 14, height = 14 })
    end;
    GatherLite.tooltip:AddDoubleLine("|cffffffffFish:|r", tablelength(GatherLiteGlobalSettings.database.fish));
    --    GatherLite.tooltip:AddTexture(GetItemIcon(6303), { width = 14, height = 14 })

    GatherLite.tooltip:AddDoubleLine("|cffffffffTreasures:|r", tablelength(GatherLiteGlobalSettings.database.treasure));
    --    GatherLite.tooltip:AddTexture(132594, { width = 14, height = 14 })

    GatherLite.tooltip:Show();
    GatherLite.showingTooltip = true;
end);

GatherLite.minimap:SetScript("OnLeave", function()
    GatherLite.hideTooltip();
end);

GatherLite.minimap:SetScript("OnClick", function(self, button)
    local dropDown = CreateFrame("Frame", "GatherLiteContextMenu", UIParent, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(dropDown, MinimapContextMenu, "MENU")
    ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
end);

GatherLite.minimap:Show()

-----------------------------------------------------------------------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------------------------------------------------------------------
GatherLite.tooltip = CreateFrame("GameTooltip", "GatherLiteTooltip", UIParent, "GameTooltipTemplate")
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
        GatherLiteGlobalSettings.database = {};
        GatherLite.needMapUpdate = true
    elseif msg == "test" then
        local x, y, mapID = HBD:GetPlayerZonePosition();
        print(x, y, mapID);
    end
end

GatherLite.findSpellType = function(spell)
    local spellInfo = GetSpellInfo(spell);

    for k, s in pairs(GatherLite.spellIDs) do
        if k == spellInfo then
            return s;
        end
    end;

    return nil;
end

GatherLite.findSpell = function(spellID)
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

GatherLite.showTooltip = function(title, ...)
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

GatherLite.hideTooltip = function()
    GatherLite.tooltip:ClearLines();
    GatherLite.tooltip:Hide();
    GatherLite.showingTooltip = false;
end

GatherLite.IsNodeInRange = function(myPosX, myPosY, nodePosX, nodePosY, spellType)
    local distance = ((((myPosX - nodePosX) ^ 2) + ((myPosY - nodePosY) ^ 2)) ^ 0.5)
    if spellType == "fish" then
        return distance < GatherLite.gatherSpellRanges.fish
    else
        return distance < GatherLite.gatherSpellRanges.default
    end;
end

GatherLite.addNode = function(spellID, spellType, target, icon, loot)
    local NodeIcon, NodeUpdated;
    local x, y, mapID = HBD:GetPlayerZonePosition();

    if not x and not y then
        return;
    end

    NodeUpdated = false;

    local newNode;

    if GatherLiteGlobalSettings.database == nil then
        GatherLiteGlobalSettings.database = {};
    end

    if GatherLiteGlobalSettings.database[spellType] == nil then
        GatherLiteGlobalSettings.database[spellType] = {};
    end

    if GatherLiteGlobalSettings.database ~= nil then
        for k, node in ipairs(GatherLiteGlobalSettings.database[spellType]) do
            if GatherLite.IsNodeInRange(x, y, node.position.x, node.position.y, spellType) then
                node.date = date('*t');
                newNode = node;
                NodeUpdated = true;

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

                GatherLite.debug("Found node at " .. "|cff32CD32" .. newNode.position.x .. " " .. newNode.position.y .. "|r");
            end
        end
    end

    if not NodeUpdated then
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

        newNode = node;

        table.insert(GatherLiteGlobalSettings.database[spellType], newNode);
        GatherLite.needMapUpdate = true;

        GatherLite.debug("Adding node at " .. "|cff32CD32" .. newNode.position.x .. " " .. newNode.position.y .. "|r");
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

GatherLite.updateMiniMapPosition = function()
    GatherLite.minimap:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end

function leadingZeros(value)
    value = tonumber(value);
    if (value < 10) then
        return "0" .. value;
    end;
    return value;
end

GatherLite.spawnMarker = function(node, minimap)
    local x, y, instance = HBD:GetWorldCoordinatesFromZone(node.position.x, node.position.y, node.position.mapID);
    local f = CreateFrame('Button', nil, WorldMapFrame.ScrollContainer.Child);
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
    f:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");

    if minimap then
        f:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
        table.insert(GatherLite.nodes.minimap, { frame = f, x = x, y = y })
    else
        f:SetAlpha(GatherLiteConfigCharacter.worldmapOpacity);
        table.insert(GatherLite.nodes.worldmap, { frame = f, x = x, y = y })
    end;

    GetPlayerInfoByGUID(node.GUID);
    f:SetScript('OnEnter', function()

        local locClass, engClass, locRace, engRace, gender, name = GetPlayerInfoByGUID(node.GUID);
        local classColor = GatherLite.classColours[engClass];
        local addLoot = false;

        if node.loot and minimap and GatherLiteConfigCharacter.minimapLoot then
            addLoot = true;
        end

        if node.loot and not minimap and GatherLiteConfigCharacter.worldmapLoot then
            addLoot = true;
        end

        f:SetAlpha(1);
        GatherLite.tooltip:ClearLines();
        if minimap then
            GatherLite.tooltip:SetOwner(f, "ANCHOR_CURSOR");
            table.insert(GatherLite.nodes.minimap, { frame = f, x = x, y = y });
        else
            GatherLite.tooltip:SetOwner(f, "ANCHOR_TOPLEFT");
            table.insert(GatherLite.nodes.worldmap, { frame = f, x = x, y = y });
        end;

        GatherLite.tooltip:SetText(node.name);
        GatherLite.tooltip:AddDoubleLine("Last visit:", "|cffffffff" .. leadingZeros(node.date.day) .. '/' .. leadingZeros(node.date.month) .. '/' .. leadingZeros(node.date.year) .. " - " .. leadingZeros(node.date.hour) .. ':' .. leadingZeros(node.date.min) .. ':' .. leadingZeros(node.date.sec) .. "|r");

        if addLoot then
            for k, item in pairs(node.loot) do
                GatherLite.tooltip:AddDoubleLine(k, "x" .. item.count);

            

--                if (GetItemInfo(k)) then
--                    --                    GatherLite.tooltip:AddTexture(GetItemIcon(k), { width = 14, height = 14 })
--                elseif GetCurrencyInfo(k) then
--                    local cName, cAmount, cTexture = GetCurrencyInfo(k);
--                    --                    GatherLite.tooltip:AddTexture(cTexture, { width = 14, height = 14 })
--                end;
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

    local icon = node.icon;
    --    if GetItemInfo(node.icon) then
    --        icon = GetItemIcon(node.icon);
    --    end

    f.texture = f:CreateTexture(nil, 'ARTWORK')
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(icon)

    if minimap then
        Pins:AddMinimapIconWorld("GathererClassic", f, instance, x, y, false);
    else
        Pins:AddWorldMapIconWorld("GathererClassic", f, instance, x, y);
    end;
end

GatherLite.UpdateMapNodes = function()
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

    --    if GatherLiteConfigCharacter.open then
    if GatherLiteConfigCharacter.treasure then
        if GatherLiteGlobalSettings.database["treasure"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["treasure"]) do
                GatherLite.spawnMarker(node);
            end
        end
    end

    if GatherLiteConfigCharacter.artifacts then
        if GatherLiteGlobalSettings.database["artifacts"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["artifacts"]) do
                GatherLite.spawnMarker(node);
            end
        end
    end

    if GatherLiteConfigCharacter.fish then
        if GatherLiteGlobalSettings.database["fish"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["fish"]) do
                GatherLite.spawnMarker(node);
            end
        end
    end
end

GatherLite.UpdateMinimapNodes = function()
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

    if GatherLiteConfigCharacter.treasure then
        if GatherLiteGlobalSettings.database["treasure"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["treasure"]) do
                GatherLite.spawnMarker(node, true);
            end
        end
    end

    if GatherLiteConfigCharacter.artifacts then
        if GatherLiteGlobalSettings.database["artifacts"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["artifacts"]) do
                GatherLite.spawnMarker(node, true);
            end
        end
    end

    if GatherLiteConfigCharacter.fish then
        if GatherLiteGlobalSettings.database["fish"] then
            for k, node in ipairs(GatherLiteGlobalSettings.database["fish"]) do
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
            text = "Mining",
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
            text = "Herbalism",
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

        if not GatherLite.isClassic then
            addContextItem({
                text = "Archaeology",
                icon = 134435,
                checked = GatherLiteConfigCharacter.artifacts,
                callback = function()
                    if GatherLiteConfigCharacter.artifacts then
                        GatherLiteConfigCharacter.artifacts = false;
                    else
                        GatherLiteConfigCharacter.artifacts = true;
                    end;
                    GatherLite.needMapUpdate = true;
                end
            })
        end

        addContextItem({
            text = "Fish",
            icon = GetItemIcon(6303),
            checked = GatherLiteConfigCharacter.fish,
            callback = function()
                if GatherLiteConfigCharacter.fish then
                    GatherLiteConfigCharacter.fish = false;
                else
                    GatherLiteConfigCharacter.fish = true;
                end;
                GatherLite.needMapUpdate = true;
            end
        })

        addContextItem({
            text = "Treasure chests",
            icon = 132594,
            checked = GatherLiteConfigCharacter.treasure,
            callback = function()
                if GatherLiteConfigCharacter.treasure then
                    GatherLiteConfigCharacter.treasure = false;
                else
                    GatherLiteConfigCharacter.treasure = true;
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

    if not NodeUpdated then
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
    end
end

GatherLite.foundOreOrHerb = function()
    local primary = GetLootSlotLink(1)


    local loot = {};

    local coin;
    local count = GetNumLootItems()
    for i = 1, count do
        local lIcon, lName, lQuantity, lQuality = GetLootSlotInfo(i)
        local slotType = GetLootSlotType(i)
        local lLink = GetLootSlotLink(i)
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

    if (primary) then
        primary = primary:match("item:(%d+)")
        if (primary) then
            if GatherLite.tracker.spellType == "fish" then
                GatherLite.addNode(GatherLite.tracker.spellID, GatherLite.tracker.spellType, "Fishing spot", GetItemIcon(6303), loot);
            else
                GatherLite.addNode(GatherLite.tracker.spellID, GatherLite.tracker.spellType, GatherLite.tracker.target, GetItemIcon(primary), loot);
            end
        elseif not primary and GatherLite.tracker.spellType == "artifacts" then
            GatherLite.addNode(GatherLite.tracker.spellID, GatherLite.tracker.spellType, GatherLite.tracker.target, GetItemIcon(1195), loot);
        end;
    end
end

GatherLite.foundTreasureChest = function()
    local loot = {};
    local count = GetNumLootItems()
    for i = 1, count do
        local lIcon, lName, lQuantity, lQuality = GetLootSlotInfo(i);
        local slotType = GetLootSlotType(i);
        local lLink = GetLootSlotLink(i);
        loot[lLink] = { name = lName, count = tonumber(lQuantity) }
    end;
    -- chest icon 132594

    GatherLite.addNode(GatherLite.tracker.spellID, GatherLite.tracker.spellType, GatherLite.tracker.target, 132594, loot);
end

local isCasting = false
GatherLite.handleSpell = function(event, spell, target)
    if (event == "UNIT_SPELLCAST_SENT") then
        local spellType = GatherLite.findSpellType(spell);
        if (spellType) then
            GatherLite.debug("Started gathering with " .. GetSpellInfo(spell));
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

GatherLite.mainFrame:SetScript('OnUpdate', function(self, elapsed)
    GatherLite.TimeSinceLastUpdate = GatherLite.TimeSinceLastUpdate + elapsed;

    if GatherLite.needMapUpdate then
        GatherLite.UpdateMinimapNodes();
        GatherLite.UpdateMapNodes();
        GatherLite.needMapUpdate = false;
    end;

    if (GatherLite.TimeSinceLastUpdate > GatherLite.UpdateInterval) then
        local x, y, instance = HBD:GetPlayerWorldPosition();
        for k, node in ipairs(GatherLite.nodes.minimap) do
            local distance, deltax, deltay = HBD:GetWorldDistance(instance, x, y, node.x, node.y);
            if (distance) then
                if distance < 70 then
                    node.frame:SetAlpha(0);
                else
                    node.frame:SetAlpha(GatherLiteConfigCharacter.minimapOpacity);
                end;
            end
        end
        GatherLite.TimeSinceLastUpdate = 0;
    end
end);

GatherLite.mainFrame:SetScript('OnEvent', function(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == GatherLite.name then
        if GatherLiteGlobalSettings == nil then
            GatherLiteGlobalSettings = {
                database = {
                    mining = {},
                    herbalism = {},
                    treasure = {}
                }
            };
        end

        GatherLiteConfigCharacter = GatherLite.CopyDefaults(GatherLite.defaultConfigs, GatherLiteConfigCharacter);

        GatherLite.print("GatherLite", "|cFF00FF00" .. GatherLite.version .. "|r", "has been loaded");
        GatherLite.debug("Found", "|cFF00FF00" .. tablelength(GatherLiteGlobalSettings.database.mining) .. "|r", "mining nodes");
        GatherLite.debug("Found", "|cFF00FF00" .. tablelength(GatherLiteGlobalSettings.database.herbalism) .. "|r", "herbalism nodes");
        if not GatherLite.isClassic then
            GatherLite.debug("Found", "|cFF00FF00" .. tablelength(GatherLiteGlobalSettings.database.artifacts) .. "|r", "artifact nodes");
        end
        GatherLite.debug("Found", "|cFF00FF00" .. tablelength(GatherLiteGlobalSettings.database.fish) .. "|r", "fishing spots");
        GatherLite.debug("Found", "|cFF00FF00" .. tablelength(GatherLiteGlobalSettings.database.treasure) .. "|r", "treasures");
        GatherLite.updateMiniMapPosition();
        C_ChatInfo.RegisterAddonMessagePrefix(GatherLite.name);

        self:UnregisterEvent("ADDON_LOADED");
    elseif event == "LOOT_OPENED" then
        if (GatherLite.tracker.spellID and GatherLite.tracker.ended and GetTime() - GatherLite.tracker.ended < 1) then
            if (GatherLite.tracker.spellType == "mining" or GatherLite.tracker.spellType == "herbalism" or GatherLite.tracker.spellType == "artifacts") then
                GatherLite.foundOreOrHerb();
            elseif (GatherLite.tracker.spellType == "treasure") then
                GatherLite.foundTreasureChest();
            end;
            GatherLite.tracker.target = nil;
            GatherLite.tracker.spellID = nil;
            GatherLite.tracker.spellType = nil;
        elseif (GatherLite.tracker.spellID and IsFishingLoot()) then
            GatherLite.foundOreOrHerb();
            GatherLite.tracker.target = nil;
            GatherLite.tracker.spellID = nil;
            GatherLite.tracker.spellType = nil;
        end

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