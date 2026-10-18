-- Terrain planner regressions. An optional first argument supplies decoded,
-- real bundled terrain generated offline by test_navigation.py.
unpack = unpack or table.unpack
local addon = {}
local function load(path) assert(loadfile(path))("GatherLite", addon) end
LibStub = function()
    return {GetZoneCoordinatesFromWorldInstance=function(_,x,y) return x/20000,y/20000 end}
end
C_EncodingUtil = {DecodeBase64=function() error("fixture should already be decoded") end,
    DecompressString=function() error("fixture should already be decoded") end}
Enum = {CompressionMethod={Zlib=1}}
load("plugins/routes/planner.lua")
load("plugins/routes/navigation/bootstrap.lua")
load("plugins/routes/navigation/vendor/Routing/PathGrid.lua")
load("plugins/routes/navigation/vendor/Routing/Path.lua")
load("plugins/routes/navigation/ground.lua")
local G = addon.GroundNavigation
do
    -- Terrain costs must change the stop order even when the inexpensive
    -- walking links are the diagonals of the map-coordinate square.
    local points={{x=0,y=0},{x=1000,y=0},{x=1000,y=1000},{x=0,y=1000}}
    local indices={}
    for i,p in ipairs(points) do indices[p]=i end
    local costs={{0,100,10,10},{100,0,10,10},{10,10,0,100},{10,10,100,0}}
    local optimized=assert(addon.RoutePlanner.Build(points,nil,nil,{prepared=true,
        cost=function(a,b) return costs[indices[a]][indices[b]] end}))
    assert(optimized.length==40,"circuit ordering still optimizes straight-line distances")
end
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function symbol(i) return alphabet:sub(i+1,i+1) end
local function terrain(opening)
    G:Release()
    local grid, count = {}, 0
    for x=0,7 do for y=0,7 do
        local blocked = x==3 and (not opening or y~=7)
        grid[#grid+1] = symbol(blocked and 0 or 16)
        if not blocked then count=count+1 end
    end end
    GatherLiteGroundPathData = {[0]={cx0=0,cy0=0,nx=1,ny=1,cells=8,swim=3,zstep=2,
        grid={table.concat(grid)},height={string.rep(symbol(23),count)},floor={},graph={"AA"}}}
end
local cs = (1600/3)/8
local function point(x,y)
    return {x=(y+.5)*cs,y=(x+.5)*cs,instance=0,u=y/8,v=x/8}
end
local function build(points)
    local result, reason
    local co = coroutine.create(function()
        result,reason = G:Build(points,1429,function() G.Path.Checkpoint() end,function() end)
    end)
    local slices=0
    repeat
        G:BeginSlice()
        local ok,err = coroutine.resume(co)
        G:EndSlice()
        assert(ok,err)
        slices=slices+1
        assert(slices<100000,"terrain calculation failed to finish")
    until coroutine.status(co)=="dead"
    return result,reason,slices
end

terrain(true)
local route = assert(build({point(1,1),point(5,1),point(6,2)}))
assert(route.terrainAware and #route.points==3 and #route.geometry>4)
assert(route.length>1000,"terrain detour was replaced by a short straight-line tour")
local crossed=false
for i=2,#route.geometry do
    local a,b = route.geometry[i-1],route.geometry[i]
    for t=0,100 do
        local x=a.y+(b.y-a.y)*t/100
        local y=a.x+(b.x-a.x)*t/100
        if math.floor(x/cs)==3 then
            assert(math.floor(y/cs)==7,"drawn ground path crosses the blocked wall")
            crossed=true
        end
    end
end
assert(crossed,"route never used the walkable opening")
local first,last=route.geometry[1],route.geometry[#route.geometry]
assert(first.x==last.x and first.y==last.y,"return leg must also follow terrain")

terrain(false)
local disconnected,why = build({point(1,1),point(5,1),point(6,2)})
assert(not disconnected and why=="unreachable","disconnected terrain must not fall back to straight lines")
route=assert(build({point(1,1),point(1,5),point(2,3),point(5,1)}))
assert(#route.points==3 and route.omitted==1,"isolated stops must be omitted from the circuit")
assert(not G:Endpoint(point(3,2)),"an off-mesh stop must not be snapped across a barrier")
local state=G.PathGrid.State(0)
local valid=point(1,1)
local k,cell=G.PathGrid.locate(state,valid.y,valid.x)
G.PathGrid.grid(state,k)
state.at[k][-(cell+1)]=64
assert(not G:Endpoint(valid),"an unknown floor must not be guessed")

G:Release()
assert(G.PathGrid.State(0)~=state and G.PathGrid.State(0).decoded==0,
    "cancellation must release decoded grids and search caches")
GatherLiteGroundPathData={}
local missing,missingWhy=build({point(1,1),point(5,1),point(6,2)})
assert(not missing and missingWhy=="nodata")
C_EncodingUtil=nil
local unavailable,unavailableWhy=build({point(1,1),point(5,1),point(6,2)})
assert(not unavailable and unavailableWhy=="unavailable")
C_EncodingUtil={DecodeBase64=function() end,DecompressString=function() end}

-- A yielding worker can be abandoned and reset without publishing a route or
-- retaining search scratch that changes the next worker's result.
terrain(true)
local oldClock=G.Path.clock
local now=0
G.Path.clock=function() now=now+1; return now end
local cancelled=coroutine.create(function()
    G:Build({point(1,1),point(5,1),point(6,2)},1429,function() G.Path.Checkpoint() end,function() end)
    error("cancelled route was resumed")
end)
G:BeginSlice(); assert(coroutine.resume(cancelled)); G:EndSlice()
assert(coroutine.status(cancelled)=="suspended","search must yield to its frame budget")
G:Release(); cancelled=nil
G.Path.clock=oldClock
route=assert(build({point(1,1),point(5,1),point(6,2)}))
assert(route.terrainAware)
print("Ground routing passed: terrain detours, closure, disconnected stops, strict endpoints, frame budgets and cancellation")

if arg and arg[1] then
    G:Release()
    assert(loadfile(arg[1]))()
    -- Elwynn's pinned UI-map assignment, converted through the same HBD axes.
    local function elwynn(u,v)
        return {x=1535.4166259766-u*3470.8332519532,
            y=-7939.5830078125-v*2314.5830078125,instance=0,u=u,v=v}
    end
    local points={elwynn(.43,.65),elwynn(.49,.66),elwynn(.48,.60),elwynn(.38,.61)}
    local real,reason,slices=build(points)
    assert(real,reason)
    assert(real.terrainAware and #real.points>=3 and #real.geometry>#real.points)
    assert(real.length>0 and slices>1,"real terrain search should be sliced across frames")
    print(string.format("Bundled Elwynn terrain passed: %d stops, %d geometry points, %d frame slices, %.0f yards",
        #real.points,#real.geometry,slices,real.length))
    if arg[2]=="--benchmark" then
        load("plugins/database/data/forever.lua")
        local copper={}
        for _,id in ipairs({1731,2055,3763,103713,103714}) do
            local coords=(addon.predefined[id] or {})[1429] or {}
            for i=1,#coords,2 do copper[#copper+1]=elwynn(coords[i],coords[i+1]) end
        end
        local started=os.clock()
        local circuit,failure,frames=build(copper)
        assert(circuit,failure)
        assert(#circuit.points<=64 and #circuit.points>=3)
        print(string.format("Elwynn Copper benchmark: %d locations, %d stops, %d path points, %d slices, %.3f CPU seconds",
            #copper,#circuit.points,#circuit.geometry,frames,os.clock()-started))
    end
end
