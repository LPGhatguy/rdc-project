--[[
	This component renders a list of inventory items and exposes a callback when
	an individual item in the list is clicked on.

	It has a very simple bottom-up sizing approach based on the number of items
	in the list. The required sizing logic for flexible grids is quite a bit
	more complicated, or else I would've created a drag-and-drop grid instead.

	Often times, we don't want to have to know the size of the items we're
	rendering in grids and lists, but it's difficult to implement that form of
	dynamic bottom-up sizing in Roblox right now. I opted to avoid it entirely.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local e = Roact.createElement

local ITEM_PADDING = 4
local ITEM_HEIGHT = 40

local function Inventory(props)
	local items = props.items
	local onItemClicked = props.onItemClicked

	-- The order that items appear must be deterministic, so we create a list!
	local itemList = {}

	for _, item in pairs(items) do
		table.insert(itemList, item)
	end

	table.sort(itemList, function(a, b)
		return a.name < b.name
	end)

	-- It's easy to dynamically build up children in Roact since the description
	-- of our UI is just a function returning objects.
	local children = {}

	children.Layout = e("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	for index, item in ipairs(itemList) do
		local slot = e("Frame", {
			Size = UDim2.new(1, 0, 0, ITEM_HEIGHT),
			BackgroundColor3 = Color3.new(1, 1, 1),
			LayoutOrder = index,
		}, {
			Inner = e("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -ITEM_PADDING * 2, 1, -ITEM_PADDING * 2),
				Position = UDim2.new(0, ITEM_PADDING, 0, ITEM_PADDING),
				Font = Enum.Font.SourceSans,
				TextSize = 24,
				Text = item.name,
				TextWrap = true,

				[Roact.Event.Activated] = function()
					onItemClicked(item.id)
				end,
			}),
		})

		children[item.id] = slot
	end

	return e("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.5,
		CanvasSize = UDim2.new(1, 0, 0, ITEM_HEIGHT * #itemList),
	}, children)
end

return Inventory