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