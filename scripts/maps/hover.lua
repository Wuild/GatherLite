local _, addon = ...
-- HBD icons live outside MapCanvas pin pools. Both controller cursors need
-- explicit hover dispatch; compare physical coordinates across UI scales.
local Hover={pins=setmetatable({}, {__mode="k"}),windowState={}}
addon.MapHover=Hover
local function scale(frame) return frame.GetEffectiveScale and frame:GetEffectiveScale() or 1 end
local function center(frame)
    local x,y=frame:GetCenter()
    if x and y then local s=scale(frame); return x*s,y*s end
end
local function clear(state)
    local pin=state.current
    state.current,state.data,state.object=nil,nil,nil
    if pin and GameTooltip:IsOwned(pin) then
        local leave=pin:GetScript("OnLeave")
        if leave then leave(pin) end
    end
end
function Hover:Clear() clear(self) end
function Hover:ClearWindow() clear(self.windowState) end
local function update(state,pins,cursor,viewport,world,object)
    local x,y=center(cursor)
    if not x then clear(state); return end
    if viewport.GetRect then
        local left,bottom,width,height=viewport:GetRect()
        if not left then clear(state); return end
        local s=scale(viewport)
        if x<left*s or x>(left+width)*s or y<bottom*s or y>(bottom+height)*s then clear(state); return end
    end
    local nearest,distance=nil,math.huge
    for key,value in pairs(pins) do
        local pin=type(key)=="number" and value or key
        if pin:IsVisible() and (not world or not pin.node or pin.type=="worldmap") then
            local px,py=center(pin)
            if px then
                local d=(px-x)^2+(py-y)^2
                local radius=math.max(18*scale(cursor),pin:GetWidth()*scale(pin)/2)
                if d<=radius*radius and d<distance then nearest,distance=pin,d end
            end
        end
    end
    local data=nearest and (nearest.node or nearest.point or nearest.fish)
    if nearest~=state.current or data~=state.data or object~=state.object
        or (nearest and not GameTooltip:IsOwned(nearest)) then
        clear(state)
        state.current,state.data,state.object=nearest,data,object
        if nearest then
            local enter=nearest:GetScript("OnEnter")
            if enter then enter(nearest) end
        end
    end
end
function Hover:Update()
    local map=WorldMapFrame
    if not map:IsVisible() or not InputUtil or not InputUtil.IsGamepadUIEnabled()
        or not map.IsMapFocused or not map:IsMapFocused()
        or not SoftCursor or not SoftCursor:IsVisible() then
        self:Clear(); return
    end
    -- Decorative/highlight/player pins also appear in currentPoIPins. Only
    -- yield when a native pin is actually displaying its own tooltip.
    for _,pin in ipairs(map.currentPoIPins or {}) do
        if GameTooltip:IsOwned(pin) then self:Clear(); return end
    end
    update(self,self.pins,SoftCursor,map.ScrollContainer,true)
end
function Hover:UpdateWindow(window)
    if not window.mapCursor or not window.mapCursor:IsVisible()
        or not window.controllerNavigation or window.controllerNavigation:GetCurrentButton()~=window.map
        or not InputUtil or not InputUtil.IsGamepadUIEnabled() then
        self:ClearWindow(); return
    end
    update(self.windowState,window.pins,window.mapCursor,window.mapOverlay,false,window.object)
end
function Hover:Register(pin,world)
    self.pins[pin]=world and true or nil
    if self.current==pin then self:Clear() end
    if not self.hooked then
        self.hooked=true
        local elapsedTotal=0
        WorldMapFrame:HookScript("OnUpdate",function(_,elapsed)
            elapsedTotal=elapsedTotal+elapsed
            if elapsedTotal>=.05 then elapsedTotal=0; self:Update() end
        end)
        WorldMapFrame:HookScript("OnHide",function() self:Clear() end)
    end
end
