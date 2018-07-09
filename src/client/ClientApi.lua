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

	for name, endpoint in pairs(ApiSpec) do
		local remote = remotes:WaitForChild(name)

		if endpoint.from == "server" then
			local handler = handlers[name]

			if handler == nil then
				error(("Need to implement client handler for %q"):format(name), 2)
			end

			remote.OnClientEvent:Connect(function(...)
				endpoint.arguments(...)

				handler(...)
			end)
		else
			self[name] = function(_, ...)
				endpoint.arguments(...)

				remote:FireServer(...)
			end
		end
	end

	for name in pairs(handlers) do
		if ApiSpec[name] == nil then
			error(("Invalid handler %q specified!"):format(name), 2)
		end
	end

	return self
end

return ClientApi