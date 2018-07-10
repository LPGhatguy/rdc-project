local Dictionary = require(script.Parent.Parent.Dictionary)
local None = require(script.Parent.Parent.None)

local function world(state, action)
	state = state or {}

	if action.type == "addItemsToWorld" then
		return Dictionary.join(state, action.items)
	elseif action.type == "removeItemFromWorld" then
		return Dictionary.join(state, {
			[action.itemId] = None,
		})
	end

	return state
end

return world