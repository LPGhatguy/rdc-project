local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Roact = require(ReplicatedStorage.Modules.Roact)

local e = Roact.createElement

local InventoryMenu = require(script.Parent.InventoryMenu)
local World = require(script.Parent.World)

local function Game(props)
	local api = props.api

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

		World = e(Roact.Portal, {
			target = Workspace,
		}, {
			World = e(World, {
				api = api,
			}),
		})
	})
end

return Game