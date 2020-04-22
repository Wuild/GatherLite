local name, _GatherLite = ...
local MAJOR, MINOR = "GatherLiteFrame", 9
assert(LibStub, MAJOR .. " requires LibStub")

local GatherLiteFrame, oldversion = LibStub:NewLibrary(MAJOR, MINOR)
if not GatherLiteFrame then
    return
end

local Pins = LibStub("HereBeDragons-Pins-2.0");

GatherLiteFrame.numberOfFrames = 0;
GatherLiteFrame.unusedFrames = {}
GatherLiteFrame.usedFrames = {}
GatherLiteFrame.allFrames = {}

local _frame = {}

function GatherLiteFrame:getFrame(type)
    local returnFrame = tremove(GatherLiteFrame.unusedFrames)
    if returnFrame and returnFrame.frameId and GatherLiteFrame.usedFrames[returnFrame.frameId] then
        returnFrame = nil
    end
    if not returnFrame then
        returnFrame = GatherLiteFrame:createFrame()
    end

    returnFrame.type = type;

    GatherLiteFrame.usedFrames[returnFrame.frameId] = returnFrame

    GatherLite:debug(_GatherLite.DEBUG_FRAME, "[GatherLiteFrame:getFrame]")

    return returnFrame
end

function GatherLiteFrame:createFrame()
    GatherLiteFrame.numberOfFrames = GatherLiteFrame.numberOfFrames + 1

    local newFrame = GatherLiteFrame:newFrame(GatherLiteFrame.numberOfFrames)
    tinsert(GatherLiteFrame.allFrames, newFrame)

    GatherLite:debug(_GatherLite.DEBUG_FRAME, "[GatherLiteFrame:createFrame]")

    return newFrame
end

function GatherLiteFrame:newFrame(frameId)
    local newFrame = CreateFrame("Button", "GatherLite" .. frameId, nil)
    newFrame.frameId = frameId;

    if MBB_Ignore then
        table.insert(MBB_Ignore, "GatherLite" .. frameId)
    end

    newFrame:SetFrameStrata("TOOLTIP");
    newFrame:SetWidth(16) -- Set these to whatever height/width is needed
    newFrame:SetHeight(16) -- for your Texture
    newFrame:SetPoint("CENTER", -8, -8)
    newFrame:EnableMouse(true)

    local texture = newFrame:CreateTexture(nil, "TOOLTIP", nil, 0)
    texture:SetWidth(16)
    texture:SetHeight(16)
    texture:SetAllPoints(newFrame)
    texture:SetTexelSnappingBias(0)
    texture:SetSnapToPixelGrid(false)

    newFrame.texture = texture;

    newFrame.Unload = _frame.unload

    newFrame:Hide()

    GatherLite:debug(_GatherLite.DEBUG_FRAME, "[GatherLiteFrame:newFrame]")

    return newFrame
end

function GatherLiteFrame:recycleFrame(frame)
    GatherLiteFrame.usedFrames[frame.frameId] = nil
    tinsert(GatherLiteFrame.unusedFrames, frame)

    GatherLite:debug(_GatherLite.DEBUG_FRAME, "[GatherLiteFrame:recycleFrame]")
end

function _frame:unload()
    self:SetFrameStrata("TOOLTIP");
    self:SetFrameLevel(0);

    self:SetScript("OnUpdate", nil)
    self:SetScript("OnShow", nil)
    self:SetScript("OnHide", nil)
    self.texture:SetVertexColor(1, 1, 1, 1)

    if self.type == "minimap" and self.node.loaded then
        self.node.loaded = false
    end

    if self.type == "worldmap" and self.node.loadedWorldmap then
        self.node.loadedWorldmap = false
    end

    self.node = {}
    self.type = nil
    self:Hide()

    Pins:RemoveMinimapIcon(_GatherLite.name, self)
    Pins:RemoveWorldMapIcon(_GatherLite.name, self)
    GatherLiteFrame:recycleFrame(self)
end