local name, _GatherLite = ...;

local Frames = LibStub("GatherLiteFrame");
local Pins = LibStub("HereBeDragons-Pins-2.0");

local SourceName = "worldmap"

GatherLite.modules[SourceName] = {}
local source = GatherLite.modules[SourceName]

local worldmapOpen = false;
local worldmapID = nil;

-- Filter used on the worldmap
local WorldmapFilter = function(node)
    if not GatherLite.db.char.worldmap.enabled then
        return false
    end

    -- check if were tracking the type of node
    if not GatherLite.db.char.tracking[node.type] then
        return false
    end

    -- check if were using the predefined database
    if node.predefined and not GatherLite.db.global.usePredefined then
        return false
    end

    -- check if the node type is should be ignored.
    if GatherLite:IsIgnored(node.object) then
        return false
    end
    return true;
end


-- Get nodes for current map id
local function WorldmapNodes(list, mapID, filter)
    return GatherLite:Filter(list, function(node)
        return node.mapID == mapID and filter(node);
    end);
end

-- Unload worldmap nodes
local function UnloadWorldmap()
    GatherLite:forEach(Frames.usedFrames, function(frame)
        if frame.type == "worldmap" then
            frame.node.loadedWorldmap = false;
            GatherLite:SendMessage("nodes:unload", frame.node)
            frame:Unload()
        end
    end)
end

-- Create worldmap node
local function CreateWorldmapNode(node)
    if not GatherLite:IsLoaded() then
        return
    end

    local object = GatherLite:GetNodeObject(node.object)
    if not object then
        return nil
    end

    local f = Frames:getFrame("worldmap");
    f:SetAlpha(GatherLite.db.char.worldmap.opacity);
    f:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    f.texture:SetTexture(object.icon)
    f.texture:SetSize(GatherLite.db.char.worldmap.size, GatherLite.db.char.worldmap.size)
    --f:SetBackdropColor(1, 0, 0, 1);

    f.node = node;
    f.object = object
    f.type = "worldmap";
    f.TimeSinceLastUpdate = 0

    f:SetFrameStrata("TOOLTIP");
    --f:SetFrameLevel(0);

    f:SetScript("OnUpdate", nil)

    f:SetScript("OnEnter", function(self)
        GatherLite:showTooltip(self);
        --GatherLite:debug(_GatherLite.DEBUG_NODE, self.node.instance)
    end)
    f:SetScript("OnLeave", function()
        GatherLite:hideTooltip()
    end)

    if not node.posX and not node.posY then
        GatherLite:debug(_GatherLite.DEBUG_NODE, node.object, node.posX, node.posY)
    else
        Pins:AddWorldMapIconMap(_GatherLite.name, f, node.mapID, node.posX, node.posY);
    end

    GatherLite:SendMessage("nodes:load")

    return f;
end

-- Load worldmap nodes
local function LoadWorldmap()
    if not GatherLite:IsLoaded() then
        return
    end

    GatherLite:forEach(Frames.usedFrames, function(frame)
        if frame.type == "worldmap" and frame.node.loadedWorldmap then
            frame.node.loadedWorldmap = false;
            frame:Unload()
        end
    end);

    if worldmapOpen and worldmapID then
        for key, node in pairs(WorldmapNodes(_GatherLite.nodes["mining"], worldmapID, WorldmapFilter)) do
            _GatherLite.nodes["mining"][key].loadedWorldmap = true
            CreateWorldmapNode(_GatherLite.nodes["mining"][key])
        end

        for key, node in pairs(WorldmapNodes(_GatherLite.nodes["herbalism"], worldmapID, WorldmapFilter)) do
            _GatherLite.nodes["herbalism"][key].loadedWorldmap = true
            CreateWorldmapNode(_GatherLite.nodes["herbalism"][key])
        end

        for key, node in pairs(WorldmapNodes(_GatherLite.nodes["containers"], worldmapID, WorldmapFilter)) do
            _GatherLite.nodes["containers"][key].loadedWorldmap = true
            CreateWorldmapNode(_GatherLite.nodes["containers"][key])
        end

        for key, node in pairs(WorldmapNodes(_GatherLite.nodes["fishing"], worldmapID, WorldmapFilter)) do
            _GatherLite.nodes["fishing"][key].loadedWorldmap = true
            CreateWorldmapNode(_GatherLite.nodes["fishing"][key])
        end
    end
end

-- Reset worldmap nodes
local function ResetWorldmap()
    UnloadWorldmap()
    LoadWorldmap()
end

-- Module setup
source.setup = function()
    GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Loaded worldmap module")

    local frame = CreateFrame("Frame")

    frame:SetScript("OnUpdate", function()
        if WorldMapFrame:IsVisible() and not worldmapOpen then
            worldmapOpen = true;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "open worldmap", worldmapID)
            ResetWorldmap()
        end

        if not WorldMapFrame:IsVisible() and worldmapOpen then
            worldmapOpen = false;
            GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "close worldmap")
            UnloadWorldmap()
        end

        if worldmapOpen then
            if worldmapID ~= WorldMapFrame.mapID then
                worldmapID = WorldMapFrame.mapID;
                ResetWorldmap()
            end
        end
    end)

    GatherLite:On("settings:update", function()
        if worldmapOpen then
            ResetWorldmap()
        end
    end);
end

source.reset = ResetWorldmap
source.load = LoadWorldmap
source.unload = UnloadWorldmap