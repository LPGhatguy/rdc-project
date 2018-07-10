local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.Modules.RDC.ApiSpec)

local ClientApi = {}
ClientApi.prototype = {}
ClientApi.__index = ClientApi.prototype

function ClientApi.connect(handlers)
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, ClientApi)

	local remotes = ReplicatedStorage:WaitForChild("Events")

	for name, endpoint in pairs(ApiSpec.fromClient) do
		local remote = remotes:WaitForChild("fromClient-" .. name)

		self[name] = function(_, ...)
			endpoint.arguments(...)

			remote:FireServer(...)
		end
	end

	for name, endpoint in pairs(ApiSpec.fromServer) do
		local remote = remotes:WaitForChild("fromServer-" .. name)

		local handler = handlers[name]

		if handler == nil then
			error(("Need to implement client handler for %q"):format(name), 2)
		end

		remote.OnClientEvent:Connect(function(...)
			endpoint.arguments(...)

			handler(...)
		end)
	end

	for name in pairs(handlers) do
		if ApiSpec.fromServer[name] == nil then
			error(("Invalid handler %q specified!"):format(name), 2)
		end
	end

	return self
end

return ClientApi