local _, addon = ...
local Pins = LibStub("HereBeDragons-Pins-2.0")
local HBD = LibStub("HereBeDragons-2.0")
local Fishing = { visible=true, frames={} }
addon.Fishing = Fishing
GatherLite.plugins.Fishing = Fishing

-- Representatives are original catch coordinates, chosen independently of zoom/pan.
function Fishing:Cluster(cells,x,y,u,v)
    local cx,cy=math.floor(x),math.floor(y)
    for dx=-1,1 do
        for dy=-1,1 do
            for _,candidate in ipairs(cells[(cx+dx)..":"..(cy+dy)] or {}) do
                if (candidate.x-x)^2+(candidate.y-y)^2<1 then return candidate,false end
            end
        end
    end
    local group={u=u,v=v,x=x,y=y,fish={},ids={}}
    local key=cx..":"..cy
    cells[key]=cells[key] or {}
    cells[key][#cells[key]+1]=group
    return group,true
end
function Fishing:ThinLocations(locations)
    local result={}
    for mapID,points in pairs(locations) do
        local cells={}
        result[mapID]={}
        for _,point in ipairs(points) do
            local _,fresh=self:Cluster(cells,point.u*1000/34,point.v*668/34,point.u,point.v)
            if fresh then result[mapID][#result[mapID]+1]=point end
        end
    end
    return result
end

function Fishing:ClearPins()
    Pins:RemoveAllWorldMapIcons(self)
    Pins:RemoveAllMinimapIcons(self)
    for _,frame in ipairs(self.frames) do frame:Hide() end
end
function Fishing:Select(object)
    self.object=object
    self.visible=true
    GatherLite.db.char.fishItem=object and object.itemID or nil
    self:Refresh()
end
function Fishing:Refresh()
    self:ClearPins()
    local selected=self.object
    if selected and not self.visible then return end
    local worldOptions,miniOptions=GatherLite.db.char.worldmap,GatherLite.db.char.minimap
    -- Explicit searches show the chosen fish. Otherwise use each map's Fishing filter.
    local reference=selected or GatherLite.db.global.usePredefined
    local worldEnabled=reference and worldOptions.enabled and
        (selected or GatherLite:GetNodeTracking("worldmap","fishing"))
    local miniEnabled=reference and miniOptions.enabled and
        (selected or GatherLite:GetNodeTracking("minimap","fishing"))
    if not worldEnabled and not miniEnabled then return end
    local worldMap=WorldMapFrame and WorldMapFrame:IsShown() and WorldMapFrame:GetMapID()
    local worldInfo=worldMap and C_Map.GetMapInfo(worldMap)
    local _,_,playerMap=HBD:GetPlayerZonePosition()
    local groups={}
    local function add(fish,mapID,u,v,target,x,y)
        groups[mapID]=groups[mapID] or {world={},mini={}}
        local cells=groups[mapID][target]
        local group=Fishing:Cluster(cells,x,y,u,v)
        if not group.ids[fish.itemID] then
            group.ids[fish.itemID]=true
            group.fish[#group.fish+1]=fish
        end
    end
    for _,fish in ipairs(selected and {selected} or addon.fishDB) do
        for mapID,coords in pairs(fish.maps) do
            local info=C_Map.GetMapInfo(mapID)
            local showWorld=worldEnabled and worldInfo and worldInfo.mapType==3 and (selected or worldMap==mapID or
                (worldInfo and worldInfo.mapType<3 and worldOptions.continent))
            local showMini=miniEnabled and mapID==playerMap
            if info and info.mapType==3 and (showWorld or showMini) then
                for i=1,#coords,2 do
                    local u,v=coords[i],coords[i+1]
                    -- Fixed geographic catch areas; zoom never picks a different anchor.
                    if showWorld then add(fish,mapID,u,v,"world",u*1000/34,v*668/34) end
                    if showMini then
                        local x,y=HBD:GetWorldCoordinatesFromZone(u,v,mapID)
                        -- 60-yard catch areas keep the minimap useful at walking scale.
                        if x and y then add(fish,mapID,u,v,"mini",x/60,y/60) end
                    end
                end
            end
        end
    end
    local count=0
    local function pin(mapID,group,mini)
        count=count+1
        local frame=self.frames[count]
        if not frame then
            frame=CreateFrame("Frame",nil,UIParent)
            frame:SetSize(16,16)
            frame:EnableMouse(false)
            frame:SetMouseMotionEnabled(true); frame:SetMouseClickEnabled(false)
            frame.icon=frame:CreateTexture(nil,"ARTWORK"); frame.icon:SetAllPoints()
            frame:SetScript("OnEnter",function(p)
                GameTooltip:SetOwner(p,"ANCHOR_RIGHT")
                GameTooltip:SetText(#p.fish==1 and p.fish[1].name or "Fishing catches")
                local info=C_Map.GetMapInfo(p.mapID)
                GameTooltip:AddLine(string.format("%s: %.1f, %.1f",info and info.name or "",p.u*100,p.v*100),1,1,1)
                if #p.fish>1 then
                    for _,fish in ipairs(p.fish) do GameTooltip:AddLine(fish.name,1,1,1) end
                end
                GameTooltip:AddLine("Reported catches nearby, not guaranteed fish spawns.",.8,.8,.8,true)
                GameTooltip:Show()
            end)
            frame:SetScript("OnLeave",function() GameTooltip:Hide() end)
            self.frames[count]=frame
        end
        frame.mapID,frame.u,frame.v,frame.fish=mapID,group.u,group.v,group.fish
        frame.icon:SetTexture(group.fish[1].icon)
        if addon.MapHover then addon.MapHover:Register(frame, not mini) end
        if mini then
            Pins:AddMinimapIconMap(self,frame,mapID,group.u,group.v,false,false)
        else
            Pins:AddWorldMapIconMap(self,frame,mapID,group.u,group.v,1)
        end
    end
    for mapID,targets in pairs(groups) do
        for target,cells in pairs(targets) do
            for _,bucket in pairs(cells) do
                for _,group in ipairs(bucket) do
                    table.sort(group.fish,function(a,b) return a.name<b.name end)
                    pin(mapID,group,target=="mini")
                end
            end
        end
    end
end
function Fishing.setup()
    GatherLite:On("settings:update",function() Fishing:Refresh() end)
    local frame,elapsedTotal,restored,lastWorld,lastPlayer=CreateFrame("Frame"),0,false
    frame:SetScript("OnUpdate",function(_,elapsed)
        if not GatherLite:IsLoaded() then return end
        local refresh=false
        if not restored then
            restored=true
            for _,fish in ipairs(addon.fishDB) do
                if fish.itemID==GatherLite.db.char.fishItem then Fishing.object=fish; break end
            end
            local _,_,player=HBD:GetPlayerZonePosition()
            lastPlayer=player
            refresh=true
        end
        -- Match gathering pins: opening, closing and browsing maps react next frame.
        local world=WorldMapFrame and WorldMapFrame:IsShown() and WorldMapFrame:GetMapID()
        if world~=lastWorld then
            lastWorld=world
            refresh=true
        end
        -- Player-zone polling stays throttled; unchanged maps never rebuild pins.
        elapsedTotal=elapsedTotal+elapsed
        if elapsedTotal>=.25 then
            elapsedTotal=0
            local _,_,player=HBD:GetPlayerZonePosition()
            if player~=lastPlayer then
                lastPlayer=player
                refresh=true
            end
        end
        if refresh then Fishing:Refresh() end
    end)
end
