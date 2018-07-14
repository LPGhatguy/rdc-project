--[[
	A client's view of their inventory uses a different reducer than the
	server's view of all client's inventories.

	This has the advantage of making client-side code cleaner, but I did run
	into a bug I'm not sure how to solve sort of late into this design.

	When the server reloads (or if a player had saved items from a previous play
	session) the server only sends an initial state to the client. That worked
	in the simple case (all information is shared) but sort of falls apart
	because of this difference.

	The server will send over the common information, which doesn't include any
	information specific to the client, but also doesn't include any actions
	that only affected server or client specific information.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dictionary = require(ReplicatedStorage.Modules.RDC.Dictionary)
local None = require(ReplicatedStorage.Modules.RDC.None)

local function inventory(state, action)
	state = state or {}

	if action.type == "addItemsToPlayerInventory" then
		return Dictionary.join(state, action.items)
	elseif action.type == "removeItemFromPlayerInventory" then
		return Dictionary.join(state, {
			[action.itemId] = None,
		})
	end

	return state
end

return inventory