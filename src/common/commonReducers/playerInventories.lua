local Dictionary = require(script.Parent.Parent.Dictionary)

local function playerInventories(state, action)
	state = state or {}

	if action.type == "addPlayer" then
		return Dictionary.join(state, {
			[action.playerId] = {},
		})
	elseif action.type == "addItemsToPlayerInventory" then
		local inventory = state[action.playerId]

		if inventory == nil then
			local message = ("No player with the ID %q"):format(tostring(action.playerId))
			warn(message)

			return state
		end

		return Dictionary.join(state, {
			[action.playerId] = Dictionary.join(inventory, action.items),
		})
	end

	return state
end

return playerInventories