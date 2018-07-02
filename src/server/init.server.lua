repeat
	wait()
until script.Parent ~= nil

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HotReload = require(ReplicatedStorage.HotReload)

local savedState = HotReload.getSavedState()

local api
local store
local running = true

-- This order is important, otherwise client/server scripts could start running
-- before common modules get refreshed.
HotReload.start({
	watch = {
		game:GetService("ReplicatedStorage").Modules,
		game:GetService("ReplicatedStorage").RDC,
		game:GetService("StarterPlayer").StarterPlayerScripts.RDC,
		game:GetService("ServerScriptService").RDC,
	},
	beforeUnload = function()
		running = false

		local newSavedState = {
			storeState = store:getState(),
		}

		if api ~= nil then
			api:destroy()
		end

		if store ~= nil then
			store:destruct()
		end

		return newSavedState
	end,
	afterReload = function()
		for _, player in ipairs(Players:GetPlayers()) do
			player:LoadCharacter()
		end
	end,
})

local function reducer(state, action)
	state = state or 0

	if action.type == "increment" then
		return state + 1
	end

	return state
end

local ServerApi = require(script.ServerApi)
local Rodux = require(ReplicatedStorage.Modules.Rodux)

local initialState = nil
if savedState ~= nil then
	initialState = savedState.storeState
end

local function networkMiddleware(nextDispatch)
	return function(action)
		api:storeAction(action)

		return nextDispatch(action)
	end
end

local middleware = {networkMiddleware}

store = Rodux.Store.new(reducer, initialState, middleware)

api = ServerApi.create({
	clientStart = function(player)
		api:initialStoreState(player, store:getState())
	end,
})

print("Server ready!")

while running do
	wait(1)

	store:dispatch({
		type = "increment",
	})
end