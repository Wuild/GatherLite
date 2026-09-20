local _, addon = ...

-- Pure route geometry, also exercised by tools/test_routes.lua.
local Planner = {}
addon.RoutePlanner = Planner

local function distance(a, b)
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function Planner.Build(points, checkpoint, progress)
    checkpoint = checkpoint or function() end
    progress = progress or function() end
    table.sort(points, function(a, b)
        return a.x < b.x or (a.x == b.x and a.y < b.y)
    end)
    -- Collapse dense spawn alternatives into stops; bound both drawing and search.
    local size, stops = 60
    repeat
        local cells = {}
        stops = {}
        for _, point in ipairs(points) do
            local key = math.floor(point.x / size) .. ":" .. math.floor(point.y / size)
            if not cells[key] then
                cells[key] = true
                stops[#stops + 1] = point
            end
            checkpoint()
        end
        size = size * 1.5
    until #stops <= 250
    if #stops < 3 then return nil end

    local total = #stops
    local route = { table.remove(stops, 1) }
    while #stops > 0 do
        local best, bestDistance = 1, math.huge
        for i, point in ipairs(stops) do
            local d = distance(route[#route], point)
            if d < bestDistance then best, bestDistance = i, d end
            checkpoint()
        end
        route[#route + 1] = table.remove(stops, best)
        progress(.3 * #route / total)
    end
    -- Bounded 2-opt removes crossings and shortens the closed circuit.
    for pass = 1, 4 do
        local changed = false
        for i = 1, #route - 2 do
            progress(.3 + .7 * ((pass - 1) + i / #route) / 4)
            for j = i + 2, #route do
                local a, b = route[i], route[i + 1]
                local c, d = route[j], route[j % #route + 1]
                if distance(a, c) + distance(b, d) + 0.01 < distance(a, b) + distance(c, d) then
                    local left, right = i + 1, j
                    while left < right do
                        route[left], route[right] = route[right], route[left]
                        left, right = left + 1, right - 1
                    end
                    changed = true
                end
                checkpoint()
            end
        end
        if not changed then break end
    end
    local length = 0
    for i, point in ipairs(route) do length = length + distance(point, route[i % #route + 1]) end
    return { points = route, length = length, score = #route / math.max(1000, length) }
end

-- Clip segments, including those whose two endpoints are outside the minimap.
function Planner.ClipCircle(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    local a = dx * dx + dy * dy
    if a < 0.00000001 then return nil end
    local b, c = 2 * (x1 * dx + y1 * dy), x1 * x1 + y1 * y1 - 0.96^2
    local discriminant = b * b - 4 * a * c
    if discriminant < 0 then return nil end
    local root = math.sqrt(discriminant)
    local first = math.max(0, (-b - root) / (2 * a))
    local last = math.min(1, (-b + root) / (2 * a))
    if first >= last then return nil end
    return x1 + first * dx, y1 + first * dy, x1 + last * dx, y1 + last * dy
end

function Planner.ClipSquare(x1, y1, x2, y2)
    return Planner.ClipRect(x1, y1, x2, y2, -.96, .96, -.96, .96)
end

function Planner.ClipRect(x1, y1, x2, y2, left, right, top, bottom)
    local dx, dy, first, last = x2 - x1, y2 - y1, 0, 1
    local function edge(p, q)
        if p == 0 then return q >= 0 end
        local r = q / p
        if p < 0 then first = math.max(first, r) else last = math.min(last, r) end
        return first < last
    end
    if not edge(-dx, x1 - left) or not edge(dx, right - x1)
        or not edge(-dy, y1 - top) or not edge(dy, bottom - y1) then return nil end
    return x1 + first * dx, y1 + first * dy, x1 + last * dx, y1 + last * dy
end
