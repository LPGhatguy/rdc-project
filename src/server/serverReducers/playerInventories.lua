local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dictionary = require(ReplicatedStorage.Modules.RDC.Dictionary)
local None = require(ReplicatedStorage.Modules.RDC.None)

local function playerInventories(state, action)
	state = state or {}

	if action.type == "addPlayer" then
		local existingPlayer = state[action.playerId]

		if existingPlayer ~= nil then
			return state
		end

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
	elseif action.type == "removeItemFromPlayerInventory" then
		local inventory = state[action.playerId]

		if inventory == nil then
			local message = ("No player with the ID %q"):format(tostring(action.playerId))
			warn(message)

			return state
		end

		return Dictionary.join(state, {
			[action.playerId] = Dictionary.join(inventory, {
				[action.itemId] = None,
			})
		})
	end

	return state
end

return playerInventories