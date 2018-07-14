--[[
	This component wraps an Inventory component and connects to the store and
	API instance to provide real functionality.

	It also connects to UserInputService to allow the drawer to be opened with
	the 'E' key.

	Note that this component has almost no UI logic of its own outside plumbing
	methods down to Inventory. This is a common pattern in React and Roact and
	makes it really easy to re-use display logic in multiple places.

	A good rule of thumb is to design components without thinking about Rodux or
	where data comes from. Once that's complete, write smart wrapper components
	that own state, connect to the store, and perform side effects. This will
	usually give you really nice, easy to reason about code.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Inventory = require(script.Parent.Inventory)
local dropItem = require(script.Parent.Parent.thunks.dropItem)
local getApiFromComponent = require(script.Parent.Parent.getApiFromComponent)

local e = Roact.createElement

local InventoryMenu = Roact.Component:extend("InventoryMenu")

function InventoryMenu:init()
	self.state = {
		open = false,
	}

	self.api = getApiFromComponent(self)
end

function InventoryMenu:render()
	if not self.state.open then
		return nil
	end

	return e(Inventory, {
		items = self.props.items,
		onItemClicked = function(itemId)
			self.props.dropItem(self.api, itemId)
		end,
	})
end

function InventoryMenu:didMount()
	-- We have a couple utilities internally that we use to manage connections
	-- to services declaratively.
	-- I opted not to use those in this example to be more explicit.
	self._connection = UserInputService.InputEnded:Connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if inputObject.keyCode ~= Enum.KeyCode.E then
			return
		end

		-- We use the function variant of setState here despite it being more
		-- complicated because we depend on the previous value of state.
		-- Roact doesn't guarantee that state updates happen immediately, so if
		-- the user is mashing their E key to toggle the inventory, we want to
		-- make sure we don't lose any of those events.
		self:setState(function(state)
			return {
				open = not state.open,
			}
		end)
	end)
end

function InventoryMenu:willUnmount()
	self._connection:Disconnect()
end

InventoryMenu = RoactRodux.connect(
	function(state)
		-- Our component will update iff the player's inventory updates.
		return {
			items = state.inventory,
		}
	end,
	function(dispatch)
		return {
			dropItem = function(...)
				return dispatch(dropItem(...))
			end,
		}
	end
)(InventoryMenu)

return InventoryMenu