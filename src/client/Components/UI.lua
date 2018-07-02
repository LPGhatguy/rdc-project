local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local e = Roact.createElement

local InventoryMenu = require(script.Parent.InventoryMenu)

local UI = Roact.Component:extend("UI")

function UI:render()
	local value = self.props.value

	return e("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	}, {
		InventoryContainer = e("Frame", {
			Size = UDim2.new(0, 400, 0, 400),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			Inventory = e(InventoryMenu),
		}),
		Label = e("TextLabel", {
			Size = UDim2.new(0, 120, 0, 40),
			Position = UDim2.new(0, 50, 0, 50),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Text = "Value: " .. value,
		})
	})
end

UI = RoactRodux.connect(function(state)
	return {
		value = state,
	}
end)(UI)

return UI