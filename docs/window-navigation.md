# Custom map window navigation

The map window uses Blizzard's `NavBarTemplate` and `NavButtonTemplate` for the
World > Continent > Zone breadcrumb trail. Each ancestor is clickable; continent
and zone dropdowns list sibling maps using `C_Map.GetMapChildrenInfo`. Blizzard's
native overflow control handles long trails. The resource sidebar is always
visible and reserves 280 pixels; the Find/collapse toggle has been removed.

## Controller navigation

Controller input and focus are owned by GatherLite frames. The addon does not
register with Blizzard's FrameControlsManager, change its binding stack, or
mutate SmartNavigation. Those shared transitions synchronously update protected
action-bar interaction targets and can cause ADDON_ACTION_FORBIDDEN.

Input stops while another native panel owns controller focus or during combat.
Local bindings release on tab changes, lost focus, input-mode changes and closing.
Resource selection jumps to route actions; directional shortcuts connect the
list, route card, breadcrumbs and settings categories. Controller breadcrumb
menus use addon-owned buttons; mouse dropdowns retain their native presentation.

The map starts focused with a visible reticle using Blizzard world-map cursor artwork
and guide lines. Moving the left stick from sidebar controls returns to map focus;
Confirm enters the zone under it. Shoulder buttons zoom and right stick scrolls
lists. The map pans when the reticle reaches its edge. Mouse zone clicks always use the
embedded canvas cursor coordinates, even in controller UI mode. Custom bindings release on tab changes, help, lost focus and closing.
The top-bar +/- buttons are removed. Mouse wheel and drag remain available.

Gathering and fishing tooltips respond to both Blizzard's world-map cursor and
the GatherLite reticle. Hit testing compares cursor and visible pin centers in
physical screen coordinates, accounting for each frame's effective UI scale.
Decorative native pins do not block gathering hover; an active native-pin tooltip
takes precedence. Tooltip ownership loss and recycled pin data trigger a refresh.
Leaving map focus, hiding the cursor or closing either map clears its tooltip.
Hovering never reloads nodes while panning or zooming.

On first login after installing this guide, the main window opens with a
five-step tour of native arrow help tips. This is remembered account-wide; Help replays it.
Each popout points to the control it explains and leaves the window usable.
Guide text explains the feature first and appends controller instructions when relevant. Back dismisses the guide first.
The addon owns a `HelpTipTemplate` instance because Blizzard's global HelpTip
service suppresses tips in controller mode; global suppression is unchanged.
WoW Key Bindings > GatherLite > Toggle GatherLite window opens/closes the window;
no key is assigned automatically.

World Map settings include Show neighboring zone nodes, disabled by default.
World and continent overview maps hide custom resource pins and route lines.

Source contracts inspected from the Forever UI source:

- [Native navigation bar](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_FrameXML/Mainline/NavigationBar.lua)
- [Controller window manager](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_GamepadSharedUtility/FrameControlsManager.lua)
- [Smart Navigation](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_GamepadSmartNavigation/SmartNavigation.lua)

Validation: `lua tools/test_routes.lua` exercises breadcrumb hierarchy and menu
selection, sidebar layout, late controller loading, input-mode changes, tab focus,
dynamic focus refresh, modal ownership, Back/close and reopening. These are mocked
UI tests; visual matching and physical controller behavior still need an in-game
check on the Forever client.

## Settings with a controller

Category Confirm or Right enters its settings. D-pad follows setting rows and
resource columns; Left at a row's first control returns to categories. Focused
controls scroll into view and right-stick scrolling remains available.

Each slider has one controller focus target. D-pad or left-stick Left/Right
adjust it immediately, by the setting's exact step, and repeat when held.
Up/Down navigate settings; Back returns to the category list. Confirm may still
enter explicit adjustment mode, with Confirm/Back finishing that mode. Mouse
dragging and native stepper buttons remain available.

Debugging > Reset onboarding clears the account-wide guide state and immediately
starts the native arrow-tip tour again; the flag is saved once it is displayed.
