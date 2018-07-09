local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.Modules.RDC.ApiSpec)

local ServerApi = {}
ServerApi.prototype = {}
ServerApi.__index = ServerApi.prototype

ServerApi.AllPlayers = newproxy(true)

function ServerApi.create(handlers)
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, ServerApi)

	local remotes = Instance.new("Folder")
	remotes.Name = "Events"

	for name, endpoint in pairs(ApiSpec) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotes

		if endpoint.from == "client" then
			local handler = handlers[name]

			if handler == nil then
				error(("Need to implement server handler for %q"):format(name), 2)
			end

			remote.OnServerEvent:Connect(function(player, ...)
				assert(typeof(player) == "Instance" and player:IsA("Player"))

				endpoint.arguments(...)

				handler(player, ...)
			end)
		else
			self[name] = function(_, player, ...)
				endpoint.arguments(...)

				if player == ServerApi.AllPlayers then
					remote:FireAllClients(...)
				else
					assert(typeof(player) == "Instance" and player:IsA("Player"))

					remote:FireClient(player, ...)
				end
			end
		end
	end

	remotes.Parent = ReplicatedStorage
	self.remotes = remotes

	return self
end

function ServerApi.prototype:destroy()
	self.remotes:Destroy()
end

return ServerApi