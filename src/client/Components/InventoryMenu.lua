local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Inventory = require(script.Parent.Inventory)

local e = Roact.createElement

local InventoryMenu = Roact.Component:extend("InventoryMenu")

function InventoryMenu:init()
	self.state = {
		open = false,
	}
end

function InventoryMenu:render()
	if not self.state.open then
		return nil
	end

	return e(Inventory, {
		items = self.props.items,
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
			items = state.playerInventories[tostring(Players.LocalPlayer.UserId)],
		}
	end
)(InventoryMenu)

return InventoryMenu