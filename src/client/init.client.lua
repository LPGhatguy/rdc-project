local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

-- Wait for our dependencies to be replicated
ReplicatedStorage:WaitForChild("RDC")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Roact = require(Modules.Roact)

local HotReloaded = ReplicatedStorage:WaitForChild("HotReloaded")

local ui

local hotReloadConnection
hotReloadConnection = HotReloaded.OnClientEvent:Connect(function()
	hotReloadConnection:Disconnect()

	if ui ~= nil then
		Roact.unmount(ui)
	end

	-- Do the job of StarterPlayerScripts over again to restart this script
	local newScript = StarterPlayer.StarterPlayerScripts.RDC:Clone()
	local parent = script.Parent
	script:Destroy()
	newScript.Parent = parent
end)

local ClientApi = require(script.ClientApi)
local UI = require(script.Components.UI)

local LocalPlayer = Players.LocalPlayer

local api
api = ClientApi.connect({
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

ui = Roact.mount(Roact.createElement(UI), LocalPlayer.PlayerGui, "UI")