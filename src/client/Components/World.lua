--[[
	Creates all of the items in the world and allows the user to interact with
	them by picking them up.

	In a real game, I think managing your game world with Roact might be kind of
	strange. Roact lends itself very well to deep tree structures, and many game
	world representations are flat.

	In this project, the world is rendered via a hybrid Roact/non-Roact
	strategy. While all of the items are rendered and managed via Roact's
	reconciliation step, things that change every frame are managed manually.

	Roact makes it fairly easy to drop in and out of Roact at any point in your
	hierarchy, so if something is too clunky to be declarative or is performance
	sensitive, that's always a way through.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local WorldItem = require(script.Parent.WorldItem)

local getApiFromComponent = require(script.Parent.Parent.getApiFromComponent)
local pickUpItem = require(script.Parent.Parent.thunks.pickUpItem)

local e = Roact.createElement

local World = Roact.Component:extend("World")

function World:init()
	self.api = getApiFromComponent(self)
end

function World:render()
	local children = {}

	for id, item in pairs(self.props.world) do
		children[id] = e(WorldItem, {
			item = item,
			onTouched = function()
				self.props.pickUpItem(self.api, id)
			end,
		})
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