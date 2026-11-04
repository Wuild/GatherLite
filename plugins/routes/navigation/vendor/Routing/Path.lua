---@class SPFNamespace
local ns = select(2, ...).GroundNavigation

-- Walking searches over PathGrid.lua's decoded maps: HPA* between ADT-tile clusters, an 8 yd grid inside them, and
-- FindMany's abstract Dijkstra. PathJobs.lua slices them over frames.
---@class SPFPath
local Path = ns.Path
local Grid = ns.PathGrid
local tick, Deadline, Expansions, State, surface, grid =
	Grid.tick, Grid.Deadline, Grid.Expansions, Grid.State, Grid.surface, Grid.grid
local cellOf, nodesOf, metadata, adjacent = Grid.cellOf, Grid.nodesOf, Grid.metadata, Grid.adjacent
local entrance, locate, standing, snap, smooth = Grid.entrance, Grid.locate, Grid.standing, Grid.snap, Grid.smooth
local toward = Grid.toward

local TILE, SNAP, ZTOL, DX, DY = Grid.TILE, Grid.SNAP, Grid.ZTOL, Grid.DX, Grid.DY
local RETRIES = 0 -- other cells tried for an endpoint stuck in a pocket
local DROP = 30 -- how far below its surface a stuck endpoint may move: one can jump down a ledge, never climb one
local SQRT2 = math.sqrt(2)
local START, GOAL = -1, -2

local floor, sqrt, huge, max, abs = math.floor, math.sqrt, math.huge, math.max, math.abs
local yield = coroutine.yield

-- Binary min-heap on parallel arrays, reset per search.
local hk, hv, hn = {}, {}, 0

local function push(k, v)
	hn = hn + 1
	local i = hn
	while i > 1 do
		local p = floor(i / 2)
		if hk[p] <= k then
			break
		end
		hk[i], hv[i] = hk[p], hv[p]
		i = p
	end
	hk[i], hv[i] = k, v
end

local function pop()
	local top = hv[1]
	local k, v = hk[hn], hv[hn]
	hn = hn - 1
	local i = 1
	while true do
		local c = i * 2
		if c > hn then
			break
		end
		if c < hn and hk[c + 1] < hk[c] then
			c = c + 1
		end
		if hk[c] >= k then
			break
		end
		hk[i], hv[i] = hk[c], hv[c]
		i = c
	end
	hk[i], hv[i] = k, v
	return top
end

-- Grid search inside one cluster, entering water costing swim times its length. tree holds g/parent keyed by
-- node + 1. With goal set it is A*, otherwise Dijkstra that stops once every node in targets (a set of nodes) is
-- settled.
local function Tree()
	return { g = {}, par = {}, stamp = {}, closed = {}, gen = 0 }
end
-- One grid search loop; splitting moves its retained arrays to upvalues on the hot path
local function search(st, k, swim, source, tree, goal, targets, left)
	local val = grid(st, k)
	-- Search only enters populated grids, through snapped endpoints or decoded entrances.
	---@cast val number[]
	-- A paused search retains these arrays even if another job evicts its cluster.
	local m, z, at, links = st.moves[k], st.z[k], st.at[k], st.links[k]
	local C, cs = st.C, st.cs
	local N = C * C
	local g, par, stamp, closed = tree.g, tree.par, tree.stamp, tree.closed
	tree.gen = tree.gen + 1
	local gen = tree.gen
	tree.k = k
	local gx, gy = 0, 0
	if goal then
		local cell = goal < N and goal or at[goal + 1]
		gx, gy = floor(cell / C), cell % C
	end
	hn = 0
	g[source + 1], par[source + 1], stamp[source + 1] = 0, -1, gen
	push(0, source)

	---@type number, number, number, number
	local u, ux, uy, gu
	local function relax(v, length)
		local i = v + 1
		local gv = gu + length * cs * (val[i] == 2 and swim or 1)
		if stamp[i] ~= gen or gv < g[i] then
			g[i], par[i], stamp[i] = gv, u, gen
			local h = 0
			if goal then
				local cell = v < N and v or at[i]
				local ax, ay = floor(cell / C) - gx, cell % C - gy
				if ax < 0 then
					ax = -ax
				end
				if ay < 0 then
					ay = -ay
				end
				h = (ax > ay and ax + (SQRT2 - 1) * ay or ay + (SQRT2 - 1) * ax) * cs
			end
			push(gv + h, v)
		end
	end

	while hn > 0 do
		u = pop()
		local i = u + 1
		if closed[i] ~= gen then
			closed[i] = gen
			tick()
			if u == goal then
				return true
			end
			if targets and targets[u] then
				left = left - 1
				if left <= 0 then
					return true
				end
			end
			local cell = u < N and u or at[i]
			gu, ux, uy = g[i], floor(cell / C), cell % C
			if u < N then
				local mi = m[i] % 16
				local px, mx = mi % 2 == 1, ux > 0 and m[i - C] % 2 == 1
				local py, my = mi % 4 >= 2, uy > 0 and m[i - 1] % 4 >= 2
				if px then
					relax(u + C, 1)
				end
				if mx then
					relax(u - C, 1)
				end
				if py then
					relax(u + 1, 1)
				end
				if my then
					relax(u - 1, 1)
				end
				if mi % 8 >= 4 then
					relax(u + C + 1, SQRT2)
				end
				if mi >= 8 then
					relax(u + C - 1, SQRT2)
				end
				if ux > 0 and uy > 0 and m[i - C - 1] % 8 >= 4 then
					relax(u - C - 1, SQRT2)
				end
				if ux > 0 and uy < C - 1 and m[i - C + 1] % 16 >= 8 then
					relax(u - C + 1, SQRT2)
				end
			end
			local l = links[i]
			if l then
				for e = 1, #l do
					local d = l[e] % 8
					local tx, ty = ux + DX[d], uy + DY[d]
					if tx >= 0 and ty >= 0 and tx < C and ty < C then
						local v = surface(st, k, tx * C + ty, floor(l[e] / 8) - 1, z[i], val, z, at)
						if v then
							relax(v, d >= 4 and SQRT2 or 1)
						end
					end
				end
			end
		end
	end
	return goal == nil
end

local function reached(tree, node)
	return tree.stamp[node + 1] == tree.gen and tree.closed[node + 1] == tree.gen
end

-- Node path in a tree from node back to its source (node first).
local function trace(tree, node, out)
	local par = tree.par
	while node >= 0 do
		out[#out + 1] = node
		node = par[node + 1]
	end
	return out
end

local trees = { S = Tree(), G = Tree(), R = Tree() }

-- An entrance's world position: the centre of its cell.
local function nodeXY(st, id)
	local k, C = floor(id / 4096), st.C
	nodesOf(st, k)
	local lc = metadata(st, id)
	return st.x0 + (floor(k / st.ny) * C + floor(lc / C) + 0.5) * st.cs,
		st.y0 + ((k % st.ny) * C + lc % C + 0.5) * st.cs
end

-- What a hazard profile (Journey/Hazards.lua) multiplies an entrance graph edge by: the mean of its ends' factors, or
-- a town's when the edge crosses one. Ends are kept per profile; the town test runs only in clusters a town is near.
local function hazard(st, hz, u, v)
	local memo = st.hazards
	if not memo or memo.key ~= hz.key then
		memo = { key = hz.key, at = {}, near = {} }
		st.hazards = memo
	end
	local at, ux, uy, vx, vy = memo.at, nil, nil, nil, nil
	local fu, fv = at[u], at[v]
	if not fu then
		ux, uy = nodeXY(st, u)
		fu = hz.Point(st.map, ux, uy)
		at[u] = fu
	end
	if not fv then
		vx, vy = nodeXY(st, v)
		fv = hz.Point(st.map, vx, vy)
		at[v] = fv
	end
	local f, k = (fu + fv) / 2, floor(u / 4096)
	local near = memo.near[k]
	if near == nil then
		-- An edge stays within its cluster's neighbours, so a town matters if it is within a cluster of this one.
		local x, y = st.x0 + (floor(k / st.ny) - 1) * TILE, st.y0 + (k % st.ny - 1) * TILE
		near = hz.Near(st.map, x, y, x + 3 * TILE, y + 3 * TILE)
		memo.near[k] = near
	end
	if near then
		if not ux then
			ux, uy = nodeXY(st, u)
		end
		if not vx then
			vx, vy = nodeXY(st, v)
		end
		local town = hz.Chord(st.map, ux, uy, vx, vy)
		if town > f then
			f = town
		end
	end
	return f
end

-- Abstract A* state.
local ag, areal, apar, astamp, aclosed, agen = {}, {}, {}, {}, {}, 0

-- Endpoint searches: grid Dijkstra to the cluster's entrances.
local function endpoint(st, swim, tree, k, node)
	local targets, left = {}, 0
	for _, id in ipairs(nodesOf(st, k)) do
		local e = entrance(st, id)
		if e and not targets[e] then
			targets[e], left = true, left + 1
		end
	end
	search(st, k, swim, node, tree, nil, targets, left)
end
-- An endpoint on a rooftop or ledge the grid cannot leave moves to the nearest node that reaches an entrance,
-- down a ledge but never up one or onto another level.
local function settle(st, swim, tree, k, node)
	local C = st.C
	endpoint(st, swim, tree, k, node)
	local function connected()
		for _, id in ipairs(nodesOf(st, k)) do
			local e = entrance(st, id)
			if e and reached(tree, e) then
				return true
			end
		end
		return false
	end
	if connected() then
		return node
	end
	local tries = 0
	grid(st, k)
	local h = st.z[k][node + 1]
	local cell = cellOf(st, k, node)
	local lx, ly = floor(cell / C), cell % C
	for r = 1, SNAP do
		for dx = -r, r do
			for dy = -r, r do
				if tries >= RETRIES then
					return node
				end
				local x, y = lx + dx, ly + dy
				local ring = dx == r or dx == -r or dy == r or dy == -r
				if ring and x >= 0 and y >= 0 and x < C and y < C then
					local near = standing(st, k, x * C + y, h)
					local rise = near and st.z[k][near + 1] - h
					if near and rise <= ZTOL and rise >= -DROP and not reached(tree, near) then
						tries, node = tries + 1, near
						endpoint(st, swim, tree, k, node)
						if connected() then
							return node
						end
					end
				end
			end
		end
	end
	return node
end

-- Both APIs connect endpoints with the same local search. Connections are outward at both ends, as in the
-- baked undirected graph; the same-cluster direct edge retains the grid's entering-water direction.
local function connections(st, tree, k)
	local edges = {}
	for _, id in ipairs(nodesOf(st, k)) do
		local e = entrance(st, id)
		if e and reached(tree, e) then
			edges[id] = tree.g[e + 1]
		end
	end
	return edges
end

local function pointNode(st, point)
	local k, node = locate(st, point.x, point.y)
	if not k then
		return nil, nil, "outside"
	end
	node = snap(st, k, node, point.x, point.y, point.z)
	return k, node, not node and "offmesh" or nil
end

-- Fixed places recur in both batches and in later journeys. Keep their small entrance-cost vectors and only the
-- last eight grid trees; cap the cache so moving start positions cannot grow it for the entire play session.
local function connect(st, swim, k, node)
	nodesOf(st, k)
	local key = k .. ":" .. node .. ":" .. swim
	local entry = st.ends[key]
	if not entry then
		local tree = Tree()
		node = settle(st, swim, tree, k, node)
		entry = { node = node, edges = connections(st, tree, k), tree = tree }
		-- A handful of local trees removes repeated endpoint searches without retaining a continent's grids.
		st.endTrees = st.endTrees or {}
		st.endTrees[#st.endTrees + 1] = entry
		if #st.endTrees > 8 then
			table.remove(st.endTrees, 1).tree = nil
		end
		if st.endCount >= 256 then
			st.ends, st.endCount = {}, 0
		end
		st.ends[key], st.endCount = entry, st.endCount + 1
	end
	return entry.node, entry.edges, entry.tree
end

-- A point without a height (the player, whose UnitPosition height is a placeholder 0, or a map click) could stand on
-- any surface at its spot, so it starts from each one within a cell of it at a distinct height and the search keeps
-- the cheapest: a street beside or over a canal is not walked from the canal bed. Returns each surface's connection,
-- the entrance costs merged by minimum and, per entrance, the surface it came from.
local function connectPoint(st, swim, k, node, h)
	local nodes = { node }
	if not h then
		local values = grid(st, k)
		assert(values)
		local C, val, z, at = st.C, values, st.z[k], st.at[k]
		local cell = cellOf(st, k, node)
		local lx, ly = floor(cell / C), cell % C
		local function consider(n, r)
			-- A neighbour's water is where the point is not: it would be standing in it.
			if r > 0 and val[n + 1] == 2 then
				return
			end
			for _, m in ipairs(nodes) do
				if abs(z[n + 1] - z[m + 1]) <= ZTOL then
					return
				end
			end
			nodes[#nodes + 1] = n
		end
		for r = 0, 1 do
			for dx = -r, r do
				for dy = -r, r do
					local x, y = lx + dx, ly + dy
					if (dx == r or dx == -r or dy == r or dy == -r) and x >= 0 and y >= 0 and x < C and y < C then
						local c = x * C + y
						if val[c + 1] ~= 0 then
							consider(c, r)
						end
						local n = at[-(c + 1)]
						while n and at[n + 1] == c do
							consider(n, r)
							n = n + 1
						end
					end
				end
			end
		end
	end
	local ends, merged, via = {}, {}, {}
	for _, start in ipairs(nodes) do
		local n, edges, tree = connect(st, swim, k, start)
		ends[#ends + 1] = { node = n, tree = tree }
		for id, cost in pairs(edges) do
			if not merged[id] or cost < merged[id] then
				merged[id], via[id] = cost, ends[#ends]
			end
		end
	end
	return ends, merged, via
end
-- A point's position in global cells, and the node it stands on in its own cell: within ZTOL of its height, or the
-- base surface when it has none.
local function own(st, point)
	local fx, fy = (point.x - st.x0) / st.cs, (point.y - st.y0) / st.cs
	local k, lc = locate(st, point.x, point.y)
	local node, gap = standing(st, k, lc, point.z)
	return fx, fy, k, (node and gap <= ZTOL) and node or nil
end

-- The string is pulled between node centres, but the line is drawn from the endpoints themselves. Whether the drawn
-- segment between point and path entry j's cell centre stays on the walkable surface, walked in the direction it is
-- travelled (outbound from the start, inbound to the goal). A point standing on a surface must be reached on it, or
-- leave from it; one with no surface in its cell (inside rock or a building the grid has none for) passes when the
-- segment runs on into it only across cells with no surface at all.
local function clearEnd(st, P, j, point, outbound, water)
	local fx, fy, k, node = own(st, point)
	local cx, cy = P.x[j] + 0.5, P.y[j] + 0.5
	if outbound and node then
		local tk, tn = toward(st, k, node, fx, fy, cx, cy, water)
		return tk == P.k[j] and tn == P.n[j]
	end
	local tk, tn = toward(st, P.k[j], P.n[j], cx, cy, fx, fy, water)
	if not tk then
		return tn == true
	end
	return not node or (tk == k and tn == node)
end

-- With no pulled vertex between them, the line is the one chord between the two points: walked whole from a start
-- that stands on a surface to the goal's cell, on the goal's own surface when it has one.
local function clearChord(st, from, to, water)
	local fx, fy, k, node = own(st, from)
	if not node then
		return false
	end
	local tx, ty, gk, goal = own(st, to)
	local tk, tn = toward(st, k, node, fx, fy, tx, ty, water)
	return tk ~= nil and (not goal or (tk == gk and tn == goal))
end

-- Sliced A* and refinement share scratch trees; splitting adds hot-path calls and upvalues
local function run(map, from, to, waterWalking, costOnly, hz)
	if hz and hz.ConnectorWalk and hz.ConnectorWalk(from, to) then
		hz = nil
	end
	local st = State(map)
	if not st then
		return nil, "nodata"
	end
	-- Walking on water is running, so the search weights water by 1 and reads each edge's second cost.
	local swim, cost2 = st.swim, 1
	if waterWalking then
		swim, cost2 = 1, 2
	end
	local sk, sc = locate(st, from.x, from.y)
	local gk, gc = locate(st, to.x, to.y)
	if not sk or not gk then
		return nil, "outside"
	end
	sc, gc = snap(st, sk, sc, from.x, from.y, from.z), snap(st, gk, gc, to.x, to.y, to.z)
	if not sc or not gc then
		return nil, "offmesh"
	end
	local C = st.C

	local S, G = trees.S, trees.G
	local starts, source, sourceVia = connectPoint(st, swim, sk, sc, from.z)
	local goals, target, targetVia = connectPoint(st, swim, gk, gc, to.z)
	local key = table.concat({ sk, sc, gk, gc, swim, from.z and 1 or 0, to.z and 1 or 0, hz and hz.key or "" }, ":")
	st.paths = st.paths or {}
	local cached = st.paths[key]
	local hops, cost, directFrom, directTo
	local x0, y0, cs = st.x0, st.y0, st.cs
	if cached then
		hops, cost, directFrom, directTo = cached.hops, cached.cost, cached.directFrom, cached.directTo
	else
		local direct
		if sk == gk then
			for _, a in ipairs(starts) do
				for _, b in ipairs(goals) do
					if search(st, sk, swim, a.node, S, b.node) and (not direct or S.g[b.node + 1] < direct) then
						direct, directFrom, directTo = S.g[b.node + 1], a.node, b.node
					end
				end
			end
		end

		local comps, shared = {}, false
		for id in pairs(source) do
			nodesOf(st, floor(id / 4096))
			local _, _, component = metadata(st, id)
			comps[component] = true
		end
		for id in pairs(target) do
			nodesOf(st, floor(id / 4096))
			local _, _, component = metadata(st, id)
			shared = shared or comps[component]
		end
		if not direct and not shared then
			return nil, "unreachable"
		end

		-- Abstract A* from START to GOAL through the entrance graph.
		-- Rounded graph edges and snapping must not let the heuristic overstate the remaining cost.
		local goalCell = cellOf(st, gk, gc)
		local goalX = x0 + (floor(gk / st.ny) * C + floor(goalCell / C) + 0.5) * cs
		local goalY = y0 + (gk % st.ny * C + goalCell % C + 0.5) * cs
		local lower = max(0, 1 - 0.5 / cs)
		local function h(id)
			local x, y = nodeXY(st, id)
			local dx, dy = abs(x - goalX), abs(y - goalY)
			return (dx > dy and dx + (SQRT2 - 1) * dy or dy + (SQRT2 - 1) * dx) * lower
		end
		agen = agen + 1
		local gen = agen
		hn = 0
		local function relax(v, gv, rv, parent)
			if astamp[v] ~= gen or gv < ag[v] then
				ag[v], areal[v], apar[v], astamp[v] = gv, rv, parent, gen
				push(gv + (v == GOAL and 0 or h(v)), v)
			end
		end
		for id, distance in pairs(source) do
			relax(id, distance, distance, START)
		end
		if direct then
			relax(GOAL, direct, direct, START)
		end
		local found = false
		while hn > 0 do
			local u = pop()
			if aclosed[u] ~= gen then
				aclosed[u] = gen
				tick()
				if u == GOAL then
					found = true
					break
				end
				local gu = ag[u]
				local ru = areal[u]
				if target[u] then
					relax(GOAL, gu + target[u], ru + target[u], u)
				end
				nodesOf(st, floor(u / 4096))
				local adj = adjacent(st, u)
				for e = 1, #adj, 3 do
					local v = adj[e]
					if aclosed[v] ~= gen then
						nodesOf(st, floor(v / 4096))
						local yards = adj[e + cost2]
						local factor = hz and hazard(st, hz, u, v) or 1
						relax(v, gu + yards * factor, ru + yards, u)
					end
				end
			end
		end
		if not found then
			return nil, "unreachable"
		end
		cost = areal[GOAL]
		hops = { GOAL }
		while hops[#hops] ~= START do
			hops[#hops + 1] = apar[hops[#hops]]
		end

		if (st.pathCount or 0) >= 16 then
			st.paths, st.pathCount = {}, 0
		end
		st.paths[key] = { hops = hops, cost = cost, directFrom = directFrom, directTo = directTo }
		st.pathCount = (st.pathCount or 0) + 1
	end
	if costOnly then
		return cost
	end

	-- Refine each hop into nodes with their global cells and a running count of water nodes. The pruned entrance
	-- graph may route through an entrance a little off the way, which refines to a spur walked out and back: a node
	-- reached again cuts the loop since its first visit, so the drawn walk never doubles back.
	local P = { x = {}, y = {}, w = {}, k = {}, n = {} }
	local seen = {}
	local function add(k, node)
		local id = k * 1048576 + node
		local at = seen[id]
		if at then
			for j = #P.x, at + 1, -1 do
				seen[P.k[j] * 1048576 + P.n[j]] = nil
				P.x[j], P.y[j], P.w[j], P.k[j], P.n[j] = nil, nil, nil, nil, nil
			end
			return
		end
		local n = #P.x
		local cell = node < C * C and node or cellOf(st, k, node)
		P.x[n + 1], P.y[n + 1] = floor(k / st.ny) * C + floor(cell / C), (k % st.ny) * C + cell % C
		P.k[n + 1], P.n[n + 1] = k, node
		P.w[n + 1] = (P.w[n] or 0) + ((st.val[k] or grid(st, k))[node + 1] == 2 and 1 or 0)
		seen[id] = n + 1
	end
	local function addAll(k, nodes, first, last, step)
		for i = first, last, step do
			add(k, nodes[i])
		end
	end
	local R = trees.R
	for i = #hops, 2, -1 do
		local a, b = hops[i], hops[i - 1]
		if a == START and b == GOAL then
			search(st, sk, swim, directFrom, S, directTo)
			local nodes = trace(S, directTo, {})
			addAll(sk, nodes, #nodes, 1, -1)
		elseif a == START then
			local start = sourceVia[b]
			local tree = start.tree
			if not tree or not reached(tree, entrance(st, b)) then
				search(st, sk, swim, start.node, S, entrance(st, b))
				tree = S
			end
			local nodes = trace(tree, entrance(st, b), {})
			addAll(sk, nodes, #nodes, 1, -1)
		elseif b == GOAL then
			local goal = targetVia[a]
			local tree = goal.tree
			if not tree or not reached(tree, entrance(st, a)) then
				search(st, gk, swim, goal.node, G, entrance(st, a))
				tree = G
			end
			local nodes = trace(tree, entrance(st, a), {})
			addAll(gk, nodes, 1, #nodes, 1)
		else
			local ka, kb = floor(a / 4096), floor(b / 4096)
			local ea, eb = entrance(st, a), entrance(st, b)
			if ka == kb and search(st, ka, swim, ea, R, eb) then
				local nodes = trace(R, eb, {})
				addAll(ka, nodes, #nodes, 1, -1)
			else -- neighbouring entrances across a cluster border
				add(ka, ea)
				add(kb, eb)
			end
		end
	end

	-- Points carry the height of the surface they stand on; the returned cost uses real walking/swimming time, with
	-- hazards affecting only the route chosen. points.wet is the yards over water, which call for Water Walking.
	local keep = smooth(st, P)
	if #keep == 1 then -- both ends on one node
		keep[2] = keep[1]
	end
	local n = #P.x
	-- An end segment that fails is drawn through its end node's centre first: the string was pulled from there, so the
	-- rest of the line holds as it did. A chord that fails tries each end that way.
	local startVia, goalVia = #keep > 2 and keep[2] or n, #keep > 2 and keep[#keep - 1] or 1
	local startDetour, goalDetour = false, false
	if #keep > 2 or not clearChord(st, from, to, P.w[n] > 0) then
		startDetour = not clearEnd(st, P, startVia, from, true, P.w[startVia] > 0)
		-- A chord whose start detoured now reaches the goal from the start node's centre.
		if startDetour and #keep <= 2 then
			goalVia = 1
		end
		goalDetour = not clearEnd(st, P, goalVia, to, false, P.w[n] - (P.w[goalVia - 1] or 0) > 0)
	end
	local drawn = { 1 }
	if startDetour then
		drawn[#drawn + 1] = 1
	end
	for i = 2, #keep - 1 do
		drawn[#drawn + 1] = keep[i]
	end
	-- Both ends on one node already pass through its centre once the start has detoured.
	if goalDetour and not (startDetour and n == 1) then
		drawn[#drawn + 1] = n
	end
	drawn[#drawn + 1] = n
	local points = { { map = map, x = from.x, y = from.y, z = from.z } }
	for i = 2, #drawn - 1 do
		local j = drawn[i]
		grid(st, P.k[j])
		points[#points + 1] = {
			map = map,
			x = x0 + (P.x[j] + 0.5) * cs,
			y = y0 + (P.y[j] + 0.5) * cs,
			z = st.z[P.k[j]][P.n[j] + 1],
		}
	end
	points[#points + 1] = { map = map, x = to.x, y = to.y, z = to.z }
	local wetYards = 0
	for i = 2, #points do
		local p, q = drawn[i - 1], drawn[i]
		-- A segment to or from an end node's own centre is as wet as that node.
		local wet = q > p and (P.w[q] - P.w[p]) / (q - p) or P.w[q] - (P.w[q - 1] or 0)
		local length = sqrt((points[i].x - points[i - 1].x) ^ 2 + (points[i].y - points[i - 1].y) ^ 2)
		wetYards = wetYards + length * wet
	end
	points.wet = wetYards
	-- Smoothing only changes drawing: planning and FindMany use the same hazard-selected graph route and real cost.
	return points, cost
end

-- Lazy terminal-node connections let nearby targets settle without first searching every faraway endpoint.
-- One sliced Dijkstra owns the heap swap and frontier locals across endpoint searches
local function runMany(map, from, targets, waterWalking, reverse, job, hz)
	local costs = job and job.costs or {}
	local function failed(reason)
		for i = 1, #targets do
			costs[i] = false
		end
		return costs, reason
	end
	local st = State(map)
	if not st then
		return failed("nodata")
	end
	local sk, sc, reason = pointNode(st, from)
	if not sc then
		return failed(reason)
	end
	if job then
		job.valid, job.sourceCluster, job.sourceNode = true, sk, sc
		for i, point in ipairs(targets) do
			if point.x == from.x and point.y == from.y then
				local k, node = pointNode(st, point)
				if k == sk and node == sc then
					costs[i] = 0
					job.revision = job.revision + 1
				end
			end
		end
		-- Publish endpoint validity before doing local Dijkstra work. Invalid goals and co-located
		-- transfers can then settle without launching speculative walks across the continent.
		if job.progress then
			yield()
		end
	end
	-- Resolve a short dock/flight-master connector on its own. FindMany shares one frontier among its targets, so a
	-- single target cannot remove hazard weights from the rest of that frontier.
	if hz and hz.ConnectorWalk then
		for i, point in ipairs(targets) do
			if costs[i] == nil and hz.ConnectorWalk(from, point) then
				local cost = run(map, from, point, waterWalking, true, nil)
				if cost then
					costs[i] = cost
					if job then
						job.revision = job.revision + 1
					end
				end
			end
		end
	end
	local swim, cost2 = waterWalking and 1 or st.swim, waterWalking and 2 or 1
	local starts, source = connectPoint(st, swim, sk, sc, from.z)
	local clusters, links, dist, real, closed, left = {}, {}, {}, {}, {}, #targets
	for i, point in ipairs(targets) do
		local k = locate(st, point.x, point.y)
		if costs[i] ~= nil then
			left = left - 1
		elseif k then
			clusters[k] = clusters[k] or {}
			clusters[k][#clusters[k] + 1] = i
		else
			costs[i], left = false, left - 1
		end
	end
	hn = 0
	local function relax(id, cost, realCost)
		if not dist[id] or cost < dist[id] then
			dist[id], real[id] = cost, realCost
			push(cost, id)
		end
	end
	local function prepare(k)
		local list = clusters[k]
		if not list then
			return
		end
		clusters[k] = nil
		-- Local searches need their own heap, including across a yield midway through a connection.
		local keys, values, size = hk, hv, hn
		hk, hv, hn = {}, {}, 0
		local direct, ends = {}, {}
		for _, i in ipairs(list) do
			local _, node = pointNode(st, targets[i])
			if node then
				local goals
				goals, ends[i] = connectPoint(st, swim, k, node, targets[i].z)
				for _, a in ipairs(k == sk and starts or {}) do
					for _, b in ipairs(goals) do
						-- Both trees search outward from their endpoint; a reverse batch walks to the source.
						local first, last, tree = a.node, b.node, a.tree
						if reverse then
							first, last, tree = b.node, a.node, b.tree
						end
						local cost
						if first == last then
							cost = 0
						elseif tree and reached(tree, last) then
							cost = tree.g[last + 1]
						elseif search(st, k, swim, first, trees.R, last) then
							cost = trees.R.g[last + 1]
						end
						if cost and (not direct[i] or cost < direct[i]) then
							direct[i] = cost
						end
					end
				end
			else
				costs[i], left = false, left - 1
				if job then
					job.revision = job.revision + 1
				end
			end
		end
		hk, hv, hn = keys, values, size
		for i, cost in pairs(direct) do
			relax(-i, cost, cost)
		end
		for i, edges in pairs(ends) do
			for id, cost in pairs(edges) do
				links[id] = links[id] or {}
				local joined = links[id]
				joined[#joined + 1], joined[#joined + 2], joined[#joined + 3] = -i, cost, cost
			end
		end
	end
	prepare(sk)
	for id, cost in pairs(source) do
		relax(id, cost, cost)
	end
	while hn > 0 and left > 0 do
		-- Until the popped node's outgoing edges are relaxed, its key still bounds the frontier.
		if job then
			job.radius = hk[1]
		end
		local u = pop()
		if not closed[u] then
			closed[u] = true
			if u < 0 then
				costs[-u], left = real[u], left - 1
				if job then
					job.revision = job.revision + 1
				end
			else
				local k = floor(u / 4096)
				prepare(k)
				local ends = links[u]
				for i = 1, ends and #ends or 0, 3 do
					relax(ends[i], dist[u] + ends[i + 1], real[u] + ends[i + 2])
				end
				nodesOf(st, k)
				local adj = adjacent(st, u)
				for e = 1, #adj, 3 do
					local v = adj[e]
					if not closed[v] then
						local yards = adj[e + cost2]
						local factor = hz and hazard(st, hz, u, v) or 1
						relax(v, dist[u] + yards * factor, real[u] + yards)
					end
				end
			end
		end
		if job then
			job.radius = hn > 0 and hk[1] or huge
		end
		tick()
	end
	for i = 1, #targets do
		if costs[i] == nil then
			costs[i] = false
		end
	end
	return costs
end

-- Eight-direction grid distance is a lower bound even across clusters. Costs omit snapping and height
-- and round each abstract edge to yards. Each endpoint can snap
-- SNAP cells and then move SNAP more off a ledge; each nonzero grid step is at least cs before rounding.
-- This bound is in running yards for both water modes, before the planner divides by walkSpeed.
---@param map number
---@param from SPFPoint
---@param to SPFPoint
---@return number
function Path.LowerBound(map, from, to)
	---@type SPFNavData?
	local D = GatherLiteGroundPathData and GatherLiteGroundPathData[map]
	-- Unloaded maps need no synchronous addon load just to publish an admissible preview.
	if not D then
		return 0
	end
	local cs = TILE / D.cells
	local dx, dy = abs(from.x - to.x), abs(from.y - to.y)
	local gap = dx > dy and dx + (SQRT2 - 1) * dy or dy + (SQRT2 - 1) * dx
	return max(0, gap - (4 * SNAP + 1) * SQRT2 * cs) * max(0, 1 - 0.5 / cs)
end

---@param job SPFPathJob?
---@param point SPFPoint
---@return boolean
function Path.ReuseMany(job, point)
	if not job or job.map ~= point.map or not job.sourceNode then
		return false
	end
	local from = job.from
	if (from.x - point.x) ^ 2 + (from.y - point.y) ^ 2 > 9 or (from.z and point.z and abs(from.z - point.z) > ZTOL) then
		return false
	end
	local st = State(job.map)
	local k, node = pointNode(st, point)
	return k == job.sourceCluster and node == job.sourceNode
end

local function start(job)
	if job.notify then
		local owner = job.owner
		if not owner.cancelled then
			job.notify(job.points, job.cost, owner)
		end
		return
	end
	Expansions(0)
	if job.targets then
		return runMany(job.map, job.from, job.targets, job.waterWalking, job.reverse, job, job.hazards)
	end
	return run(job.map, job.from, job.to, job.waterWalking, job.costOnly, job.hazards)
end

local spare
local function scratch(saved)
	local previous = { hk, hv, hn, trees, ag, areal, apar, astamp, aclosed, agen }
	if not saved and spare then
		saved, spare = spare, nil
		saved[3] = 0
	end
	if saved then
		hk, hv, hn, trees = saved[1], saved[2], saved[3], saved[4]
		ag, areal, apar, astamp, aclosed, agen = saved[5], saved[6], saved[7], saved[8], saved[9], saved[10]
	else
		hk, hv, hn = {}, {}, 0
		trees = { S = Tree(), G = Tree(), R = Tree() }
		ag, areal, apar, astamp, aclosed, agen = {}, {}, {}, {}, {}, 0
	end
	return previous
end

-- Synchronous search, for tests and tools. Returns points, cost (or nil, reason) and the expansion count.
---@param map number
---@param from SPFPoint
---@param to SPFPoint
---@param waterWalking? boolean
---@param hazards? SPFHazards
function Path.FindSync(map, from, to, waterWalking, hazards)
	Deadline(huge)
	local job = { map = map, from = from, to = to, waterWalking = waterWalking, hazards = hazards }
	local co = coroutine.create(start)
	local saved = scratch()
	local ok, points, cost = coroutine.resume(co, job)
	scratch(saved)
	if not ok then
		error(points)
	end
	return points, cost, Expansions()
end

-- Costs indexed like targets, false for unreachable/off-mesh points; no geometry is built. reverse returns
-- target -> from costs, including the directed same-cluster water step. The shipped abstract edges are symmetric.
---@param map number
---@param from SPFPoint
---@param targets SPFPoint[]
---@param waterWalking? boolean
---@param reverse? boolean
---@param hazards? SPFHazards
function Path.FindManySync(map, from, targets, waterWalking, reverse, hazards)
	Deadline(huge)
	Expansions(0)
	local saved = scratch()
	local costs, reason = runMany(map, from, targets, waterWalking, reverse, nil, hazards)
	scratch(saved)
	return costs, reason, Expansions()
end

-- PathJobs.lua resumes start in a coroutine between scratch swaps; a finished search's scratch is kept as spare.
---@class SPFPathSearch
ns.PathSearch = {
	start = start,
	scratch = scratch,
	Spare = function(saved)
		spare = saved
	end,
}
