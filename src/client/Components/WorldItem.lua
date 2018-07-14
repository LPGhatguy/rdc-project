--[[
	Represents in an item as it's visible in the game world.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local e = Roact.createElement

local YAxisBillboard = require(script.Parent.YAxisBillboard)

local function WorldItem(props)
	local item = props.item
	local onTouched = props.onTouched

	return e("Part", {
		CFrame = CFrame.new(item.position),
		Size = Vector3.new(2, 0.5, 2),
		Color = item.color,
		Anchored = true,

		-- Roact can handle setting up events for us, and will automatically
		-- disconnect and reconnect them as needed.
		[Roact.Event.Touched] = function(_, otherPart)
			-- I think this is the best way to make sure this is a character
			-- touching the item?

			local character = Players.LocalPlayer.Character

			if character == nil then
				return
			end

			if not otherPart:IsDescendantOf(character) then
				return
			end

			onTouched()
		end,
	}, {
		UI = e(YAxisBillboard, {
			position = item.position + Vector3.new(0, 2, 0),
			size = Vector2.new(3, 3),
		}, {
			Name = e("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.SourceSans,
				TextSize = 60,
				Text = item.name,
				TextWrap = true,
				BackgroundColor3 = Color3.fromRGB(4, 134, 204),
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
			}),
		}),
	})
end

return WorldItem