local ServerApi = require(script.ServerApi)

local api
api = ServerApi:new({
	ClientStart = function(player)
		print("Got ClientStart!")

		local x = math.random(2, 6)
		local thing = Instance.new("Part")
		thing.Name = "Hey"
		thing.Size = Vector3.new(x, x, x)
		thing.Anchored = true

		thing.Parent = player.PlayerGui

		api:fireToOne("CoolStoryClient", player, thing)
	end,
})

api:createRemotes()

print("Server ready!")