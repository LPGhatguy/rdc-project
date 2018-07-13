local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dictionary = require(ReplicatedStorage.Modules.RDC.Dictionary)

local function inventory(state, action)
	state = state or {}

	if action.type == "addItemsToPlayerInventory" then
		return Dictionary.join(state, action.items)
	end

	return state
end

return inventory