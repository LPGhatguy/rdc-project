local function step(state, action)
	state = state or 0

	if action.type == "increment" then
		return state + 1
	end

	return state
end

return step