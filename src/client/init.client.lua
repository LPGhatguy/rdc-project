local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

-- Wait for our dependencies to be replicated
ReplicatedStorage:WaitForChild("RDC")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)

local HotReloaded = ReplicatedStorage:WaitForChild("HotReloaded")

local cleanup = {}

HotReloaded.OnClientInvoke = function()
	HotReloaded.OnClientInvoke = nil

	for _, fn in ipairs(cleanup) do
		fn()
	end

	-- Do the job of StarterPlayerScripts over again to restart this script
	local newScript = StarterPlayer.StarterPlayerScripts.RDC:Clone()
	local parent = script.Parent
	script:Destroy()
	newScript.Parent = parent
end

local ClientApi = require(script.ClientApi)
local UI = require(script.Components.UI)

local LocalPlayer = Players.LocalPlayer

local api
local store

local function reducer(state, action)
	state = state or 0

	if action.type == "increment" then
		return state + 1
	end

	return state
end

local function main()
	print("Client starting...")

	local ui = Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		UI = Roact.createElement(UI),
	}), LocalPlayer.PlayerGui, "UI")

	table.insert(cleanup, function()
		Roact.unmount(ui)
	end)
end

api = ClientApi.connect({
	initialStoreState = function(state)
		store = Rodux.Store.new(reducer, state, {Rodux.loggerMiddleware})

		table.insert(cleanup, function()
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
