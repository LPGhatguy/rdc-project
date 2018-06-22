local ServerApi = require(script.ServerApi)

local api
api = ServerApi:new({
	ClientStart = function(player)
		print("Got ClientStart!")

		local thing = Instance.new("Folder")
		thing.Name = "ayy lmao"
		thing.Parent = player.PlayerGui

		api:fireToOne("CoolStoryClient", player, thing)
	end,
})

api:createRemotes()

print("Server ready!")