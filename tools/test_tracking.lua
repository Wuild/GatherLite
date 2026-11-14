-- Exercise actual menu callbacks, map modules, frame recycling, and lazy loading.
local addon, libraries, frames, menu, options, minimapButton = {}, {}, {}, {}, nil, nil
local function noop() end
strlenutf8 = string.len
local resume = coroutine.resume
coroutine.resume = function(thread, ...)
    assert(coroutine.status(thread) ~= "dead", "resuming a completed minimap worker")
    local ok, err = resume(thread, ...)
    assert(ok, err)
    return ok, err
end
local function makeFrame(parent)
    local f = { scripts = {}, parent = parent, shown = true }
    for _, method in ipairs({ "SetSize", "SetWidth", "SetHeight", "SetPoint", "SetAllPoints",
        "EnableMouse", "SetAlpha", "SetFrameLevel", "SetTexture", "SetVertexColor",
        "SetTexelSnappingBias", "SetSnapToPixelGrid", "SetTexCoord", "SetHighlightTexture", "RegisterForClicks", "RegisterForDrag" }) do
        f[method] = noop
    end
    function f:SetScript(event, fn) self.scripts[event] = fn end
    function f:RegisterEvent(event)
        self.events = self.events or {}
        self.events[event] = true
    end
    function f:SetTexture(path) self.texturePath = path end
    function f:Show() self.shown = true end
    function f:Hide() self.shown = false end
    function f:IsShown() return self.shown end
    f.IsVisible = f.IsShown
    function f:GetParent() return self.parent end
    function f:SetVertexColor(...) self.color = {...} end
    function f:GetVertexColor() return unpack(self.color or {1, 1, 1, 1}) end
    function f:SetSize(width, height) self.width, self.height = width, height end
    function f:GetWidth() return self.width or 140 end
    function f:SetAllPoints(frame) self.point = {"ALL", frame} end
    function f:ClearAllPoints() self.point = nil end
    function f:SetHitRectInsets(...) self.hitInsets = {...} end
    function f:GetFrameLevel() return self.level or 8 end
    function f:SetFrameLevel(level) self.level = level end
    function f:SetPoint(...) self.point = {...} end
    function f:SetFrameStrata(strata) self.strata = strata end
    function f:SetMouseClickEnabled(enabled) self.clickEnabled = enabled end
    function f:SetMouseMotionEnabled(enabled) self.motionEnabled = enabled end
    function f:GetFrameStrata() return self.strata or (self.parent and self.parent:GetFrameStrata()) or "MEDIUM" end
    function f:CreateTexture() return makeFrame(self) end
    frames[#frames + 1] = f
    return f
end
CreateFrame = function(_, name, parent)
    local f = makeFrame(parent)
    if name then _G[name] = f end
    return f
end
UIParent, WorldMapFrame, Minimap = makeFrame(), makeFrame(), makeFrame()
WorldMapFrame:SetFrameStrata("HIGH")
WorldMapFrame.mapID = 1429
WorldMapFrame:Hide()
WorldMapFrame.ScrollContainer = makeFrame(WorldMapFrame)
WorldMapFrame.ScrollContainer:SetFrameLevel(1800)
WorldMapTrackingPinButtonMixin = { OnLoad = noop }
local mapPin = makeFrame(WorldMapFrame)
mapPin.OnLoad = WorldMapTrackingPinButtonMixin.OnLoad
WorldMapFrame.overlayFrames = { mapPin }
InCombatLockdown = function() return false end
C_AddOns = { GetAddOnMetadata = function() return "test" end }
C_Map = { GetBestMapForUnit = function() return 1429 end }
C_Minimap = { SetTracking = function() error("map pin filters must never change WoW tracking spells") end }
GetTime = function() return 100 end
IsInInstance = function() return false end
tinsert, tremove = table.insert, table.remove
local pins = { minimap = {}, worldmap = {} }
local pinAdds, pinRemoves = 0, 0
function pins:AddMinimapIconWorld(_, frame, instance, x, y)
    assert(type(instance) == "number" and type(x) == "number" and type(y) == "number", "invalid minimap pin position")
    pinAdds = pinAdds + 1
    self.minimap[frame] = true
    frame:Show()
end
function pins:AddWorldMapIconMap(_, frame) pinAdds=pinAdds+1; self.worldmap[frame] = true; frame:Show() end
function pins:RemoveMinimapIcon(_, frame) pinRemoves=pinRemoves+1; self.minimap[frame] = nil end
function pins:RemoveWorldMapIcon(_, frame) pinRemoves=pinRemoves+1; self.worldmap[frame] = nil end
libraries["HereBeDragons-Pins-2.0"] = pins
local playerX, playerY = 500, 500
libraries["HereBeDragons-2.0"] = {
    GetPlayerZonePosition = function() return playerX / 1000, playerY / 1000, 1429 end,
    GetPlayerWorldPosition = function() return playerX, playerY, 0 end,
    GetWorldCoordinatesFromZone = function(_, x, y) return x * 1000, y * 1000, 0 end,
    GetWorldVector = function(_, _, x1, y1, x2, y2) return 0, math.sqrt((x2-x1)^2 + (y2-y1)^2) end,
    GetZoneSize = function() return 1000, 1000 end,
    GetZoneCoordinatesFromWorldInstance = function(_, x, y, instance)
        if instance == 0 then return x / 1000, y / 1000 end
    end,
}
local locale = {}
libraries["AceLocale-3.0"] = { NewLocale = function() return locale end, GetLocale = function() return locale end }
libraries["AceAddon-3.0"] = { NewAddon = function() return { SendMessage = noop } end, GetAddon = function() return GatherLite end }
libraries["AceConfig-3.0"] = { RegisterOptionsTable = function(_, _, value) options = value end }
libraries["AceConfigDialog-3.0"] = { AddToBlizOptions = noop }
libraries["AceConfigRegistry-3.0"] = { NotifyChange = noop }
libraries["LibDataBroker-1.1"] = { NewDataObject = function(_, _, object) minimapButton = object; return object end }
libraries.Semver = {}
LibStub = setmetatable({ NewLibrary = function(_, name) libraries[name] = {}; return libraries[name] end },
    { __call = function(_, name, silent)
        if silent then return libraries[name] end
        return assert(libraries[name], name)
    end })
local menuOwner
MenuUtil = {
    CreateContextMenu = function(owner, generator)
        menuOwner = owner
        local root = {
            CreateTitle = function(_, title) menu[#menu + 1] = { text = title } end,
            CreateCheckbox = function(_, text, isSelected, onSelect, data)
                menu[#menu + 1] = { text = text,
                    checked = function() return isSelected(data) end,
                    func = function() onSelect(data) end }
            end,
            CreateDivider = function() menu[#menu + 1] = { divider = true } end,
            CreateButton = function(_, text, func) menu[#menu + 1] = { text = text, func = func } end,
        }
        generator(owner, root)
    end,
}
local closedMenus = 0
Menu = { GetManager = function() return { CloseMenus = function() closedMenus = closedMenus + 1 end } end }
for _, path in ipairs({ "scripts/locales/enUS.lua", "scripts/compat.lua", "scripts/config.lua",
    "scripts/nodes.lua", "scripts/frame.lua", "scripts/methods.lua", "scripts/maps/zone-neighbors.lua", "scripts/zones.lua", "scripts/settings.lua", "scripts/main.lua",
    "scripts/modules/worldmap.lua", "scripts/modules/minimap.lua", "plugins/database/database.lua" }) do
    assert(loadfile(path))("GatherLite", addon)
end
options = addon.SettingsOptions
GatherLite.db = addon.configsDefaults
GatherLite.debug = noop

-- Current AceDB uses the globally unique Forever name. Migrate the previous
-- ruleset key once, retaining values already written under the new key.
local migrated = {
    char = {
        ["Miner - PvP"] = { minimap = { size = 18, tracking = { mining = false } }, routeMapID = 7 },
        ["Miner Stone"] = { minimap = { size = 14 } },
    },
    profileKeys = { ["Miner - PvP"] = "Custom", ["Miner Stone"] = "Default" },
}
assert(addon.MigrateCharacterSettings(migrated, "Miner Stone", "Miner - PvP") == "Custom")
assert(not migrated.char["Miner - PvP"] and not migrated.profileKeys["Miner - PvP"],
    "legacy character keys must be removed after migration")
assert(migrated.char["Miner Stone"].minimap.size == 14
    and migrated.char["Miner Stone"].minimap.tracking.mining == false
    and migrated.char["Miner Stone"].routeMapID == 7,
    "migration must retain new values and fill missing legacy settings")
assert(migrated.profileKeys["Miner Stone"] == "Custom", "legacy profile selection must migrate")

-- Exercise the real AceDB profile storage using the existing client fixture.
do
    local env=setmetatable({
        LibStub=false, strlenutf8=string.len,
        UnitFactionGroup=function() return "Alliance" end,
        UnitClass=function() return "Druid", "DRUID" end,
        UnitRace=function() return "Night Elf", "NightElf" end,
        GetLocale=function() return "enUS" end,
        GetRealmName=function() return "Forever" end,
        UnitNameUnmodified=function() return "Miner" end,
        GetCurrentRegionName=function() return "EU" end,
        GetCurrentRegion=function() return 3 end,
        RegionalUniqueNamesEnabled=function() return false end,
        securecallfunction=function(fn, ...) return fn(...) end,
    },{__index=_G})
    env._G=env
    for _,file in ipairs({
        "LibStub/LibStub.lua", "CallbackHandler-1.0/CallbackHandler-1.0.lua", "AceDB-3.0/AceDB-3.0.lua",
        "AceConfig-3.0/AceConfigRegistry-3.0/AceConfigRegistry-3.0.lua",
    }) do
        setfenv(assert(loadfile("scripts/libraries/"..file)),env)()
    end
    local ace=env.LibStub("AceDB-3.0")
    env.LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(addon.SettingsOptions.args.profiles, "Profiles")
    local storage={
        profiles={Default={minimap={hide=true, minimapPos=37}}},
        char={["Miner - Forever"]={minimap={size=17, tracking={mining=false}}, routeMapID=7}},
        global={nodes={mining={{object=1731}}}},
    }
    local db=ace:New(storage,nil,true)
    addon.MigrateProfileSettings(db)
    db:RegisterDefaults(addon.configsDefaults)
    local migratedName=db:GetCurrentProfile()
    assert(migratedName~="Default" and db.profile.minimap.size==17 and not db.char.minimap.tracking.mining)
    assert(db.char.professionTrackingManual and db.profile.minimapIcon.hide and db.profile.minimapIcon.minimapPos==37)
    assert(db.char.routeMapID==7 and not db.char.minimap.size and not db.profile.minimap.tracking
        and db.global.nodes.mining[1].object==1731)
    addon.MigrateProfileSettings(db)
    assert(db:GetCurrentProfile()==migratedName, "migration must be idempotent")
    db.char.ignore[1731] = true
    db:SetProfile("New")
    assert(db.char.ignore[1731] and not db.char.minimap.tracking.mining)
    assert(db.profile.minimap.size==12 and not db.profile.minimapIcon.hide, "new profile must use defaults")
    db.char.minimap.tracking.mining = true
    db:CopyProfile(migratedName)
    assert(db.char.ignore[1731] and db.char.minimap.tracking.mining and not db.profile.minimap.tracking)
    assert(db.profile.minimap.size==17 and db.profile.minimapIcon.hide, "copy must include gathered preferences")
    db:ResetProfile()
    assert(db.char.ignore[1731] and db.char.minimap.tracking.mining and db.char.professionTrackingManual)
    assert(db.profile.minimap.size==12 and db.char.routeMapID==7 and db.global.nodes.mining[1].object==1731)
    db:SetProfile(migratedName)
    assert(db.profile.minimap.size==17 and db.char.minimap.tracking.mining)

    local earlier = {
        profileKeys = { ["Miner - Forever"]="Shared", Herbalist="Shared" },
        profiles = { Shared = {
            minimap = { size=19, tracking={ mining=false } },
            worldmap = { tracking={ herbalism=false } }, hud = { tracking={ fishing=false } },
            ignore = { [1731]=true }, professionTrackingManual = true,
        }},
        char = { ["Miner - Forever"] = {
            profileSettingsMigrated=true, minimap={ tracking={ mining=true } },
        }},
    }
    db=ace:New(earlier,nil,true)
    addon.MigrateProfileSettings(db)
    db:RegisterDefaults(addon.configsDefaults)
    assert(db:GetCurrentProfile()=="Shared" and db.profile.minimap.size==19 and not db.profile.minimap.tracking)
    assert(not db.profile.ignore and not db.profile.professionTrackingManual)
    assert(db.char.minimap.tracking.mining and not db.char.worldmap.tracking.herbalism
        and not db.char.hud.tracking.fishing and db.char.ignore[1731] and db.char.professionTrackingManual)
    assert(earlier.char.Herbalist.minimap.tracking.mining==false and earlier.char.Herbalist.ignore[1731])
    db.char.ignore[1731] = false
    assert(earlier.char.Herbalist.ignore[1731], "migrated character filters must not share a table")
end

local kinds = { "mining", "herbalism", "containers", "fishing" }
local objects = { 1731, 1617, 106319, 180750 }
addon.predefined = {}
for i, kind in ipairs(kinds) do
    -- Other UI addons can raise the minimap; pins must still pass clicks through.
    if i == 3 then Minimap:SetFrameStrata("TOOLTIP") end
    -- Start with every category disabled: enabling it must load and draw immediately.
    GatherLite.db.char.minimap.tracking[kind] = false
    GatherLite.db.char.worldmap.tracking[kind] = false
    addon.predefined[objects[i]] = { [1429] = { 0.6, 0.6 } }
end
GatherLite:Load()
local function tick(elapsed)
    for _, f in ipairs(frames) do
        if f.scripts.OnUpdate then f.scripts.OnUpdate(f, elapsed or 0.1) end
    end
end
WorldMapFrame:Show()
tick()
local worldButton = GatherLiteWorldmapButton
assert(worldButton:GetFrameLevel() + 500 < 10000, "the world map menu needs frame-level headroom for its text")
assert(worldButton.point[2] == mapPin and worldButton.point[3] == "BOTTOMLEFT", "standalone button must follow the map pin")
local questie, rareScanner = makeFrame(WorldMapFrame), makeFrame(WorldMapFrame)
libraries["Krowi_WorldMapButtons-1.4"] = { IsForever = true, Buttons = { questie, rareScanner } }
tick(.16)
assert(worldButton.point[2] == rareScanner, "button must follow other addons that join the map stack after login")
rareScanner:Hide()
tick(.16)
assert(worldButton.point[2] == questie, "hidden peers must leave no gap")
questie:Hide()
tick(.16)
assert(worldButton.point[2] == mapPin, "return to the native pin when all peers are hidden")
local minimapDrawer = makeFrame(UIParent)
local groupedMinimapButton = makeFrame(minimapDrawer)
local function click(target, index)
    menu = {}
    if target == "minimap" then
        minimapDrawer:Show()
        minimapButton.OnClick(groupedMinimapButton, "LeftButton")
        -- Minimap drawers can hide on mouse-down, before the menu receives mouse-up.
        minimapDrawer:Hide()
        local owner = menuOwner
        while owner do
            assert(owner:IsShown(), "minimap menu closes before the checkbox receives the click")
            owner = owner:GetParent()
        end
    else
        GatherLiteWorldmapButton.scripts.OnClick(GatherLiteWorldmapButton, "RightButton")
        assert(menuOwner == GatherLiteWorldmapButton, "worldmap menu lost its button owner")
    end
    local button = menu[index + 1]
    assert(button and button.func, "missing menu callback")
    local checked = button.checked()
    -- Pins have no click action. Even a raised minimap or a recycled pin must
    -- let clicks reach the menu while keeping mouse motion for hover tooltips.
    for _, registry in pairs({ pins.worldmap, pins.minimap }) do
        for frame in pairs(registry) do
            assert(frame.clickEnabled == false, "gathering pin can intercept menu clicks")
            assert(frame.motionEnabled == frame.texture:IsShown(), "only visible gathering pins should receive hover")
        end
    end
    button.func(button)
    assert(button.checked() == not checked, "open menu checkmark did not follow tracking state")
end
local function count(target, object)
    local n = 0
    for frame in pairs(pins[target]) do
        if frame.node.object == object then n = n + 1 end
    end
    return n
end
assert(options.args.minimap.args.autoGatherTracking == nil, "native tracking automation must be unavailable")
for i, kind in ipairs(kinds) do
    click("worldmap", i)
    assert(GatherLite:GetNodeTracking("worldmap", kind), "menu failed to enable " .. kind)
    assert(count("worldmap", objects[i]) == 1, "enabling lazy " .. kind .. " must draw a worldmap pin immediately")
    assert(not GatherLite:GetNodeTracking("minimap", kind), "worldmap menu changed minimap preference")
    click("minimap", i)
    assert(count("minimap", objects[i]) == 1, "minimap menu did not draw " .. kind)
    click("worldmap", i)
    assert(count("worldmap", objects[i]) == 0, "worldmap pin remained after disabling " .. kind)
    assert(count("minimap", objects[i]) == 1, "worldmap toggle removed minimap pin")
    click("minimap", i)
    assert(count("minimap", objects[i]) == 0, "minimap pin remained after disabling " .. kind)
    tick()
    assert(count("minimap", objects[i]) == 0 and count("worldmap", objects[i]) == 0,
        "background update recreated a disabled pin")
    local option = options.args.minimap.args.tracking.args[kind]
    assert(option.get() == false, "settings panel is out of sync with map menu: " .. kind)
    option.set(nil, true)
    assert(GatherLite:GetNodeTracking("minimap", kind), "settings toggle writes an unused tracking flag")
    local worldOption = options.args.worldmap.args.tracking.args[kind]
    assert(worldOption.get() == false, "worldmap settings read the wrong tracking state")
    worldOption.set(nil, true)
    assert(count("worldmap", objects[i]) == 1, "worldmap settings did not redraw " .. kind)
    option.set(nil, false)
    assert(count("minimap", objects[i]) == 0 and count("worldmap", objects[i]) == 1,
        "per-map settings are not independent")
    worldOption.set(nil, false)
end
-- Moving toward a known location leaves an outline; moving away restores its icon.
local circle = "Interface\\AddOns\\GatherLite\\icons\\track_circle"
local distanceOption = options.args.minimap.args.sliders.args.iconRange
local circlesOption = options.args.minimap.args.nearbyCircles
local hideOption = options.args.minimap.args.hideNearbyNodes
assert(not circlesOption.get(), "nearby circles must default to disabled")
assert(not hideOption.get(), "nearby pins must be visible by default")
circlesOption.set(nil, true)
hideOption.set(nil, false)
for i, kind in ipairs(kinds) do
    playerX, playerY = 600, 580
    click("minimap", i)
    local pin = assert(next(pins.minimap), "nearby pin was not created")
    local icon = GatherLite:GetNodeObject(objects[i]).icon
    assert(pin:IsShown() and pin.texture.texturePath == circle, "nearby " .. kind .. " must start as a visible circle")
    assert(pin.scripts.OnEnter and pin.motionEnabled, "circle lost its tooltip")
    assert(circlesOption.get(), "nearby circles must remain enabled during the behavior test")
    circlesOption.set(nil, false)
    tick(1.1)
    pin = assert(next(pins.minimap))
    assert(pin:IsShown() and pin.texture.texturePath == icon, "disabled circles must preserve nearby resource icons")
    assert(not hideOption.get(), "nearby hiding must be disabled before testing it")
    hideOption.set(nil, true)
    tick(5.1)
    assert(count("minimap", objects[i]) == 0, "hidden nearby nodes must not have interactive pins")
    distanceOption.set(nil, 10)
    assert(next(pins.minimap), "reducing hide distance must immediately restore a node outside it")
    distanceOption.set(nil, 70)
    assert(count("minimap", objects[i]) == 0, "increasing hide distance must immediately hide nearby nodes")
    playerY = 530
    tick(5.1)
    pin = assert(next(pins.minimap), "moving away must restore hidden nodes")
    assert(pin.texture.texturePath == icon, "restored node must use resource icon")
    playerY = 600
    tick(1.1)
    assert(count("minimap", objects[i]) == 0, "approaching node must hide an existing pin")
    distanceOption.set(nil, 0)
    tick(5.1)
    assert(next(pins.minimap), "zero nearby distance must preserve nodes")
    distanceOption.set(nil, 70)
    circlesOption.set(nil, true)
    tick(1.1)
    assert(next(pins.minimap) and not hideOption.get(), "enabling circles must disable nearby hiding")
    hideOption.set(nil, false)
    tick(1.1)
    pin = assert(next(pins.minimap))
    assert(pin.texture.texturePath == circle, "re-enabling circles must refresh nearby pins")

    playerY = 530 -- Exactly at the configured 70-yard boundary.
    tick(1.1)
    assert(pins.minimap[pin] and pin.texture.texturePath == icon, "moving away must restore the same pin's icon")
    playerY = 600
    tick(1.1)
    assert(pin:IsShown() and pin.texture.texturePath == circle, "standing on a location must retain its circle")

    pin:Hide() -- Simulate visibility controlled by HereBeDragons (e.g. clipping).
    playerY = 500
    tick(1.1)
    assert(not pin:IsShown() and pin.texture.texturePath == icon, "distance updates must respect map visibility")
    pin:Show()
    playerY = 600
    distanceOption.set(nil, 0)
    tick()
    assert(pin.texture.texturePath == icon, "zero circle distance must preserve normal icons")
    distanceOption.set(nil, 70)
    tick(1.1)
    assert(pin.texture.texturePath == circle, "changing circle distance must update existing pins")

    click("minimap", i)
    assert(count("minimap", objects[i]) == 0, "tracking toggle failed to remove a circle")
    click("worldmap", i)
    local worldPin = assert(next(pins.worldmap))
    assert(worldPin.texture.texturePath == icon, "recycled circle leaked into the world map")
    click("worldmap", i)
    playerX, playerY = 500, 500
    click("minimap", i)
    local reused = assert(next(pins.minimap))
    assert(reused.texture.texturePath == icon, "recycled minimap pin retained its circle")
    click("minimap", i)
end
assert(GatherLite.db.char.professionTrackingManual, "manual filter changes must disable profession automation")

-- Nearby alternatives and mixed gathering categories must not stack rings.
playerX,playerY=600,600
circlesOption.set(nil,true)
for i=1,#kinds do click("minimap",i) end
tick(1.1)
local visible,hidden=0,0
for frame in pairs(pins.minimap) do
    assert(frame.texture.texturePath==circle,"a newly loaded nearby pin flashed its resource icon")
    if frame.texture:IsShown() then
        visible=visible+1
        assert(#frame.clusterNodes==3,"representative tooltip lost suppressed resource types")
    else
        hidden=hidden+1
        assert(not frame.motionEnabled,"suppressed marker retained hover interception")
    end
end
assert(visible==1 and hidden==3,"coincident circles across categories must share one visible marker")
-- Existing saved settings can contain both flags: explicit hiding wins.
GatherLite.db.profile.minimap.hideNearbyNodes=true
tick(1.1)
assert(not next(pins.minimap),"old conflicting settings must not cover live tracking dots")
GatherLite.db.profile.minimap.hideNearbyNodes=false
for i=1,#kinds do click("minimap",i) end
playerX,playerY=500,500

local settingsOpened = 0
GatherLite.ShowSettings = function() settingsOpened = settingsOpened + 1 end
minimapButton.OnClick(Minimap, "RightButton")
local toggled = 0
GatherLite.modules.worldMapSidebar = { Toggle = function() toggled = toggled + 1 end }
worldButton.scripts.OnClick(worldButton, "LeftButton")
GatherLite.modules.worldMapSidebar = nil
assert(closedMenus == 1 and settingsOpened == 1 and toggled == 1,
    "minimap right-click opens settings and world map left-click toggles the pane")
addon.Window = { ShowSettings = function() settingsOpened = settingsOpened + 1 end }
menu = {}
worldButton.scripts.OnClick(worldButton, "RightButton")
assert(menu[6].divider and menu[7].text == "Open GatherLite settings")
menu[7].func()
assert(settingsOpened == 2, "the map tracking menu shortcut must open the settings tab")
addon.Window = nil

-- Gamepad UI: a Blizzard menu opened from addon code taints the controller
-- binding stack, so the tracking shortcuts open the addon-owned settings page.
local shownCategories = {}
addon.Window = { ShowSettings = function(_, category) shownCategories[#shownCategories + 1] = category; return true end }
InputUtil = { IsGamepadUIEnabled = function() return true end }
menu, menuOwner = {}, nil
local closedBefore = closedMenus
worldButton.scripts.OnClick(worldButton, "RightButton")
minimapButton.OnClick(groupedMinimapButton, "LeftButton")
minimapButton.OnClick(Minimap, "RightButton")
assert(menuOwner == nil and #menu == 0, "the gamepad UI must not open a Blizzard menu from addon code")
assert(closedMenus == closedBefore, "the gamepad UI must not call Blizzard's menu manager from addon code")
assert(shownCategories[1] == "worldmap" and shownCategories[2] == "minimap" and #shownCategories == 2,
    "the tracking shortcuts must open the matching settings category")
-- A client without the function, or another input style, keeps the native menu.
InputUtil = { IsGamepadUIEnabled = function() return false end }
worldButton.scripts.OnClick(worldButton, "RightButton")
assert(menuOwner == worldButton, "the mouse and keyboard UI keeps the native tracking menu")
InputUtil = {}
menuOwner = nil
worldButton.scripts.OnClick(worldButton, "RightButton")
assert(menuOwner == worldButton, "a client without InputUtil.IsGamepadUIEnabled keeps the native tracking menu")
InputUtil, addon.Window = nil, nil
print("Tracking integration passed: all four categories, both maps, lazy loading, settings and nearby circles")

-- Icon checks must obey their timer and must not copy the frame registry.
click("minimap", 1)
local vectorCalls = 0
local hbd = libraries["HereBeDragons-2.0"]
local originalVector = hbd.GetWorldVector
hbd.GetWorldVector = function(...)
    vectorCalls = vectorCalls + 1
    return originalVector(...)
end
local originalFilter = GatherLite.Filter
GatherLite.Filter = function() error("minimap allocated a frame-list copy") end
for i = 1, 30 do tick(1 / 60) end
assert(vectorCalls == 0, "icon distances calculated before the one-second timer")
tick(0.6)
assert(vectorCalls > 0, "icon timer failed to run")
GatherLite.Filter = originalFilter
hbd.GetWorldVector = originalVector
click("minimap", 1)

-- One update must remove all stale pins, even after a cross-instance move.
for i = 1, #kinds do click("minimap", i) end
local pool = libraries.GatherLiteFrame
local stale = {}
for pin in pairs(pins.minimap) do stale[#stale + 1] = pin; pin.node.instance = 1 end
tick(1.1)
assert(next(pins.minimap) == nil, "stale minimap pins survived the cleanup pass")
local unused = #pool.unusedFrames
for _, pin in ipairs(stale) do
    assert(pin.node == nil and pin.object == nil, "recycled frame retained node metadata")
    assert(pin.scripts.OnEnter == nil and pin.scripts.OnLeave == nil, "recycled frame retained hover handlers")
    pin:Unload()
end
assert(#pool.unusedFrames == unused, "double unload inserted duplicate free frames")
for _, kind in ipairs(kinds) do
    for _, node in ipairs(addon.nodes[kind]) do node.instance = 0 end
end
for i = 1, #kinds do click("minimap", i) end

-- Compare spatial queries against a brute-force search, including map edges.
local points = {}
for _, pos in ipairs({ {0, 0}, {1, 1}, {0.0064, 0.0064}, {0.0066, 0.0066}, {0.5, 0.5} }) do
    points[#points + 1] = { type = "mining", object = 1731, mapID = 999,
        posX = pos[1], posY = pos[2], instance = 0 }
end
GatherLite:LoadTable("mining", points)
assert(#GatherLite:GetNodesForMap("mining", 998) == 0, "empty map returned other zones")
assert(#GatherLite:GetNodesForMapRect("mining", 999, 0, 1, 0, 1) == #points)
for _, pos in ipairs({ {0, 0}, {1, 1}, {0.0065, 0.0065}, {0.5, 0.5} }) do
    local candidates = GatherLite:GetNearbyNodes("mining", 999, 0, pos[1], pos[2], 10)
    local seen = {}
    for _, node in ipairs(candidates) do
        assert(node.mapID == 999 and not seen[node], "spatial query returned a duplicate or wrong map")
        seen[node] = true
    end
    for _, node in ipairs(points) do
        local distance = math.sqrt((node.posX-pos[1])^2 + (node.posY-pos[2])^2) * 1000
        if distance <= 10 then assert(seen[node], "spatial query missed an edge node") end
    end
    assert(GatherLite:findExistingLocalNode("mining", 999, pos[1], pos[2], 1731), "node lookup missed neighboring cell")
end
assert(#GatherLite:GetNearbyNodes("mining", 999, 0, 0.5, 0.5, 2000) == #points)
local rect = GatherLite:GetNodesForMapRect("mining", 999, 0.01, 0, 0.01, 0)
assert(#rect == 3, "reversed map rectangle returned incorrect points")
print("Memory regressions passed: timer cadence, frame recycling, stale pins and spatial queries")

-- Zone hover uses the world-map filters, groups aliases, and caches the hovered zone.
do
    local source = GatherLite.modules.worldmap
    local originalNodes, originalIgnored = GatherLite.GetNodesForMap, GatherLite.IsIgnored
    local originalTracking = GatherLite.db.char.worldmap.tracking
    local originalPredefined = GatherLite.db.global.usePredefined
    local ignored, scans = {}, 0
    local testNodes = {
        mining = {
            { object = 1731, type = "mining", mapID = 1429 },
            { object = 2055, type = "mining", mapID = 1429 },
            { object = 1732, type = "mining", mapID = 1429, predefined = true },
        },
        herbalism = { { object = 1617, type = "herbalism", mapID = 1429 } },
    }
    GatherLite.GetNodesForMap = function(_, kind, mapID)
        scans = scans + 1
        return mapID == 1429 and (testNodes[kind] or {}) or {}
    end
    GatherLite.IsIgnored = function(_, id) return ignored[id] end
    GatherLite.db.profile.worldmap.enabled = true
    GatherLite.db.profile.worldmap.zoneTooltip = true
    GatherLite.db.char.worldmap.tracking = { mining = true, herbalism = false, containers = false, fishing = false }
    GatherLite.db.global.usePredefined = true
    assert(#source.GetZoneNodes(1429) == 2, "zone summary duplicated aliases or included disabled herbs")
    GatherLite.db.global.usePredefined = false
    assert(#source.GetZoneNodes(1429) == 1, "zone summary ignored predefined toggle")
    ignored[1731], ignored[2055] = true, true
    assert(#source.GetZoneNodes(1429) == 0, "zone summary included ignored objects")
    assert(#source.GetZoneNodes(1431) == 0, "zone summary leaked another map")
    ignored = {}
    local originalCreate = CreateFrame
    CreateFrame = function(kind, name, parent, template)
        local frame = originalCreate(kind, name, parent, template)
        local originalTexture = frame.CreateTexture
        frame.CreateTexture = function(self)
            local texture = originalTexture(self)
            texture.SetColorTexture = noop
            return texture
        end
        frame.CreateFontString = function()
            local label = makeFrame()
            label.SetText = function(self, text) self.text = text end
            label.SetJustifyH, label.SetWordWrap, label.ClearAllPoints = noop, noop, noop
            return label
        end
        frame.EnableMouse = function(self, enabled) self.mouseEnabled = enabled end
        return frame
    end
    WorldMapFrame:Show()
    local focus, zone = true, { mapID = 1429, mapType = 3, name = "Elwynn Forest" }
    WorldMapFrame.IsCanvasMouseFocus = function() return focus end
    WorldMapFrame.GetNormalizedCursorPosition = function() return 0.5, 0.5 end
    local originalMapID = WorldMapFrame.mapID
    WorldMapFrame.mapID = 1415
    local originalMapInfo = C_Map.GetMapInfo
    C_Map.GetMapInfo = function(id) return { mapType = id == 1415 and 2 or 3 } end
    C_Map.GetMapInfoAtPosition = function() return zone end
    source.UpdateZoneList(0.2)
    assert(GatherLiteZoneList:IsShown() and GatherLiteZoneList.title.text == "Elwynn Forest")
    assert(GatherLiteZoneList:GetParent() == (WorldMapFrame.ScrollContainer or WorldMapFrame), "zone list must be inside map")
    assert(GatherLiteZoneList.mouseEnabled == false, "zone list must not block map interactions")
    assert(GatherLiteZoneList.rows[1].text:find("Copper Vein", 1, true), "inline list missed node name")
    local previousScans = scans
    source.UpdateZoneList(0.2)
    assert(scans == previousScans, "unchanged hover rescanned zone nodes")
    WorldMapFrame.mapID = 1431 -- A zone map hovering a different, neighboring zone.
    source.UpdateZoneList(0.2)
    assert(not GatherLiteZoneList:IsShown(), "zone map showed the neighboring zone list")
    assert(scans == previousScans, "zone map scanned neighboring zone nodes")
    WorldMapFrame.mapID = 1415
    source.UpdateZoneList(0.2)
    assert(GatherLiteZoneList:IsShown(), "returning to continent did not restore list")
    focus = false
    source.UpdateZoneList(0.2)
    assert(not GatherLiteZoneList:IsShown(), "tooltip hid pin or menu hover")
    focus = true
    zone = nil
    source.UpdateZoneList(0.2)
    assert(not GatherLiteZoneList:IsShown(), "tooltip remained over ocean")
    zone = { mapID = 1429, mapType = 3, name = "Elwynn Forest" }
    source.UpdateZoneList(0.2)
    GatherLite.db.profile.worldmap.zoneTooltip = false
    source.UpdateZoneList(0.01)
    assert(not GatherLiteZoneList:IsShown(), "disabled zone tooltip remained visible")
    GatherLite.db.profile.worldmap.zoneTooltip = true
    source.UpdateZoneList(0.2)
    WorldMapFrame:Hide()
    source.UpdateZoneList(0.01)
    assert(not GatherLiteZoneList:IsShown(), "closed world map left zone tooltip visible")
    CreateFrame = originalCreate
    GatherLite.GetNodesForMap, GatherLite.IsIgnored = originalNodes, originalIgnored
    GatherLite.db.char.worldmap.tracking = originalTracking
    GatherLite.db.global.usePredefined = originalPredefined
    WorldMapFrame.mapID = originalMapID
    WorldMapFrame.IsCanvasMouseFocus = nil
    C_Map.GetMapInfoAtPosition = nil
    C_Map.GetMapInfo = originalMapInfo
end
print("Zone hover checks passed: tracking, aliases, predefined data, ignored nodes, caching and tooltip lifecycle")

-- Optional allocation benchmark; collection is paused only in this test runtime.
if arg and arg[1] == "--benchmark" then
    -- Full database and hot-path allocation benchmark with mocked game APIs.
    WorldMapFrame:Hide()
    GatherLite.db.global.usePredefined = true
    for _, kind in ipairs(kinds) do
        GatherLite.db.char.minimap.tracking[kind] = true
        GatherLite.db.char.worldmap.tracking[kind] = true
    end
    assert(loadfile("plugins/database/data/forever.lua"))("GatherLite", addon)
    GatherLite:Trigger("settings:update")
    for i = 1, 300 do tick() end
    collectgarbage("collect")
    print(string.format("Full database retained: %.1f KiB", collectgarbage("count")))
    collectgarbage("stop")
    local before = collectgarbage("count")
    local start = os.clock()
    for i = 1, 600 do tick() end
    print(string.format("600 frames: %.1f KiB allocated, %.3f seconds", collectgarbage("count") - before, os.clock() - start))
    collectgarbage("restart")
    collectgarbage("collect")
    collectgarbage("stop")
    before, start = collectgarbage("count"), os.clock()
    for i = 1, 10 do
        for _, kind in ipairs(kinds) do GatherLite:GetNodesForMapRect(kind, 1429, 0, 1, 0, 1) end
    end
    print(string.format("10 full-map queries: %.1f KiB allocated, %.3f seconds", collectgarbage("count") - before, os.clock() - start))
    collectgarbage("restart")
end
-- A neighbor's overlapping map area must contribute pins to the selected zone.
do
    local hbd = libraries["HereBeDragons-2.0"]
    function hbd:GetWorldCoordinatesFromZone(x, y, map)
        return x * 1000 + (map == 1431 and 500 or 0), y * 1000, 0
    end
    function hbd:GetZoneCoordinatesFromWorldInstance(x, y, instance, map, allow)
        if instance ~= 0 then return end
        x, y = (x - (map == 1431 and 500 or 0)) / 1000, y / 1000
        if allow or (x >= 0 and x <= 1 and y >= 0 and y <= 1) then return x, y end
    end
    function pins:AddWorldMapIconMap(_, frame, map, x, y)
        pinAdds=pinAdds+1
        self.worldmap[frame] = { map = map, x = x, y = y }; frame:Show()
    end
    local visible = { type = "mining", mapID = 1431, posX = .2, posY = .4, object = 1731, instance = 0 }
    local outside = { type = "mining", mapID = 1431, posX = .8, posY = .4, object = 1731, instance = 0 }
    GatherLite:LoadTable("mining", { visible, outside })
    GatherLite.db.profile.worldmap.enabled = true
    GatherLite.db.profile.worldmap.zoneTooltip = false
    GatherLite.db.char.worldmap.tracking.mining = true
    local view = { 0, .2, .3, .5 } -- Neighbor starts outside the viewport.
    WorldMapFrame.ScrollContainer = { GetNormalizedRect = function() return unpack(view) end }
    local queries = 0
    local originalQuery = GatherLite.GetWorldMapNodesForRect
    GatherLite.GetWorldMapNodesForRect = function(self, ...)
        queries = queries + 1
        return originalQuery(self, ...)
    end
    WorldMapFrame.mapID = 1429
    WorldMapFrame:Show()
    tick(.2)
    GatherLite.modules.worldmap.reset()
    local function find(node)
        for frame, coords in pairs(pins.worldmap) do if frame.node == node then return frame, coords end end
    end
    assert(GatherLite.db.profile.worldmap.neighbors==false,"neighbor pins must default off")
    assert(not find(visible),"default must exclude neighbor pins")
    GatherLite.db.profile.worldmap.neighbors=true
    GatherLite:Trigger("settings:update")
    local frame, coords = find(visible)
    assert(frame and coords.map == 1429 and math.abs(coords.x - .7) < .000001 and coords.y == .4,
        "neighbor must be registered on viewed map with projected coordinates")
    assert(visible.mapID == 1431 and visible.posX == .2 and frame.node == visible,
        "projection must preserve source data for tooltips")
    assert(not find(outside), "neighbor outside selected map must not render")
    GatherLite.db.profile.worldmap.neighbors=false
    GatherLite:Trigger("settings:update")
    assert(not find(visible),"turning neighbors off must remove existing pins")
    GatherLite.db.profile.worldmap.neighbors=true
    GatherLite:Trigger("settings:update")
    frame=find(visible)
    local loadedQueries = queries
    view = { .6, .8, .3, .5 }; tick(.2)
    assert(find(visible) == frame and visible.loadedWorldmap, "pan must retain the existing neighbor pin")
    view = { 0, 1, 0, 1 }; tick(.2)
    assert(find(visible) == frame and queries == loadedQueries, "pan/zoom must not requery or recreate pins")
    GatherLite.db.char.worldmap.tracking.mining = false
    GatherLite:Trigger("settings:update")
    assert(not find(visible), "neighbor pins must respect tracking")
    GatherLite.db.char.worldmap.tracking.mining = true
    GatherLite:Trigger("settings:update")
    assert(find(visible))
    -- Even a node explicitly stored under an overview ID must stay hidden.
    GatherLite:LoadTable("mining", { { type = "mining", mapID = 1415, posX = .5, posY = .5, object = 1731, instance = 0 } })
    WorldMapFrame.mapID = 1415; tick(.2)
    assert(next(pins.worldmap) == nil, "continent overview must not display any node pins")
    WorldMapFrame.mapID = 947; tick(.2)
    assert(next(pins.worldmap) == nil, "world overview must not display any node pins")
    WorldMapFrame.mapID = 1429; tick(.2)
    assert(find(visible), "return to zone must restore visible neighbor")
    WorldMapFrame:Hide(); tick(.2)
    assert(not find(visible) and not visible.loadedWorldmap, "closing map must unload neighbor")
    GatherLite.GetWorldMapNodesForRect = originalQuery
end
print("World-map neighbors passed: projected pins, source identity, no pan/zoom reload, tracking, map changes and cleanup")

-- Gathering must refresh open maps without relying on reference pins, movement,
-- reopening the map, or the next five-second minimap scan.
do
    date = os.date
    GatherLite.db.global.usePredefined = false
    GatherLite.db.profile.minimap.hideNearbyNodes = false
    GatherLite.db.profile.worldmap.neighbors = false
    playerX, playerY = 500, 500
    WorldMapFrame.mapID = 1429
    WorldMapFrame:Show()
    for _, kind in ipairs(kinds) do
        GatherLite.db.char.minimap.tracking[kind] = true
        GatherLite.db.char.worldmap.tracking[kind] = true
    end
    GatherLite:Trigger("settings:update")
    tick(.1)
    for step = 1, 10 do tick(.01) end
    tick(1.1) -- Finish discovery and retire stale pins before measuring a gather.
    for i, kind in ipairs(kinds) do
        local saved = #GatherLite.db.global.nodes[kind]
        local mini, world = count("minimap", objects[i]), count("worldmap", objects[i])
        local cached = #GatherLite:GetNodesForMapInstance(kind, 1429, 0)
        local added, removed = pinAdds, pinRemoves
        local rectQuery, nearbyQuery = GatherLite.GetNodesForMapRect, GatherLite.GetNearbyZoneNodes
        GatherLite.GetNodesForMapRect = function() error("gather rescanned world-map nodes") end
        GatherLite.GetNearbyZoneNodes = function() error("gather restarted minimap discovery") end
        GatherLite:RegisterNode(kind, objects[i], 1429, .5, .5)
        GatherLite.GetNodesForMapRect, GatherLite.GetNearbyZoneNodes = rectQuery, nearbyQuery
        assert(pinAdds == added + 2 and pinRemoves == removed,
            string.format("gather %s must add only its two pins without rebuilding existing pins (adds=%d, removes=%d)",
                kind, pinAdds-added, pinRemoves-removed))
        assert(#GatherLite.db.global.nodes[kind] == saved + 1, "new personal node was not saved")
        assert(count("worldmap", objects[i]) == world + 1, "registration must refresh the open world map")
        assert(#GatherLite:GetNodesForMapInstance(kind, 1429, 0) == cached + 1,
            "new personal node was omitted from the map/instance index")
        -- Allow coroutine workers to finish without triggering their periodic scan.
        for step = 1, 10 do tick(.01) end
        assert(count("minimap", objects[i]) == mini + 1, "registration must refresh the minimap immediately")
        GatherLite:RegisterNode(kind, objects[i], 1429, .5, .5)
        assert(#GatherLite.db.global.nodes[kind] == saved + 1, "repeat gather duplicated personal history")
        assert(count("worldmap", objects[i]) == world + 1, "repeat gather duplicated the world map pin")
    end

    -- Promotion of an already visible reference node keeps its runtime identity.
    GatherLite.db.global.usePredefined = true
    GatherLite:Trigger("settings:update")
    local reference = GatherLite:findExistingLocalNode("herbalism", 1429, .6, .6, objects[2])
    for step = 1, 600 do
        if reference.loaded and reference.loadedWorldmap then break end
        tick(0)
    end
    assert(reference.loaded and reference.loadedWorldmap, "reference pin must be visible before promotion")
    local added, removed = pinAdds, pinRemoves
    GatherLite:RegisterNode("herbalism", objects[2], 1429, .6, .6)
    assert(reference.predefined == false and reference.loaded and reference.loadedWorldmap,
        "promotion lost the indexed runtime node")
    assert(pinAdds == added and pinRemoves == removed, "visible reference promotion duplicated or rebuilt pins")

    -- Turning reference data back on/off must retain the same personal pins.
    GatherLite.db.global.usePredefined = true
    GatherLite:Trigger("settings:update")
    GatherLite.db.global.usePredefined = false
    GatherLite:Trigger("settings:update")
    for i, kind in ipairs(kinds) do
        assert(count("worldmap", objects[i]) >= 1, "database toggle hid personal " .. kind)
    end

    -- A gather at an already loaded reference location becomes personal history
    -- even while reference pins are hidden; it must appear without a duplicate.
    local before = count("worldmap", objects[1])
    GatherLite:RegisterNode("mining", objects[1], 1429, .6, .6)
    assert(count("worldmap", objects[1]) == before + 1, "hidden reference node was not promoted to a personal pin")

    -- Tracking filters affect visibility, never whether a successful gather saves.
    WorldMapFrame:Hide(); tick(.01)
    GatherLite.db.char.minimap.tracking.mining = false
    GatherLite:Trigger("settings:update")
    GatherLite:RegisterNode("mining", objects[1], 1429, .55, .55)
    assert(GatherLite:FindExistingNode("mining", 1429, .55, .55, objects[1]), "disabled map filter blocked personal history")
    assert(count("minimap", objects[1]) == 0 and next(pins.worldmap) == nil,
        "registration bypassed a map filter or reopened a closed map")
    WorldMapFrame:Show(); tick(.01)
    assert(count("worldmap", objects[1]) == before + 2, "reopening map lost nodes gathered while closed")
end
print("Personal node registration passed: predefined disabled, immediate map refresh and repeat gathers")
print("Gather refresh work: two pin additions, zero removals, zero map/discovery rescans; visible promotion reuses both pins")

do
    WorldMapFrame:Hide()
    tick(.01)
    local hbd = libraries["HereBeDragons-2.0"]
    local originalWorld, originalZone = hbd.GetPlayerWorldPosition, hbd.GetPlayerZonePosition
    local originalProjection = hbd.GetWorldCoordinatesFromZone
    local hasPosition, mapID = false, 1429
    hbd.GetPlayerWorldPosition = function()
        if hasPosition then return mapID == 998 and 1010 or 500, 500, 0 end
    end
    hbd.GetPlayerZonePosition = function(_, allowOutOfBounds)
        if not hasPosition then return end
        if mapID == 998 then
            if allowOutOfBounds then return 1.01, .5, mapID end
        else
            return .5, .5, mapID
        end
    end
    GatherLite.db.char.minimap.tracking.mining = true
    GatherLite:Trigger("settings:update")
    tick(.1)
    assert(count("minimap", 1731) == 0, "no pins should be discovered without a position")

    hasPosition = true
    tick(1.1)
    assert(count("minimap", 1731) > 0, "first position should trigger discovery before the five-second scan")

    local destination = { type = "mining", object = 1731, mapID = 998, posX = .99, posY = .5,
        worldX = 990, worldY = 500, instance = 0 }
    GatherLite:LoadTable("mining", { destination })
    hbd.GetWorldCoordinatesFromZone = function(self, x, y, zone)
        if zone == 998 and x == destination.posX and y == destination.posY then return end
        return originalProjection(self, x, y, zone)
    end
    mapID = 998
    tick(1.1)
    assert(destination.loaded, "discovery should recover at a zone edge and reuse valid cached pin coordinates")
    hbd.GetPlayerWorldPosition, hbd.GetPlayerZonePosition = originalWorld, originalZone
    hbd.GetWorldCoordinatesFromZone = originalProjection
end

-- Exercise the bundled renderer as well as the mock registry used above.
do
    local hasPosition = true
    local instance, width, radius = 0, 140, 100
    local mapID, shape, facing = 1429, "ROUND", 0
    local hbd = libraries["HereBeDragons-2.0"]
    hbd.GetPlayerWorldPosition = function()
        if hasPosition then return 500, 500, instance end
    end
    hbd.GetPlayerZone = function() return mapID end
    hbd.RegisterCallback = noop
    GetCVar = function() return "0" end
    C_Minimap = { GetViewRadius = function() return radius end }
    Minimap.GetZoom = function() return 0 end
    Minimap.GetScale = function() return 1 end
    Minimap.GetWidth = function() return width end
    Minimap.GetHeight = function() return 140 end
    GetMinimapShape = function() return shape end
    GetPlayerFacing = function() return facing end
    WorldMapFrame.GetCanvas = function(self) return self end
    WorldMapFrame.AddDataProvider = noop
    WorldMapFrame.pinPools = {}
    local updateFrame = makeFrame()
    updateFrame.UnregisterAllEvents = noop
    updateFrame.RegisterEvent = noop
    CreateFrame = function() return updateFrame end
    CreateFramePool = function() return {} end
    CreateFromMixins = function() return {} end

    assert(loadfile("scripts/libraries/HereBeDragons/HereBeDragons-Pins-2.0.lua"))()
    local library = LibStub("HereBeDragons-Pins-2.0")
    local function makePin()
        local pin = makeFrame()
        pin.SetParent = function(self, parent) self.parent = parent end
        pin.ClearAllPoints = noop
        pin:Hide()
        return pin
    end
    local pin = makePin()
    library:AddMinimapIconWorld("GatherLite", pin, 0, 575, 500)
    local update = updateFrame.scripts.OnUpdate
    update(updateFrame, .1)
    assert(pin:IsShown(), "registered pin should start visible")

    hasPosition = false
    update(updateFrame, .1)
    assert(not pin:IsShown(), "pin should hide while the player position is unavailable")
    hasPosition = true
    update(updateFrame, 1.1)
    assert(pin:IsShown(), "registered pin should recover without movement or zoom changes")

    local offset = pin.point[4]
    width = width * 2
    update(updateFrame, 1.1)
    assert(pin.point[4] == offset * 2, "resizing the minimap must update stationary pin offsets")

    radius = 80
    update(updateFrame, 1.1)
    assert(not pin:IsShown(), "a smaller radius must clip a pin even at the same zoom")
    radius = 100
    update(updateFrame, 1.1)
    assert(pin:IsShown(), "restoring the radius must show the pin again")

    instance = 1
    update(updateFrame, .1)
    assert(not pin:IsShown(), "an instance change must hide pins even at identical coordinates")
    instance = 0
    update(updateFrame, 1.1)
    assert(pin:IsShown(), "returning to the original instance must restore its pins")

    local zonePin, cornerPin = makePin(), makePin()
    library:AddMinimapIconMap("GatherLite", zonePin, 1429, .55, .5)
    library:AddMinimapIconWorld("GatherLite", cornerPin, 0, 575, 575)
    update(updateFrame, .1)
    assert(zonePin:IsShown() and not cornerPin:IsShown(), "round minimap should clip corner pins")
    mapID = 1431
    update(updateFrame, 1.1)
    assert(not zonePin:IsShown(), "map-scoped pins should hide after a stationary map change")
    shape = "SQUARE"
    update(updateFrame, 1.1)
    assert(cornerPin:IsShown(), "square minimap should show corner pins")
    shape = "ROUND"
    update(updateFrame, 1.1)
    assert(not cornerPin:IsShown(), "returning to round minimap should clip corner pins again")
    mapID = 1429
    update(updateFrame, 1.1)
    assert(zonePin:IsShown(), "returning to the original map should restore map-scoped pins")

    updateFrame.scripts.OnEvent(updateFrame, "CVAR_UPDATE", "rotateMinimap", "1")
    update(updateFrame, .1)
    assert(pin:IsShown())
    facing = nil
    update(updateFrame, .1)
    assert(not pin:IsShown(), "rotating minimap must wait for facing data")
    facing = 0
    update(updateFrame, 1.1)
    assert(pin:IsShown(), "rotating minimap should recover when the same facing returns")
end
print("Minimap pins recover after position loss, geometry changes and instance transitions")
