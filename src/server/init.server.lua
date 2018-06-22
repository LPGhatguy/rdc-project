local ServerApi = require(script.ServerApi)

local api
api = ServerApi.create({
	clientStart = function(player)
		local x = math.random(2, 6)
		local thing = Instance.new("Part")
		thing.Name = "Hey"
		thing.Size = Vector3.new(x, x, x)
		thing.Anchored = true

		thing.Parent = player.PlayerGui

		api:coolStoryClient(player, thing)
	end,
})

print("Server ready!")