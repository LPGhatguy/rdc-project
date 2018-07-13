local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local ApiProvider = Roact.Component:extend("ApiProvider")

function ApiProvider:init()
	assert(self.props.api ~= nil)

	self._context.ClientApi = self.props.api
end

function ApiProvider:render()
	return Roact.oneChild(self.props[Roact.Children])
end

return ApiProvider