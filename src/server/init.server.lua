local ServerApi = require(script.ServerApi)

local api
api = ServerApi:new({
	ClientStart = function(player)
		print("Got ClientStart!")
		api:fireToOne("CoolStoryClient", player)
	end,
})

api:createRemotes()

print("Server ready!")