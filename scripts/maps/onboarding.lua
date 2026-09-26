local _, addon = ...
local Window = addon.Window
local steps = {
    {title="Find a resource", target=function(w) return w.search end, point="LeftEdgeCenter",
        text="Search by resource name or type to narrow the list. Only this zone shows resources known in the map zone. Check multiple resources to combine their locations.",
        controller="Use the D-pad to move and Confirm to select. Selection jumps to the route controls."},
    {title="Plan a route", target=function(w) return w.generate:IsShown() and w.generate or w.routeCard end, point="LeftEdgeCenter",
        text="Generate zone route connects checked resources in the displayed zone. Uncheck Only this zone to generate circuits across their known zones. Hide or clear routes, or open the world map. Fish show reported catches instead of routes.",
        controller="Right from a resource jumps here. Left from an action returns to your resource."},
    {title="Choose a zone", target=function(w) return w.breadcrumb end, point="BottomEdgeCenter",
        text="These breadcrumbs show where you are: World > Continent > Zone. Select a name to go back to that level, or use its dropdown to choose another continent or zone.",
        controller="On a breadcrumb, press Down to reach its arrow, then Confirm to open the menu."},
    {title="Explore the map", target=function(w) return w.map.ScrollContainer end, point="RightEdgeCenter",
        text="The map shows locations for your selected resource and any generated route. Select a zone to inspect it; overview maps stay clear. Drag to pan, scroll to zoom, and right-click to go back.",
        controller="Move the map cursor with the left stick and Confirm to enter a zone. The map pans when the cursor reaches an edge. Shoulders zoom; right stick scrolls lists."},
    {title="Make it yours", target=function(w) return w.tabs[2] end, point="TopEdgeCenter",
        text="World map settings include neighboring zone nodes, off by default. Assign Toggle GatherLite window in WoW Key Bindings. Help replays these tips."},
}
function Window:UpdateOnboarding()
    if not self.helpStep or not self.frame:IsShown() then return end
    local step=steps[self.helpStep]
    local target=step.target(self)
    local controller=InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled() or false
    if self.helpTipStep==self.helpStep and self.helpTipTarget==target and self.helpTipController==controller then return end
    self.helpTipStep,self.helpTipTarget,self.helpTipController=self.helpStep,target,controller
    local guide=self.guide
    guide:Reset()
    guide:Init(self.frame, {
        text=string.format("%d / %d  |cffffd100%s|r\n\n%s",self.helpStep,#steps,step.title,
            step.text..(controller and step.controller and ("\n\n|cffffd100Controller|r\n"..step.controller) or "")),
        buttonStyle=self.helpStep==#steps and HelpTip.ButtonStyle.GotIt or HelpTip.ButtonStyle.Next,
        targetPoint=HelpTip.Point[step.point],
        alignment=HelpTip.Alignment.Center,
        autoEdgeFlipping=true, autoHorizontalSlide=true, useParentStrata=true,
    },target)
    guide:Show()
    guide:Layout()
    -- Also offer dismissal before the final tip. It never acknowledges another step.
    guide.CloseButton:Show()
end
function Window:CloseOnboarding()
    if not self.helpStep then return end
    self.helpStep,self.helpTipStep,self.helpTipTarget=nil,nil,nil
    self.guide:Reset()
    self.guide:Hide()
    if self.RefreshController then self:RefreshController(true) end
end
function Window:ShowOnboarding()
    if not self.ready then return end
    self:SelectTab(1)
    if not self.guide then
        -- HelpTip:Show suppresses all tips in controller mode. Own a native
        -- template instance so this explicitly requested guide works with both
        -- inputs, without changing Blizzard's suppression rules or frame pool.
        local guide=CreateFrame("Frame",nil,self.frame,"HelpTipTemplate")
        self.guide=guide
        guide.Close=function() self:CloseOnboarding() end
        guide:Hide()
        guide.width=HelpTip.width
        guide:SetWidth(guide.width)
        guide.next=guide.OkayButton
        guide.OkayButton:SetScript("OnClick",function()
            if not self.helpStep then return end
            if self.helpStep==#steps then self:CloseOnboarding(); return end
            self.helpStep=self.helpStep+1
            self:UpdateOnboarding()
            if self.RefreshController then self:RefreshController() end
            if self.SetControllerTarget then self:SetControllerTarget(guide.OkayButton) end
        end)
        guide.CloseButton:SetScript("OnClick",function() self:CloseOnboarding() end)
        self.frame:HookScript("OnHide",function() self:CloseOnboarding() end)
    end
    self.helpStep=1
    self.helpTipStep=nil
    self:UpdateOnboarding()
    if self.RefreshController then self:RefreshController(true) end
end
-- Account-wide: existing installations see the guide once after upgrading too.
function Window:ShowFirstLogin()
    if GatherLite.db.global.controlsGuideSeen or not GatherLite:IsLoaded() then return end
    self:Show()
    if not self.ready or not self.frame:IsShown() then return end
    self:ShowOnboarding()
    GatherLite.db.global.controlsGuideSeen=true
end
