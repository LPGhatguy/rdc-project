local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for our dependencies to be replicated
ReplicatedStorage:WaitForChild("RDC")
ReplicatedStorage:WaitForChild("Roact")
ReplicatedStorage:WaitForChild("Rodux")
ReplicatedStorage:WaitForChild("RoactRodux")

local ClientApi = require(script.ClientApi)

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