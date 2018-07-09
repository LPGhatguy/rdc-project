local function clientCounter(state, action)
	state = state or 0

	if action.type == "clientIncrement" then
		return state + 1
	end

	return state
end

return clientCounter