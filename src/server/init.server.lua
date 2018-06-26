local Players = game:GetService("Players")

local hotReload = require(script.hotReload)

local api

-- This order is important, otherwise client/server scripts could start running
-- before common modules get refreshed.
hotReload({
	watch = {
		game:GetService("ReplicatedStorage").Modules,
		game:GetService("ReplicatedStorage").RDC,
		game:GetService("StarterPlayer").StarterPlayerScripts.RDC,
		game:GetService("ServerScriptService").RDC,
	},
	beforeUnload = function()
		if api ~= nil then
			api:destroy()
		end
	end,
	afterReload = function()
		for _, player in ipairs(Players:GetPlayers()) do
			player:LoadCharacter()
		end
	end,
})

local ServerApi = require(script.ServerApi)
local DataStore = require(script.DataStore)

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