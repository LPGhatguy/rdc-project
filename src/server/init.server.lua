--[[
	Serves as the entry-point to the server code.

	This file contains a bit of ceremony to set up hot-reloading, which is only
	used during development.
]]

-- There's probably a more elegant approach to this that involves waiting on
-- GetPropertyChangedSignal("Parent") instead of this loop.
repeat
	wait()
until script.Parent ~= nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HotReloadServer = require(ReplicatedStorage.HotReloadServer)

local savedState = HotReloadServer.getSavedState()
local savedActions = {}

if savedState ~= nil then
	savedActions = savedState.savedActions
end

local context = {
	running = true,
	destructors = {},
	savedActions = savedActions,
	wasReloaded = savedState ~= nil,
}

HotReloadServer.start({
	-- The order of objects to watch is important, otherwise a hot-reloaded
	-- server might start running before the modules it depends on are reloaded.
	watch = {
		game:GetService("ReplicatedStorage").Modules,
		game:GetService("StarterPlayer").StarterPlayerScripts.RDC,
		game:GetService("ServerScriptService").RDC,
	},

	beforeUnload = function()
		context.running = false

		for _, destructor in ipairs(context.destructors) do
			local ok, result = pcall(destructor)

			if not ok then
				warn("Failure during destruction: " .. result)
			end
		end

		return {
			savedActions = context.savedActions,
		}
	end,

	afterReload = function()
		-- This function is sort of vestigial now.
		-- It's used to run code after the new server function has started
		-- running, and was previously used to respawn all players.

		-- Now that the client code is hot-reloaded without respawning, there's
		-- no need for this!
	end,
})

local main = require(script.main)
main(context)