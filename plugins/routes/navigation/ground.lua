local _, addon = ...
local Ground = addon.GroundNavigation
local HBD = LibStub("HereBeDragons-2.0")

function Ground:Available()
    return C_EncodingUtil and C_EncodingUtil.DecodeBase64 and C_EncodingUtil.DecompressString
        and Enum and Enum.CompressionMethod and Enum.CompressionMethod.Zlib ~= nil
end

function Ground:BeginSlice()
    self.PathGrid.Deadline(self.Path.clock() + self.Path.budget)
end

function Ground:EndSlice()
    self.PathGrid.Deadline(math.huge)
end

function Ground:Release()
    self:EndSlice()
    self.PathGrid.Reset()
    self.PathSearch.Spare(nil)
    self.PathSearch.scratch()
end

-- HBD uses x west / y north; the terrain uses UnitPosition's x north / y west.
-- Keep endpoints on their own walkable cell. No long off-mesh snapping, ledge
-- jumps or guessed floor changes are allowed for a repeatable farming circuit.
function Ground:Endpoint(point)
    local grid = self.PathGrid
    local state = grid.State(point.instance)
    if not state then return nil end
    local k, cell = grid.locate(state, point.y, point.x)
    if not k then return nil end
    local values = grid.grid(state, k)
    if not values or values[cell + 1] == 0 then return nil end
    if state.at[k][-(cell + 1)] then return nil end -- unknown height on overlapping floors
    local x = state.x0 + (math.floor(k / state.ny) * state.C + math.floor(cell / state.C) + .5) * state.cs
    local y = state.y0 + ((k % state.ny) * state.C + cell % state.C + .5) * state.cs
    return {map=point.instance, x=x, y=y, z=state.z[k][cell + 1]}
end

function Ground:Search(map, from, to, targets)
    return self.PathSearch.start({map=map, from=from, to=to, targets=targets,
        costs=targets and {}, revision=0, radius=0, waterWalking=false})
end

-- At most 64 representative stops bound endpoint work. One multi-target
-- terrain search per stop supplies the walking costs used to order the tour.
-- Only mutually reachable stops can share a circuit; every drawn leg is then
-- refined through the terrain, including the final return to the first stop.
function Ground:Build(points, mapID, checkpoint, progress)
    if not self:Available() then return nil, "unavailable" end
    local stops = addon.RoutePlanner.Stops(points, checkpoint, 64)
    if #stops < 3 then return nil, "insufficient" end
    local map = stops[1].instance
    if not self.Path.HasData(map) then return nil, "nodata" end
    local valid, endpoints = {}, {}
    for _, point in ipairs(stops) do
        local endpoint = point.instance == map and self:Endpoint(point)
        if endpoint then
            valid[#valid + 1] = point
            endpoints[#endpoints + 1] = endpoint
        end
        checkpoint()
    end
    if #valid < 3 then return nil, "unreachable" end
    local rows, indices = {}, {}
    for i, point in ipairs(valid) do
        indices[point] = i
        rows[i] = self:Search(map, endpoints[i], nil, endpoints)
        if not rows[i] then return nil, "unreachable" end
        progress(.7 * i / #valid)
        checkpoint()
    end
    local function cost(a, b)
        local i, j = indices[a], indices[b]
        local forward, backward = rows[i][j], rows[j][i]
        if type(forward) ~= "number" or type(backward) ~= "number" then return math.huge end
        return math.max(forward, backward)
    end
    -- Complete mutual-reachability groups ensure nearest-neighbour and 2-opt
    -- can never introduce an unwalkable edge between disconnected terrain.
    local groups = {}
    for _, point in ipairs(valid) do
        local target
        for _, group in ipairs(groups) do
            local connected = true
            for _, other in ipairs(group) do
                if cost(point, other) == math.huge then connected=false; break end
            end
            if connected then target=group; break end
        end
        if not target then target={}; groups[#groups + 1]=target end
        target[#target + 1] = point
    end
    local best
    for _, group in ipairs(groups) do
        local candidate = addon.RoutePlanner.Build(group, checkpoint, function() end,
            {prepared=true, cost=cost})
        if candidate and (not best or candidate.score > best.score) then best=candidate end
    end
    if not best then return nil, "unreachable" end
    local geometry, length = {}, 0
    for i, point in ipairs(best.points) do
        local nextPoint = best.points[i % #best.points + 1]
        local line = self:Search(map, endpoints[indices[point]], endpoints[indices[nextPoint]])
        if not line or #line < 2 then return nil, "unreachable" end
        for j, position in ipairs(line) do
            if i == 1 or j > 1 then
                local x, y = position.y, position.x
                local u, v = HBD:GetZoneCoordinatesFromWorldInstance(x, y, map, mapID, true)
                if not u or not v then return nil, "outside" end
                local previous = geometry[#geometry]
                if previous then length=length + math.sqrt((previous.x-x)^2 + (previous.y-y)^2) end
                geometry[#geometry + 1] = {x=x, y=y, z=position.z, u=u, v=v, instance=map}
            end
            checkpoint()
        end
        progress(.7 + .3 * i / #best.points)
    end
    best.cost, best.length = best.length, length
    best.geometry, best.terrainAware = geometry, true
    best.omitted = #stops - #best.points
    return best
end
