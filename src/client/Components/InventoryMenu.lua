local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local LocalPlayer = Players.LocalPlayer

local e = Roact.createElement

local ITEM_PADDING = 8

local InventoryMenu = Roact.Component:extend("InventoryMenu")

function InventoryMenu:render()
	local children = {}

	local itemList = {}

	for _, item in pairs(self.props.items) do
		table.insert(itemList, item)
	end

	table.sort(itemList, function(a, b)
		return a.id < b.id
	end)

	local i = 0
	for _, item in ipairs(itemList) do
		local x = (i % 4) / 4
		local y = (math.floor(i / 4) % 4) / 4

		local slot = e("Frame", {
			Size = UDim2.new(0.25, 0, 0.25, 0),
			Position = UDim2.new(x, 0, y, 0),
			BackgroundTransparency = 1,
		}, {
			Inner = e("TextLabel", {
				Size = UDim2.new(1, -ITEM_PADDING * 2, 1, -ITEM_PADDING * 2),
				Position = UDim2.new(0, ITEM_PADDING, 0, ITEM_PADDING),
				BackgroundColor3 = item.color,
				Text = item.id,
				TextWrap = true,
			}),
		})

		children[item.id] = slot

		i = i + 1
	end

	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.5,
	}, children)
end

InventoryMenu = RoactRodux.connect(
	function(state)
		return {
			items = state.playerInventories[tostring(LocalPlayer.UserId)],
		}
	end
)(InventoryMenu)

return InventoryMenu