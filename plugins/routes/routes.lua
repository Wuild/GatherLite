local _, addon = ...
local HBD = LibStub("HereBeDragons-2.0")
local Routes = { status = "Select a resource to explore its known locations." }
GatherLite.plugins.Routes = Routes
addon.Routes = Routes

local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end

-- Combine unloaded compressed data and indexed nodes without changing tracking.
function Routes:Collect(object, checkpoint)
    local maps, seen, ids = {}, {}, {}
    checkpoint = checkpoint or function() end
    for _, id in ipairs(object.id) do ids[id] = true end
    local function add(mapID, u, v)
        checkpoint()
        if not finite(mapID) or not finite(u) or not finite(v) or u < 0 or u > 1 or v < 0 or v > 1 then return end
        local info = C_Map.GetMapInfo(mapID)
        if not info or info.mapType ~= 3 then return end
        local x, y, instance = HBD:GetWorldCoordinatesFromZone(u, v, mapID)
        if not finite(x) or not finite(y) or instance == nil then return end
        seen[mapID] = seen[mapID] or {}
        local key = string.format("%.4f:%.4f", u, v)
        if seen[mapID][key] then return end
        seen[mapID][key] = true
        maps[mapID] = maps[mapID] or {}
        maps[mapID][#maps[mapID] + 1] = { u = u, v = v, x = x, y = y, instance = instance }
    end
    if object.type=="fish" then
        for mapID,coords in pairs(object.maps) do
            local info=C_Map.GetMapInfo(mapID)
            if info and info.mapType==3 then
                maps[mapID]={}
                for i=1,#coords,2 do add(mapID,coords[i],coords[i+1]) end
            end
        end
        return maps
    end
    for _, nodes in pairs(addon.nodes) do
        for _, node in ipairs(nodes) do
            if ids[node.object] and (not node.predefined or GatherLite.db.global.usePredefined) then
                add(node.mapID, node.posX, node.posY)
            else checkpoint() end
        end
    end
    if GatherLite.db.global.usePredefined then
        for id in pairs(ids) do
            for mapID, coords in pairs((addon.predefined or {})[id] or {}) do
                for i = 1, #coords, 2 do add(mapID, coords[i], coords[i + 1]) end
            end
        end
    end
    return maps
end

function Routes:Notify()
    if addon.Window then addon.Window:RefreshRoute() end
end

function Routes:Clear()
    self.worker, self.active, self.progress = nil, nil, nil
    self.byMap, self.bestMapID, self.object = nil, nil, nil
    GatherLite.db.char.routeObject, GatherLite.db.char.routeMapID = nil, nil
    self.status = "Route cleared. Select a resource to create another."
    self:Notify()
end

function Routes:SelectMap(mapID)
    if not self.byMap then return end
    self.active = self.byMap[mapID]
    GatherLite.db.char.routeObject = self.object.id[1]
    GatherLite.db.char.routeMapID = self.active and mapID or nil
    if self.active then
        local route = self.active
        self.status = string.format("%s%s | %d stops | %.1f km circuit",
            C_Map.GetMapInfo(mapID).name, mapID == self.bestMapID and " (recommended)" or "",
            #route.points, route.length * 0.0009144)
    else
        self.status = "No circuit in this zone: at least 3 distinct stops are needed. Browse another zone."
    end
    self:Notify()
end

function Routes:Generate(object, preferredMapID)
    if object.type=="fish" then return end
    self:Clear()
    self.status = "Reading known locations..."
    self.progress = 0
    self:Notify()
    self.worker = coroutine.create(function()
        local work = 0
        local function checkpoint()
            work = work + 1
            if work >= 1500 then work = 0; coroutine.yield() end
        end
        local maps, mapIDs = self:Collect(object, checkpoint), {}
        for mapID in pairs(maps) do mapIDs[#mapIDs + 1] = mapID end
        table.sort(mapIDs)
        local best, byMap = nil, {}
        for index, mapID in ipairs(mapIDs) do
            self.status = string.format("Comparing zone %d of %d: %s", index, #mapIDs, C_Map.GetMapInfo(mapID).name)
            self.progress = 5 + 95 * (index - 1) / #mapIDs
            local candidate = addon.RoutePlanner.Build(maps[mapID], checkpoint, function(fraction)
                self.progress = 5 + 95 * (index - 1 + fraction) / #mapIDs
            end)
            if candidate then
                candidate.mapID, candidate.object = mapID, object
                byMap[mapID] = candidate
                if not best or candidate.score > best.score then best = candidate end
            end
        end
        self.byMap, self.object, self.bestMapID = byMap, object, best and best.mapID
        self.progress = nil
        if best then
            self:SelectMap(byMap[preferredMapID] and preferredMapID or best.mapID)
            if addon.Window then addon.Window:ShowRoute(self.active) end
        else
            self.status = "Not enough known locations: a route needs 3 distinct stops in one zone."
            self:Notify()
        end
    end)
end

function Routes:Tick()
    if not self.worker then return end
    local ok, err = coroutine.resume(self.worker)
    if not ok then
        self.worker = nil
        self.progress = nil
        self.status = "Route generation failed. Try another resource."
        self:Notify()
        geterrorhandler()(err)
    elseif coroutine.status(self.worker) == "dead" then
        self.worker = nil
        self:Notify()
    else
        self:Notify()
    end
end

function Routes.setup()
    local frame, restored = CreateFrame("Frame"), false
    frame:SetScript("OnUpdate", function(_, elapsed)
        if not GatherLite:IsLoaded() then return end
        if not restored then
            restored = true
            local object = GatherLite:GetNodeObject(GatherLite.db.char.routeObject)
            if object then Routes:Generate(object, GatherLite.db.char.routeMapID) end
        end
        Routes:Tick()
        Routes:Draw(elapsed)
    end)
    Routes.predefined = GatherLite.db.global.usePredefined
    GatherLite:On("settings:update", function()
        if Routes.predefined ~= GatherLite.db.global.usePredefined then
            Routes.predefined = GatherLite.db.global.usePredefined
            local object, mapID = Routes.object, GatherLite.db.char.routeMapID
            Routes:Clear()
            if object then Routes:Generate(object, mapID) end
        end
    end)
    GatherLite:RegisterChatCommand("gatherroutes", function() GatherLite:ShowSettings() end)
end
