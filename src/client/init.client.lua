local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local HotReloaded = ReplicatedStorage:WaitForChild("HotReloaded")

local main = require(script.main)

local context = {
	destructors = {},
	running = true,
}

HotReloaded.OnClientInvoke = function()
	HotReloaded.OnClientInvoke = nil

	context.running = false

	for _, fn in ipairs(context.destructors) do
		fn()
	end

	-- Do the job of StarterPlayerScripts over again to restart this script
	local newScript = StarterPlayer.StarterPlayerScripts.RDC:Clone()
	local parent = script.Parent
	script:Destroy()
	newScript.Parent = parent
end

main(context)