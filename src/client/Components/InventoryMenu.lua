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
		onDropItem = function(itemId)
			self.props.dropItem(self.api, itemId)
		end,
	})
end

function InventoryMenu:didMount()
	self._connection = UserInputService.InputEnded:Connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if inputObject.keyCode ~= Enum.KeyCode.E then
			return
		end

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