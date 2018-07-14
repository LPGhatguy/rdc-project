--[[
	This Roact component represents our entire game.

	In most cases, you'll only use Roact for constructing your UI, but in this
	project, I elected to try to manage the game world partially with Roact as
	well for fun.

	The traditional top-level component name in React is "App," we generally use
	that for Roact too, but I have a hunch that there's a better name.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Roact = require(ReplicatedStorage.Modules.Roact)

local e = Roact.createElement

local InventoryMenu = require(script.Parent.InventoryMenu)
local World = require(script.Parent.World)

local function Game(props)
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

		-- Even through our UI is being rendered inside a PlayerGui, we can
		-- always take advantage of a feature called portals to put instances
		-- elsewhere.

		-- Portals are a feature that makes having a virtual tree worthwhile,
		-- since implementing them without having formalized destructors is
		-- bug-prone!
		World = e(Roact.Portal, {
			target = Workspace,
		}, {
			World = e(World),
		})
	})
end

return Game