local Modules = game:GetService("ReplicatedStorage")

-- Wait for our dependencies to be replicated
Modules:WaitForChild("RDC")
Modules:WaitForChild("Roact")
Modules:WaitForChild("Rodux")
Modules:WaitForChild("RoactRodux")

local ClientApi = require(script.ClientApi)

local api
api = ClientApi:new({
	CoolStoryClient = function()
		print("Server acknolwedged me!")
	end,
})

api:waitForRemotes()

print("Client ready!")

api:fire("ClientStart")