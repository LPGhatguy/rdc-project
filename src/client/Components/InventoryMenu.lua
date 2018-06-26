local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local e = Roact.createElement

local InventoryMenu = Roact.Component:extend("InventoryMenu")

function InventoryMenu:render()
	local children = {}

	for i = 0, 15 do
		local x = (i % 4) / 4
		local y = (math.floor(i / 4) % 4) / 4

		local slot = e("Frame", {
			Size = UDim2.new(0.25, 0, 0.25, 0),
			Position = UDim2.new(x, 0, y, 0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			ZIndex = i,
		})

		children[i] = slot
	end

	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.5,
	}, children)
end

return InventoryMenu