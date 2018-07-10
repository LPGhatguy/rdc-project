local function addPlayer(playerId)
	assert(typeof(playerId) == "string")

	return {
		type = script.Name,
		playerId = playerId,
	}
end

return addPlayer