local ServerApi = require(script.ServerApi)
local DataStore = require(script.DataStore)

local api
api = ServerApi.create({
	clientStart = function(player)
		local thing = Instance.new("Part")
		thing.Name = "Hey"
		thing.Size = Vector3.new(math.random(2, 6), math.random(2, 6), math.random(2, 6))
		thing.Anchored = true

		thing.Parent = player.PlayerGui

		api:coolStoryClient(player, thing)
	end,
})

print("Server ready!")

-- local foo = DataStore.newLive("hello")
-- foo:write("hello", "world")
-- 	:andThen(
-- 		function(...)
-- 			print("Success!", ...)
-- 		end,
-- 		function(...)
-- 			warn("Failed!", ...)
-- 		end
-- 	)