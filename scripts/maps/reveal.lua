local _, addon = ...
local Reveal = {}
addon.MapReveal = Reveal

-- Blizzard stores partial edge tiles in power-of-two textures (minimum 16px).
local function fileSize(pixels, tileSize)
    if pixels == tileSize then return tileSize end
    local size = 16
    while size < pixels do size = size * 2 end
    return size
end

-- Add only missing exploration rectangles to our own native exploration pin.
-- Its pool handles release/reuse whenever the map or detail layer changes.
function Reveal.Refresh(pin, fullUpdate)
    local map = pin:GetMap()
    local mapID = map:GetMapID()
    local artID = C_Map.GetMapArtID(mapID)
    local records = artID and addon.MapRevealData[artID]
    if not records then return end
    local layers = C_Map.GetMapArtLayers(mapID)
    local layer = layers and layers[map:GetCanvasContainer():GetCurrentLayerIndex()]
    if not layer or layer.tileWidth <= 0 or layer.tileHeight <= 0 then return end
    local explored = {}
    for _, info in ipairs(C_MapExplorationInfo.GetExploredMapTextures(mapID) or {}) do
        explored[string.format("%d:%d:%d:%d", info.textureWidth, info.textureHeight, info.offsetX, info.offsetY)] = true
    end
    local keys = {}
    for key in pairs(records) do keys[#keys + 1] = key end
    table.sort(keys)
    for _, key in ipairs(keys) do
        if not explored[key] then
            local width, height, offsetX, offsetY = key:match("^(%d+):(%d+):(%d+):(%d+)$")
            width, height, offsetX, offsetY = tonumber(width), tonumber(height), tonumber(offsetX), tonumber(offsetY)
            if width and height and width > 0 and height > 0 then
                local files = {}
                for id in records[key]:gmatch("%d+") do files[#files + 1] = tonumber(id) end
                local cols, rows = math.ceil(width / layer.tileWidth), math.ceil(height / layer.tileHeight)
                for row = 0, rows - 1 do
                    for col = 0, cols - 1 do
                        local file = files[row * cols + col + 1]
                        if file then
                            local w = math.min(layer.tileWidth, width - col * layer.tileWidth)
                            local h = math.min(layer.tileHeight, height - row * layer.tileHeight)
                            local texture = pin.overlayTexturePool:Acquire()
                            map:AddMaskableTexture(texture)
                            texture:ClearAllPoints()
                            texture:SetPoint("TOPLEFT", offsetX + col * layer.tileWidth, -(offsetY + row * layer.tileHeight))
                            texture:SetSize(w, h)
                            texture:SetTexCoord(0, w / fileSize(w, layer.tileWidth), 0, h / fileSize(h, layer.tileHeight))
                            texture:SetTexture(file, nil, nil, "TRILINEAR")
                            texture:SetDrawLayer("ARTWORK", -1)
                            texture:SetVertexColor(1, 1, 1, 1)
                            texture:SetAlpha(1)
                            texture:Show()
                            if fullUpdate then pin.textureLoadGroup:AddTexture(texture) end
                        end
                    end
                end
            end
        end
    end
end

function Reveal.Attach(provider)
    local pin = provider.pin
    if not pin or pin.gatherLiteReveal then return end
    pin.gatherLiteReveal = true
    hooksecurefunc(pin, "RefreshOverlays", Reveal.Refresh)
    pin:RefreshOverlays(true)
end
