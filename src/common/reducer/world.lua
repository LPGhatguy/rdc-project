local Dictionary = require(script.Parent.Parent.Dictionary)

local function world(state, action)
	state = state or {}

	if action.type == "addItemsToWorld" then
		return Dictionary.join(state, action.items)
	end

	return state
end

return world