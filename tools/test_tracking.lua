-- Exercise actual menu callbacks, map modules, frame recycling, and lazy loading.
local addon, libraries, frames, menu, options, minimapButton = {}, {}, {}, {}, nil, nil
local function noop() end
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
    function f:SetTexture(path) self.texturePath = path end
    function f:Show() self.shown = true end
    function f:Hide() self.shown = false end
    function f:IsShown() return self.shown end
    f.IsVisible = f.IsShown
    function f:GetParent() return self.parent end
    function f:GetVertexColor() return 1, 1, 1 end
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
C_AddOns = { GetAddOnMetadata = function() return "test" end }
C_Map = { GetBestMapForUnit = function() return 1429 end }
GetTime = function() return 100 end
IsInInstance = function() return false end
tinsert, tremove = table.insert, table.remove
local pins = { minimap = {}, worldmap = {} }
function pins:AddMinimapIconWorld(_, frame) self.minimap[frame] = true; frame:Show() end
function pins:AddWorldMapIconMap(_, frame) self.worldmap[frame] = true; frame:Show() end
function pins:RemoveMinimapIcon(_, frame) self.minimap[frame] = nil end
function pins:RemoveWorldMapIcon(_, frame) self.worldmap[frame] = nil end
libraries["HereBeDragons-Pins-2.0"] = pins
local playerX, playerY = 500, 500
libraries["HereBeDragons-2.0"] = {
    GetPlayerZonePosition = function() return playerX / 1000, playerY / 1000, 1429 end,
    GetPlayerWorldPosition = function() return playerX, playerY, 0 end,
    GetWorldCoordinatesFromZone = function(_, x, y) return x * 1000, y * 1000, 0 end,
    GetWorldVector = function(_, _, x1, y1, x2, y2) return 0, math.sqrt((x2-x1)^2 + (y2-y1)^2) end,
    GetZoneSize = function() return 1000, 1000 end,
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
    { __call = function(_, name) return assert(libraries[name], name) end })
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
        }
        generator(owner, root)
    end,
}
local closedMenus = 0
Menu = { GetManager = function() return { CloseMenus = function() closedMenus = closedMenus + 1 end } end }
for _, path in ipairs({ "scripts/locales/enUS.lua", "scripts/compat.lua", "scripts/config.lua",
    "scripts/nodes.lua", "scripts/frame.lua", "scripts/methods.lua", "scripts/settings.lua", "scripts/main.lua",
    "scripts/modules/worldmap.lua", "scripts/modules/minimap.lua", "plugins/database/database.lua" }) do
    assert(loadfile(path))("GatherLite", addon)
end
GatherLite.db = addon.configsDefaults
GatherLite.debug = noop
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
local function click(target, index)
    menu = {}
    if target == "minimap" then
        minimapButton.OnClick(Minimap, "LeftButton")
        assert(menuOwner == Minimap, "minimap menu lost its button owner")
    else
        GatherLiteWorldmapButton.scripts.OnClick(GatherLiteWorldmapButton, "LeftButton")
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
            assert(frame.motionEnabled == true, "gathering pin lost hover tooltips")
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
for i, kind in ipairs(kinds) do
    playerX, playerY = 600, 580
    click("minimap", i)
    local pin = assert(next(pins.minimap), "nearby pin was not created")
    local icon = GatherLite:GetNodeObject(objects[i]).icon
    assert(pin:IsShown() and pin.texture.texturePath == circle, "nearby " .. kind .. " must start as a visible circle")
    assert(pin.scripts.OnEnter and pin.motionEnabled, "circle lost its tooltip")

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
local settingsOpened = 0
GatherLite.ShowSettings = function() settingsOpened = settingsOpened + 1 end
minimapButton.OnClick(Minimap, "RightButton")
GatherLiteWorldmapButton.scripts.OnClick(GatherLiteWorldmapButton, "RightButton")
assert(closedMenus == 2 and settingsOpened == 2, "right-click must close native menus and open settings")
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
