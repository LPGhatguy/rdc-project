local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local e = Roact.createElement

local InventoryMenu = require(script.Parent.InventoryMenu)

local UI = Roact.Component:extend("UI")

function UI:render()
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
	})
end

return UI