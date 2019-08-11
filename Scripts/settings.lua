local name, GatherLite = ...

local loaded = false;
local defaultConfigs = {
    enabled = true,
    mining = true,
    herbs = true,
    treasures = true,
    showWorldMap = true,
    showMiniMap = true,
    MiniMapPosition = 45
};

local tooltip = CreateFrame("GameTooltip", nil, UIParent, "GameTooltipTemplate")
tooltip:ClearLines()
tooltip:AddFontStrings(tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"));


-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function GatherLite_MinimapButton_Reposition()
    GatherLite_MinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherLiteConfigCharacter.MiniMapPosition)), (80 * sin(GatherLiteConfigCharacter.MiniMapPosition)) - 52)
end

function GatherLite_MinimapButton_OnLoad(self)
    self:RegisterEvent('ADDON_LOADED')
end

-- Only while the button is dragged this is called every frame
function GatherLite_MinimapButton_DraggingFrame_OnUpdate()

    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70 -- get coordinates as differences from the center of the minimap
    ypos = ypos / UIParent:GetScale() - ymin - 70

    GatherLiteConfigCharacter.MiniMapPosition = math.deg(math.atan2(ypos, xpos))
    GatherLite_MinimapButton_Reposition() -- move the button
end

function GatherLite_MinimapButton_OnUpdate()
    if loaded then
        if not GatherLiteConfigCharacter.enabled then
            GatherLite_MinimapButton:SetAlpha(.75);
        else
            GatherLite_MinimapButton:SetAlpha(1);
        end;
    end;
end

-- Put your code that you want on a minimap button click here.  arg1="LeftButton", "RightButton", etc
function GatherLite_MinimapButton_OnClick(self, button)
    if button == "LeftButton" then
        if GatherLiteConfigCharacter.enabled then
            GatherLiteConfigCharacter.enabled = false
        else
            GatherLiteConfigCharacter.enabled = true
        end;
        GatherLite.NeedMapUpdate = true
    elseif button == "RightButton" then
        local dropDown = CreateFrame("Frame", "WPDemoContextMenu", UIParent, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(dropDown, WPDropDownDemo_Menu, "MENU")
        ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
    end;
end

function GatherLite_MinimapButton_OnDragStop()
    GatherLiteGlobalSettings.MiniMapPosition = miniMapPosition;
end

local function CopyDefaults(src, dst)
    if type(src) ~= "table" then return {} end
    if type(dst) ~= "table" then dst = {} end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = CopyDefaults(v, dst[k])
        elseif type(v) ~= type(dst[k]) then
            dst[k] = v
        end
    end
    return dst
end

function GatherLite_MinimapButton_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == "GatherLite" then
        GatherLiteConfigCharacter = CopyDefaults(defaultConfigs, GatherLiteConfigCharacter)
        loaded = true;

        GatherLite_MinimapButton_Reposition();

        -- Unregister this event, since there is no further use for it:
        self:UnregisterEvent("ADDON_LOADED")
    end
end

function GatherLite_MinimapButton_OnEnter()
    tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    tooltip:SetText("GatherLite")
    tooltip:AddLine("|cffC0C0C0Left click|r: Toggle on|off", 1, 1, 1)
    tooltip:AddLine("|cffC0C0C0Right click|r: Show menu", 1, 1, 1)
    tooltip:Show()
end

function GatherLite_MinimapButton_OnLeave()
    tooltip:Hide()
end

function DropdownItem(text, icon, checked, callback)
end

function addDropdownItem(args)
    local info = UIDropDownMenu_CreateInfo()
    info.text = args.text;
    info.checked = args.checked;
    info.func = args.callback;
    info.icon = args.icon;
    info.isTitle = args.isTitle;
    info.disabled = args.disabled;
    info.notCheckable = args.notCheckable;
    UIDropDownMenu_AddButton(info)
end

function WPDropDownDemo_Menu(frame, level, menuList)

    if level == 1 then

        addDropdownItem({
            text = "GatherLite",
            isTitle = true,
            notCheckable = true
        });

        addDropdownItem({
            text = "Mining nodes",
            icon = GatherLite.icons[GatherLite.locale.CAT_ORE][GatherLite.locale.ORE_COPPER],
            checked = GatherLiteConfigCharacter.mining,
            callback = function()
                if GatherLiteConfigCharacter.mining then
                    GatherLiteConfigCharacter.mining = false;
                else
                    GatherLiteConfigCharacter.mining = true;
                end;

                GatherLite.NeedMapUpdate = true;
            end
        })

        addDropdownItem({
            text = "Herbalism nodes",
            icon = GatherLite.icons[GatherLite.locale.CAT_HERB][GatherLite.locale.HERB_PEACEBLOOM],
            checked = GatherLiteConfigCharacter.herbs,
            callback = function()
                if GatherLiteConfigCharacter.herbs then
                    GatherLiteConfigCharacter.herbs = false;
                else
                    GatherLiteConfigCharacter.herbs = true;
                end;
                GatherLite.NeedMapUpdate = true;
            end
        })

        addDropdownItem({
            text = "Treasure chests",
            icon = GatherLite.icons[GatherLite.locale.CAT_TREASURE]["default"],
            checked = GatherLiteConfigCharacter.treasures,
            callback = function()
                if GatherLiteConfigCharacter.treasures then
                    GatherLiteConfigCharacter.treasures = false;
                else
                    GatherLiteConfigCharacter.treasures = true;
                end;
                GatherLite.NeedMapUpdate = true;
            end
        })
    end
end

