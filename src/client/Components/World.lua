local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local pickUpItem = require(script.Parent.Parent.pickUpItem)

local e = Roact.createElement

local World = Roact.Component:extend("World")

function World:render()
	local children = {}

	for id, item in pairs(self.props.world) do
		local slot = e("Part", {
			Size = Vector3.new(3, 3, 3),
			Position = item.position,
			Color = item.color,
			Anchored = true,

			[Roact.Event.Touched] = function()
				self.props.pickUpItem(self.props.api, id)
			end,
		})

		children[id] = slot
	end

	return e("Folder", nil, children)
end

World = RoactRodux.connect(
	function(state)
		return {
			world = state.world,
		}
	end,
	function(dispatch)
		return {
			pickUpItem = function(...)
				return dispatch(pickUpItem(...))
			end,
		}
	end
)(World)

return World