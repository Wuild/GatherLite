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

local defaultCoords = { 0, 1, 0, 1 }
local function updateCoord(self)
    local coords = defaultCoords
    local deltaX, deltaY = 0, 0
    if not self:GetParent().isMouseDown then
        deltaX = (coords[2] - coords[1]) * 0.05
        deltaY = (coords[4] - coords[3]) * 0.05
    end
    self:SetTexCoord(coords[1] + deltaX, coords[2] - deltaX, coords[3] + deltaY, coords[4] - deltaY)
end

local function getAnchors(frame)
    local x, y = frame:GetCenter()
    if not x or not y then
        return "CENTER"
    end
    local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or ""
    local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
    return vhalf .. hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
end

local tooltip = CreateFrame("GameTooltip", "GatherLiteIconTooltip", UIParent, "GameTooltipTemplate")
local dropDown = CreateFrame("Frame", "GatherLiteWorldmapMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(dropDown, GatherLite:MinimapContextMenu(), "MENU")

local function createButton()
    local button = CreateFrame("Button", "GatherLiteWorldmapButton", WorldMapFrame)
    button.dataObject = self
    button:SetFrameStrata("MEDIUM")
    button:SetSize(31, 31)
    button:SetFrameLevel(8)
    button:RegisterForClicks("anyUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture(136477) --"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
    button:SetPoint('BOTTOMLEFT', 20, 40);

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture(136430) --"Interface\\Minimap\\MiniMap-TrackingBorder"
    overlay:SetPoint("TOPLEFT")
    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture(136467) --"Interface\\Minimap\\UI-Minimap-Background"
    background:SetPoint("TOPLEFT", 7, -5)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17)
    icon:SetTexture("Interface\\Icons\\inv_misc_spyglass_02")
    icon:SetPoint("TOPLEFT", 7, -6)

    local r, g, b = icon:GetVertexColor()
    icon:SetVertexColor(r, g, b)

    icon.UpdateCoord = updateCoord
    icon:UpdateCoord()

    button:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
        elseif button == "RightButton" then
            CloseDropDownMenus(1)
            InterfaceOptionsFrame_OpenToCategory("GatherLite")
            InterfaceOptionsFrame_OpenToCategory("GatherLite") -- run it again to set the correct tab
        end
    end);

    button:SetScript("OnEnter", function(self)
        tooltip:SetOwner(self, "ANCHOR_NONE")
        tooltip:SetPoint(getAnchors(self))
        tooltip:SetText(_GatherLite.name .. " |cFF00FF00" .. _GatherLite.version .. "|r");
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('mining'), "white"),
            GatherLite:tablelength(GatherLite.db.global.nodes.mining));
        tooltip:AddDoubleLine(GatherLite:Colorize(GatherLite:translate('herbalism'), "white"),
            GatherLite:tablelength(GatherLite.db.global.nodes.herbalism));

        if GatherLite.db.global.debug.enabled then
            tooltip:AddLine(" ");
            tooltip:AddLine("             -- Debugging --             ");
            tooltip:AddDoubleLine(GatherLite:Colorize("Used frames", "white"), GatherLite:tablelength(GFrame.usedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("Unused frames", "white"),
                GatherLite:tablelength(GFrame.unusedFrames));
            tooltip:AddDoubleLine(GatherLite:Colorize("All frames", "white"), GatherLite:tablelength(GFrame.allFrames));
        end

        tooltip:AddLine(" ");
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.left_click"), 'gray') ..
            ": " .. GatherLite:translate("settings.minimap.left_click_text"));
        tooltip:AddLine(GatherLite:Colorize(GatherLite:translate("settings.minimap.right_click"), 'gray') ..
            ": " .. GatherLite:translate("settings.minimap.right_click_text"));
        tooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        tooltip:Hide()
    end)
end

-- Module setup
source.setup = function()
    GatherLite:debug(_GatherLite.DEBUG_DEFAULT, "Loaded worldmap module")

    local frame = CreateFrame("Frame")

    createButton();

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

                if not (worldmapID == 1415) then
                    GatherLite:debug(_GatherLite.DEBUG_DEFAULT,
                        worldmapID .. ":\"" .. C_Map.GetMapInfo(worldmapID).name .. "\",")
                    --local continent = GetCurrentMapContinent();

                    local instanceId = -1;
                    if C_Map.GetMapInfo(worldmapID).parentMapID == 1415 then
                        instanceId = 0;
                    elseif C_Map.GetMapInfo(worldmapID).parentMapID == 1414 then
                        instanceId = 1;
                    elseif C_Map.GetMapInfo(worldmapID).parentMapID == 1945 then
                        instanceId = 530;
                    elseif C_Map.GetMapInfo(worldmapID).parentMapID == 113 then
                        instanceId = 571;
                    else
                        --print(C_Map.GetMapInfo(worldmapID).parentMapID)
                    end

                    GatherLite.db.global.maps[worldmapID] = {
                        id = worldmapID,
                        name = C_Map.GetMapInfo(worldmapID).name,
                        instance =
                            instanceId
                    };
                end
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
