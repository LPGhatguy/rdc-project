local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local reducer = require(ReplicatedStorage.RDC.reducer)

local ServerApi = require(script.Parent.ServerApi)
local networkMiddleware = require(script.Parent.networkMiddleware)

return function(context)
	local initialState = nil
	if context.savedState ~= nil then
		initialState = context.savedState.storeState
	end

	local api

	local function replicateCallback(action)
		api:storeAction(action)
	end

	local function shouldReplicate(action, oldState, newState)
		return true
	end

	local middleware = {networkMiddleware(shouldReplicate, replicateCallback)}

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