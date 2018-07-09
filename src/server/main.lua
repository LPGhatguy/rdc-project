local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules

local Rodux = require(Modules.Rodux)

local commonReducers = require(Modules.RDC.commonReducers)
local Dictionary = require(Modules.RDC.Dictionary)

local serverReducers = require(script.Parent.serverReducers)
local ServerApi = require(script.Parent.ServerApi)
local networkMiddleware = require(script.Parent.networkMiddleware)

return function(context)
	local reducer = Rodux.combineReducers(Dictionary.join(commonReducers, serverReducers))

	local initialState = nil
	if context.savedState ~= nil then
		initialState = context.savedState.storeState
	end

	local api

	local function replicate(action, beforeState, afterState)
		-- This is an action that everyone should see!
		if action.replicateBroadcast then
			return api:storeAction(ServerApi.AllPlayers, action)
		end

		-- This is an action that we want a specific player to see.
		if action.replicateTo ~= nil then
			local player = Players:GetPlayerByUserId(action.replicateTo)

			if player == nil then
				return
			end

			return api:storeAction(player, action)
		end

		-- We should probably replicate any actions that modify data shared
		-- between the client and server.
		for key in pairs(commonReducers) do
			if beforeState[key] ~= afterState[key] then
				return api:storeAction(ServerApi.AllPlayers, action)
			end
		end

		return
	end

	local middleware = {
		networkMiddleware(replicate),
	}

	local store = Rodux.Store.new(reducer, initialState, middleware)
	context.store = store

	api = ServerApi.create({
		clientStart = function(player)
			api:initialStoreState(player, store:getState())
		end,
	})

	table.insert(context.destructors, function()
		api:destroy()
	end)

	print("Server ready!")

	while context.running do
		wait(1)

		store:dispatch({
			type = "increment",
		})
	end
end