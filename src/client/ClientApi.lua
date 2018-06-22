local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.RDC.ApiSpec)

local RemoteApi = {}
RemoteApi.prototype = {}
RemoteApi.__index = RemoteApi.prototype

function RemoteApi:new(handlers)
	assert(typeof(handlers) == "table")

	local new = {
		handlers = handlers,
		remotes = nil,
	}

	setmetatable(new, RemoteApi)

	return new
end

function RemoteApi.prototype:waitForRemotes()
	assert(self.remotes == nil)

	self.remotes = {}

	local remotes = ReplicatedStorage:WaitForChild("Events")

	for name, endpoint in pairs(ApiSpec) do
		local remote = remotes:WaitForChild(name)
		self.remotes[name] = remote

		if endpoint.from == "server" then
			local handler = self.handlers[name]

			if handler == nil then
				error(("Need to implement client handler for %q"):format(name), 2)
			end

			remote.OnClientEvent:Connect(handler)
		end
	end
end

function RemoteApi.prototype:fire(eventName, ...)
	local endpoint = assert(ApiSpec[eventName])

	assert(endpoint.from == "client")

	local remote = assert(self.remotes[eventName])

	remote:FireServer(...)
end

return RemoteApi