local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.RDC.ApiSpec)
local Typer = require(ReplicatedStorage.RDC.Typer)

local ClientApi = {}
ClientApi.prototype = {}
ClientApi.__index = ClientApi.prototype

function ClientApi.connect(handlers)
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, ClientApi)

	local remotes = ReplicatedStorage:WaitForChild("Events")

	for name, endpoint in pairs(ApiSpec) do
		local remote = remotes:WaitForChild(name)

		if endpoint.from == "server" then
			local handler = handlers[name]

			if handler == nil then
				error(("Need to implement client handler for %q"):format(name), 2)
			end

			remote.OnClientEvent:Connect(function(...)
				Typer.checkArgs(endpoint.arguments, ...)

				handler(...)
			end)
		else
			self[name] = function(_, ...)
				Typer.checkArgs(endpoint.arguments, ...)

				remote:FireServer(...)
			end
		end
	end

	return self
end

return ClientApi