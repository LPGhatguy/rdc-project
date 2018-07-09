repeat
	wait()
until script.Parent ~= nil

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HotReload = require(ReplicatedStorage.HotReload)
local main = require(script.main)

local context = {
	savedState = HotReload.getSavedState(),
	running = true,
	destructors = {},
	store = nil,
}

-- This order is important, otherwise client/server scripts could start running
-- before common modules get refreshed.
HotReload.start({
	watch = {
		game:GetService("ReplicatedStorage").Modules,
		game:GetService("StarterPlayer").StarterPlayerScripts.RDC,
		game:GetService("ServerScriptService").RDC,
	},
	beforeUnload = function()
		context.running = false

		local savedState = nil
		if context.store ~= nil then
			savedState = {
				storeState = context.store:getState(),
			}
			context.store:destruct()
		end

		for _, destructor in ipairs(context.destructors) do
			local ok, result = pcall(destructor)

			if not ok then
				warn("Failure during destruction: " .. result)
			end
		end

		return savedState
	end,
	afterReload = function()
		for _, player in ipairs(Players:GetPlayers()) do
			player:LoadCharacter()
		end
	end,
})

main(context)