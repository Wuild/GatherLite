![GatherLite](./gatherlite-banner.jpg)

This is the supported API functions you may use in your own addons,
object ids can be found in the nodes.lua file along with other data you may need.

These functions are available when using the global variable "GatherLite"

Command |  description
---| ---|
GatherLite:GetNodes() |   Gets all nodes from the database
GatherLite:GetNodeObject(objectID) | Gets object data from specific object
GatherLite:IsNodeInRange(x1, y1, x2, y2) | Check if two coordinates are close to each other
GatherLite:FindExistingNode(type, mapID, x, y) | Get existing node at location
GatherLite:RegisterNode(type, objectID, mapID, x, y) | Add node of type at location
GatherLite:ResetWorldmap() | Resets the worldmap nodes
GatherLite:ResetMinimap() | Resets the minimap nodes
GatherLite:IsLoaded() | Checks if we have finished loading

[![Buy Me A Coffee](https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png "Buy Me A Coffee")](https://www.buymeacoffee.com/yuImx6KOY "Buy Me A Coffee")
