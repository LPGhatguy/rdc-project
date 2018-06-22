local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ApiSpec = require(ReplicatedStorage.RDC.ApiSpec)

local ServerApi = {}
ServerApi.prototype = {}
ServerApi.__index = ServerApi.prototype

function ServerApi:new(handlers)
	assert(typeof(handlers) == "table")

	local new = {
		handlers = handlers,
		remotes = nil,
	}

	setmetatable(new, ServerApi)

	return new
end

function ServerApi.prototype:createRemotes()
	assert(self.remotes == nil)

	self.remotes = {}

	local remotes = Instance.new("Folder")
	remotes.Name = "Events"

	for name, endpoint in pairs(ApiSpec) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotes

		self.remotes[name] = remote

		if endpoint.from == "client" then
			local handler = self.handlers[name]

			if handler == nil then
				error(("Need to implement server handler for %q"):format(name), 2)
			end

			remote.OnServerEvent:Connect(handler)
		end
	end

	remotes.Parent = ReplicatedStorage
end

function ServerApi.prototype:fireToOne(eventName, player, ...)
	local endpoint = assert(ApiSpec[eventName])

	assert(endpoint.from == "server")

	local remote = assert(self.remotes[eventName])

	remote:FireClient(player, ...)
end

function ServerApi.prototype:broadcast(eventName, ...)
	local endpoint = assert(ApiSpec[eventName])

	assert(endpoint.from == "server")

	local remote = assert(self.remotes[eventName])

	remote:FireAllClients(...)
end

return ServerApi