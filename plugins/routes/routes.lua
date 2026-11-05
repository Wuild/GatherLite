local _, addon = ...
local HBD = LibStub("HereBeDragons-2.0")
local function T(key, ...) return GatherLite:translate(key, ...) end
local Routes = { status = T("window.route.status.select") }
GatherLite.plugins.Routes = Routes
addon.Routes = Routes

local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end

-- A selection uses the existing collector, including its coordinate deduplication.
function Routes:Combine(objects)
    if #objects==0 then return nil end
    if #objects==1 then return objects[1] end
    local selection={type="selection",name=#objects.." resources selected",icon="Interface\\Icons\\INV_Misc_Map_01",id={},objects=objects}
    local seen={}
    for _,object in ipairs(objects) do
        for _,id in ipairs(object.id) do
            if not seen[id] then seen[id]=true; selection.id[#selection.id+1]=id end
        end
    end
    return selection
end

-- Build availability once per list refresh, without expanding every resource's locations.
function Routes:ZoneResources(mapID)
    local ids={}
    local function add(id,u,v)
        if finite(u) and finite(v) and u>=0 and u<=1 and v>=0 and v<=1 then ids[id]=true end
    end
    for kind in pairs(addon.nodes) do
        for _,node in ipairs(GatherLite:GetNodesForMap(kind,mapID)) do
            if not node.predefined or GatherLite.db.global.usePredefined then
                add(node.object,node.posX,node.posY)
            end
        end
    end
    if GatherLite.db.global.usePredefined then
        for id,maps in pairs(addon.predefined or {}) do
            local coords=maps[mapID] or {}
            for i=1,#coords,2 do add(id,coords[i],coords[i+1]); if ids[id] then break end end
        end
    end
    return ids
end

-- Combine unloaded compressed data and indexed nodes without changing tracking.
function Routes:Collect(object, checkpoint, onlyMapID)
    local maps, seen, ids, zoneTypes = {}, {}, {}, {}
    checkpoint = checkpoint or function() end
    for _, id in ipairs(object.id) do ids[id] = true end
    local function add(mapID, u, v, id)
        checkpoint()
        if onlyMapID and mapID~=onlyMapID then return end
        if not finite(mapID) or not finite(u) or not finite(v) or u < 0 or u > 1 or v < 0 or v > 1 then return end
        if zoneTypes[mapID] == nil then
            local info = C_Map.GetMapInfo(mapID)
            zoneTypes[mapID] = info ~= nil and info.mapType == 3
        end
        if not zoneTypes[mapID] then return end
        seen[mapID] = seen[mapID] or {}
        local key = string.format("%.4f:%.4f", u, v)
        if seen[mapID][key] then return end
        local x, y, instance = HBD:GetWorldCoordinatesFromZone(u, v, mapID)
        if not finite(x) or not finite(y) or instance == nil then return end
        seen[mapID][key] = true
        maps[mapID] = maps[mapID] or {}
        maps[mapID][#maps[mapID] + 1] = { u = u, v = v, x = x, y = y, instance = instance, object = id }
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
    for kind, allNodes in pairs(addon.nodes) do
        local nodes = onlyMapID and GatherLite:GetNodesForMap(kind, onlyMapID) or allNodes
        for _, node in ipairs(nodes) do
            if ids[node.object] and (not node.predefined or GatherLite.db.global.usePredefined) then
                add(node.mapID, node.posX, node.posY, node.object)
            else checkpoint() end
        end
    end
    if GatherLite.db.global.usePredefined then
        for id in pairs(ids) do
            local reference = (addon.predefined or {})[id] or {}
            if onlyMapID then
                local coords = reference[onlyMapID] or {}
                for i = 1, #coords, 2 do add(onlyMapID, coords[i], coords[i + 1], id) end
            else
                for mapID, coords in pairs(reference) do
                    for i = 1, #coords, 2 do add(mapID, coords[i], coords[i + 1], id) end
                end
            end
        end
    end
    return maps
end

function Routes:SortedZones(locations, scores)
    local zones = {}
    for id in pairs(locations) do zones[#zones + 1] = id end
    table.sort(zones, function(a, b)
        local scoreA, scoreB = scores and scores[a], scores and scores[b]
        if scoreA and scoreB then return scoreA > scoreB or (scoreA == scoreB and a < b) end
        if scoreA or scoreB then return scoreA ~= nil end
        local x, y = #locations[a], #locations[b]
        return x > y or (x == y and a < b)
    end)
    return zones
end

function Routes:RecommendedZones(locations, completed)
    local scores = {}
    local planner = addon.RoutePlanner
    local path = addon.GroundNavigation and addon.GroundNavigation.Path
    for id, points in pairs(locations) do
        local route
        if completed then
            route = completed[id]
        elseif #points >= 3 and (not path or path.HasData(points[1].instance)) then
            -- Estimate stops per distance with a quick tour. Only the chosen zone needs terrain searches.
            local stops = planner.Stops(points, nil, 32)
            route = planner.Build(stops, nil, nil, { prepared = true, optimizationPasses = 0 })
        end
        if route then scores[id] = route.score end
    end
    return self:SortedZones(locations, scores)
end

function Routes:Notify()
    if addon.Window then addon.Window:RefreshRoute() end
    local sidebar = GatherLite.modules and GatherLite.modules.worldMapSidebar
    if sidebar then sidebar:RefreshProgress() end
end

-- Save only scalar route geometry, never live resource objects, coroutines or
-- decoded terrain. Bump the schema when planner/terrain semantics change.
local CACHE_SCHEMA = 1
local function copyPoints(points, minimum, maximum)
    if type(points)~="table" or #points<minimum or #points>maximum then return end
    local copy={}
    for i,point in ipairs(points) do
        if type(point)~="table" or not finite(point.x) or not finite(point.y)
            or not finite(point.u) or not finite(point.v) or not finite(point.instance)
            or (point.z~=nil and not finite(point.z)) then return end
        copy[i]={x=point.x,y=point.y,u=point.u,v=point.v,z=point.z,instance=point.instance}
    end
    return copy
end
local function copyRoute(route, mapID)
    if type(route)~="table" or route.terrainAware~=true or not finite(route.length)
        or route.length<=0 or not finite(route.score) or route.score<0 then return end
    local points=copyPoints(route.points,3,64)
    local geometry=copyPoints(route.geometry,2,50000)
    if not points or not geometry then return end
    local first,last=geometry[1],geometry[#geometry]
    if first.x~=last.x or first.y~=last.y or first.instance~=last.instance then return end
    if route.omitted~=nil and (not finite(route.omitted) or route.omitted<0) then return end
    return {mapID=mapID,points=points,geometry=geometry,length=route.length,
        score=route.score,omitted=route.omitted,terrainAware=true}
end
local function clientBuild()
    return GetBuildInfo and select(4,GetBuildInfo()) or nil
end
function Routes:Save()
    local saved={schema=CACHE_SCHEMA,version=addon.version,build=clientBuild(),
        predefined=not not GatherLite.db.global.usePredefined,
        onlyMapID=self.onlyMapID,bestMapID=self.bestMapID,ids={},byMap={}}
    for _,object in ipairs(self.object.objects or {self.object}) do
        saved.ids[#saved.ids+1]=object.id[1]
    end
    for mapID,route in pairs(self.byMap) do
        local copy=copyRoute(route,mapID)
        if not copy then GatherLite.db.char.savedRoute=nil; return end
        saved.byMap[mapID]=copy
    end
    GatherLite.db.char.savedRoute=saved
end
function Routes:Restore(object, preferredMapID, onlyMapID)
    local saved=GatherLite.db.char.savedRoute
    if type(saved)~="table" or saved.schema~=CACHE_SCHEMA or saved.version~=addon.version
        or saved.build~=clientBuild() or saved.predefined~=(not not GatherLite.db.global.usePredefined)
        or saved.onlyMapID~=onlyMapID or type(saved.ids)~="table" or type(saved.byMap)~="table" then return false end
    local objects=object.objects or {object}
    if #saved.ids~=#objects then return false end
    for i,resource in ipairs(objects) do if saved.ids[i]~=resource.id[1] then return false end end
    local byMap,count={},0
    for mapID,route in pairs(saved.byMap) do
        count=count+1
        if count>100 or not finite(mapID) or (onlyMapID and mapID~=onlyMapID)
            or not C_Map.GetMapInfo(mapID) then return false end
        local copy=copyRoute(route,mapID)
        if not copy then return false end
        copy.object=object; byMap[mapID]=copy
    end
    if not byMap[saved.bestMapID] then return false end
    self.worker,self.progress=nil,nil
    self.object,self.onlyMapID,self.byMap,self.bestMapID=object,onlyMapID,byMap,saved.bestMapID
    self:SelectMap(byMap[preferredMapID] and preferredMapID or saved.bestMapID)
    if addon.Window then addon.Window:ShowRoute(self.active) end
    return true
end

function Routes:Clear()
    self.worker, self.active, self.progress = nil, nil, nil
    if addon.GroundNavigation and addon.GroundNavigation.Release then addon.GroundNavigation:Release() end
    self.byMap, self.bestMapID, self.object = nil, nil, nil
    self.onlyMapID = nil
    GatherLite.db.char.routeObjects, GatherLite.db.char.routeOnlyMapID = nil, nil
    GatherLite.db.char.routeObject, GatherLite.db.char.routeMapID = nil, nil
    GatherLite.db.char.savedRoute = nil
    self.status = T("window.route.status.cleared")
    self:Notify()
end

function Routes:SelectMap(mapID)
    if not self.byMap then return end
    self.active = self.byMap[mapID]
    GatherLite.db.char.routeObject = self.object.id[1]
    local ids={}
    for _,object in ipairs(self.object.objects or {self.object}) do ids[#ids+1]=object.id[1] end
    GatherLite.db.char.routeObjects = ids
    GatherLite.db.char.routeOnlyMapID = self.onlyMapID
    GatherLite.db.char.routeMapID = self.active and mapID or nil
    if self.active then
        local route = self.active
        self.status = string.format("%s%s | %d stops | %.1f km | %s",
            C_Map.GetMapInfo(mapID).name, mapID == self.bestMapID and " (recommended)" or "",
            #route.points, route.length * 0.0009144, T("window.route.ground"))
        if route.omitted and route.omitted > 0 then
            self.status = self.status .. " | " .. T("window.route.omitted", route.omitted)
        end
    else
        self.status = T("window.route.status.no_circuit")
    end
    self:Notify()
end

function Routes:Generate(object, preferredMapID, onlyMapID)
    if object.type=="fish" then return end
    self:Clear()
    -- Track ownership while the coroutine is still running, so a resource
    -- switch can cancel it before it publishes a route or changes the map.
    self.object = object
    self.onlyMapID = onlyMapID
    self.status = T("window.route.status.reading")
    self.progress = 0
    self:Notify()
    self.worker = coroutine.create(function()
        local work = 0
        local function checkpoint()
            work = work + 1
            if work >= 1500 then work = 0; coroutine.yield() end
        end
        local maps, mapIDs = self:Collect(object, checkpoint, onlyMapID), {}
        for mapID in pairs(maps) do mapIDs[#mapIDs + 1] = mapID end
        table.sort(mapIDs)
        local best, byMap, failure = nil, {}, nil
        for index, mapID in ipairs(mapIDs) do
            self.status = T("window.route.status.comparing", index, #mapIDs, C_Map.GetMapInfo(mapID).name)
            self.progress = 5 + 95 * (index - 1) / #mapIDs
            local candidate, reason = addon.GroundNavigation:Build(maps[mapID], mapID, checkpoint, function(fraction)
                self.progress = 5 + 95 * (index - 1 + fraction) / #mapIDs
            end)
            failure = reason or failure
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
            self:Save()
            if addon.Window then addon.Window:ShowRoute(self.active) end
        else
            self.status = T(failure == "unavailable" and "window.route.status.no_decoder"
                or failure == "nodata" and "window.route.status.no_terrain"
                or failure == "unreachable" and "window.route.status.no_ground"
                or "window.route.status.not_enough")
            self:Notify()
        end
    end)
end

function Routes:Tick()
    if not self.worker then return end
    if addon.GroundNavigation.BeginSlice then addon.GroundNavigation:BeginSlice() end
    local ok, err = coroutine.resume(self.worker)
    if addon.GroundNavigation.EndSlice then addon.GroundNavigation:EndSlice() end
    if not ok then
        self.worker = nil
        self.progress = nil
        self.status = T("window.route.status.failed")
        self:Notify()
        geterrorhandler()(err)
    elseif coroutine.status(self.worker) == "dead" then
        self.worker = nil
        self:Notify()
    else
        self:Notify()
    end
    if not self.worker and addon.GroundNavigation.Release then addon.GroundNavigation:Release() end
end

function Routes.setup()
    local frame, restored = CreateFrame("Frame"), false
    frame:SetScript("OnUpdate", function(_, elapsed)
        if not GatherLite:IsLoaded() then return end
        if not restored then
            restored = true
            local objects={}
            for _,id in ipairs(GatherLite.db.char.routeObjects or {GatherLite.db.char.routeObject}) do
                local object=GatherLite:GetNodeObject(id)
                if object then objects[#objects+1]=object end
            end
            local object=Routes:Combine(objects)
            if object then
                local mapID,onlyMapID=GatherLite.db.char.routeMapID,GatherLite.db.char.routeOnlyMapID
                local legacy=GatherLite.db.char.savedRoute==nil
                if not Routes:Restore(object,mapID,onlyMapID) then
                    -- Old saves contained only a selected map/resource. Avoid
                    -- rebuilding every zone just to show that map after login.
                    Routes:Generate(object,mapID,onlyMapID or (legacy and mapID or nil))
                end
            else GatherLite.db.char.savedRoute=nil end
        end
        Routes:Tick()
        Routes:Draw(elapsed)
    end)
    Routes.predefined = GatherLite.db.global.usePredefined
    GatherLite:On("settings:update", function()
        if Routes.predefined ~= GatherLite.db.global.usePredefined then
            Routes.predefined = GatherLite.db.global.usePredefined
            local object, mapID, onlyMapID = Routes.object, GatherLite.db.char.routeMapID, Routes.onlyMapID
            Routes:Clear()
            if object then Routes:Generate(object, mapID, onlyMapID) end
        end
    end)
    GatherLite:RegisterChatCommand("gatherroutes", function() GatherLite:ShowSettings() end)
end
