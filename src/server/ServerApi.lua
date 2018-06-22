local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.RDC.ApiSpec)
local Typer = require(ReplicatedStorage.RDC.Typer)

local ServerApi = {}
ServerApi.prototype = {}
ServerApi.__index = ServerApi.prototype

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

				Typer.checkArgs(endpoint.arguments, ...)

				handler(player, ...)
			end)
		else
			if endpoint.broadcast then
				self[name] = function(_, ...)
					Typer.checkArgs(endpoint.arguments, ...)

					remote:FireAllClients(...)
				end
			else
				self[name] = function(_, player, ...)
					assert(typeof(player) == "Instance" and player:IsA("Player"))

					Typer.checkArgs(endpoint.arguments, ...)

					remote:FireClient(player, ...)
				end
			end
		end
	end

	remotes.Parent = ReplicatedStorage

	return self
end

return ServerApi