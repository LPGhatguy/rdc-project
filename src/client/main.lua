local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)

RoactRodux.UNSTABLE_connect2 = RoactRodux.connect

local RoduxVisualizer = require(Modules.RoduxVisualizer)

local Dictionary = require(Modules.RDC.Dictionary)
local commonReducers = require(Modules.RDC.commonReducers)

local clientReducers = require(script.Parent.clientReducers)
local ClientApi = require(script.Parent.ClientApi)

local Game = require(script.Parent.Components.Game)
local ApiProvider = require(script.Parent.Components.ApiProvider)

return function(context)
	local LocalPlayer = Players.LocalPlayer

	local reducer = Rodux.combineReducers(Dictionary.join(commonReducers, clientReducers))

	local api
	local store

	local function main()
		local ui = Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
			store = store,
		}, {
			Roact.createElement(ApiProvider, {
				api = api,
			}, {
				Game = Roact.createElement(Game),
			}),
		}), LocalPlayer.PlayerGui, "RDC Project")

		table.insert(context.destructors, function()
			Roact.unmount(ui)
		end)

		print("Client started!")
	end

	local function saveActionsMiddleware(nextDispatch)
		return function(action)
			if not action.replicated then
				table.insert(context.savedActions, action)
			end

			return nextDispatch(action)
		end
	end

	local devTools = RoduxVisualizer.createDevTools({
		mode = RoduxVisualizer.Mode.Integrated,
		toggleHotkey = Enum.KeyCode.Y,
		visibleOnStartup = false,
		attachTo = LocalPlayer:WaitForChild("PlayerGui"),
	})

	api = ClientApi.connect({
		initialStoreState = function(initialState)
			-- Apply any saved actions from the last reload.
			-- The actions in this list are only those that were triggered on
			-- the client, since the shared state should already be populated
			-- correctly from the server.
			for _, action in ipairs(context.savedActions) do
				initialState = reducer(initialState, action)
			end

			store = Rodux.Store.new(reducer, initialState, {
				Rodux.thunkMiddleware,
				saveActionsMiddleware,
				devTools.middleware,
			})

			table.insert(context.destructors, function()
				store:destruct()
			end)

			main()
		end,

		storeAction = function(action)
			if store ~= nil then
				store:dispatch(action)
			end
		end,
	})

	print("Client ready!")

	api:clientStart()
end