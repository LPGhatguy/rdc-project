local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)

local Dictionary = require(Modules.RDC.Dictionary)
local commonReducers = require(Modules.RDC.commonReducers)

local clientReducers = require(script.Parent.clientReducers)
local ClientApi = require(script.Parent.ClientApi)
local UI = require(script.Parent.Components.UI)

return function(context)
	local LocalPlayer = Players.LocalPlayer

	local reducer = Rodux.combineReducers(Dictionary.join(commonReducers, clientReducers))

	local api
	local store

	local function main()
		print("Client starting...")

		local ui = Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
			store = store,
		}, {
			UI = Roact.createElement(UI),
		}), LocalPlayer.PlayerGui, "UI")

		table.insert(context.destructors, function()
			Roact.unmount(ui)
		end)
	end

	api = ClientApi.connect({
		initialStoreState = function(state)
			store = Rodux.Store.new(reducer, state, {Rodux.loggerMiddleware})

			table.insert(context.destructors, function()
				store:destruct()
			end)

			main()
		end,

		storeAction = function(action)
			store:dispatch(action)
		end,

		coolStoryClient = function(object)
			for i = 0, 99 do
				local copy = object:Clone()
				copy.Position = Vector3.new(
					(i % 10) * 7,
					10,
					(math.floor(i / 10) % 10) * 7
				)
				copy.Parent = game.Workspace
			end
		end,
	})

	print("Client ready!")

	api:clientStart()
end