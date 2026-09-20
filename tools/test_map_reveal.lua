-- Validate reveal metadata and rendering without changing game exploration flags.
local addon={}
assert(loadfile("scripts/maps/reveal-data.lua"))("GatherLite",addon)
local artCount,overlayCount=0,0
for art,records in pairs(addon.MapRevealData) do
    assert(type(art)=="number")
    artCount=artCount+1
    for key,files in pairs(records) do
        local w,h,x,y=key:match("^(%d+):(%d+):(%d+):(%d+)$")
        w,h,x,y=tonumber(w),tonumber(h),tonumber(x),tonumber(y)
        assert(w and h and x and y and w>0 and h>0)
        local count=0
        for file in files:gmatch("%d+") do assert(tonumber(file)>0); count=count+1 end
        assert(count>=math.ceil(w/256)*math.ceil(h/256),"missing reveal tile: "..art..":"..key)
        overlayCount=overlayCount+1
    end
end
assert(artCount==44 and addon.MapRevealData[2159] and addon.MapRevealData[2153])
local art,explored=1,{}
C_Map={
    GetMapArtID=function() return art end,
    GetMapArtLayers=function() return {{tileWidth=256,tileHeight=256}} end,
}
C_MapExplorationInfo={GetExploredMapTextures=function() return explored end}
local function texture()
    local t={}
    function t:ClearAllPoints() self.point=nil end
    function t:SetPoint(...) self.point={...} end
    function t:SetSize(w,h) self.width,self.height=w,h end
    function t:SetTexCoord(...) self.uv={...} end
    function t:SetTexture(file) self.file=file end
    function t:SetDrawLayer(layer,level) self.layer,self.level=layer,level end
    function t:SetVertexColor(...) self.color={...} end
    function t:SetAlpha(a) self.alpha=a end
    function t:Show() self.shown=true end
    return t
end
local pool={textures={}}
function pool:Acquire() local t=texture(); table.insert(self.textures,t); return t end
local map={masked=0}
function map:GetMapID() return 1418 end
function map:GetCanvasContainer() return {GetCurrentLayerIndex=function() return 1 end} end
function map:AddMaskableTexture() self.masked=self.masked+1 end
local pin={overlayTexturePool=pool,textureLoadGroup={count=0},refreshes=0}
function pin:GetMap() return map end
function pin:RefreshOverlays() self.refreshes=self.refreshes+1; self.overlayTexturePool.textures={} end
function pin.textureLoadGroup:AddTexture() self.count=self.count+1 end
function hooksecurefunc(obj,key,fn)
    local original=obj[key]
    obj[key]=function(...) original(...); fn(...) end
end
addon.MapRevealData[1]={["300:270:10:20"]="1, 2, 3, 4"}
assert(loadfile("scripts/maps/reveal.lua"))("GatherLite",addon)
addon.MapReveal.Attach({pin=pin})
assert(#pool.textures==4 and pin.textureLoadGroup.count==4)
local edge=pool.textures[4]
assert(edge.file==4 and edge.width==44 and edge.height==14)
assert(edge.uv[2]==44/64 and edge.uv[4]==14/16,"partial tiles need power-of-two UVs")
assert(edge.point[2]==266 and edge.point[3]==-276,"wrong row-major tile placement")
assert(edge.color[1]==1 and edge.alpha==1 and edge.level==-1,"revealed terrain tinted or above explored art")
addon.MapReveal.Attach({pin=pin})
assert(pin.refreshes==1,"duplicate reveal hook")
pin:RefreshOverlays(false)
assert(#pool.textures==4 and pin.textureLoadGroup.count==4,"reused texture pool grows on refresh")
explored={{textureWidth=300,textureHeight=270,offsetX=10,offsetY=20}}
pin:RefreshOverlays(true)
assert(#pool.textures==0,"already explored terrain drawn twice")
explored={}; art=999999
pin:RefreshOverlays(true); assert(#pool.textures==0,"wrong art ID reused old overlays")
art=2159
pin:RefreshOverlays(true); assert(#pool.textures>14,"Badlands reveal data missing")
print("Map reveal checks passed: "..artCount.." maps, "..overlayCount.." overlays; partial tiles, explored deduplication, hooks and cleanup")
