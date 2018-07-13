local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local getApiFromComponent = require(script.Parent.Parent.getApiFromComponent)
local pickUpItem = require(script.Parent.Parent.thunks.pickUpItem)

local e = Roact.createElement

local World = Roact.Component:extend("World")

function World:init()
	self.state = {
		cameraCFrame = CFrame.new(),
	}

	self.api = getApiFromComponent(self)
end

function World:render()
	local children = {}

	for id, item in pairs(self.props.world) do
		local angle = math.atan2(
			item.position.x - self.state.cameraCFrame.p.x,
			item.position.z - self.state.cameraCFrame.p.z)

		local uiLocation = CFrame.Angles(0, angle, 0) + item.position + Vector3.new(0, 2, 0)

		local object = e("Part", {
			CFrame = CFrame.new(item.position),
			Size = Vector3.new(2, 0.5, 2),
			Color = item.color,
			Anchored = true,

			[Roact.Event.Touched] = function(_, otherPart)
				local character = Players.LocalPlayer.Character

				if character == nil then
					return
				end

				if not otherPart:IsDescendantOf(character) then
					return
				end

				self.props.pickUpItem(self.api, id)
			end,
		}, {
			UIPart = e("Part", {
				CFrame = uiLocation,
				Size = Vector3.new(3, 3, 0.5),
				Transparency = 1,
				Anchored = true,
				CanCollide = false,
			}, {
				UI = e("SurfaceGui", {
					Face = Enum.NormalId.Front,
					CanvasSize = Vector2.new(400, 400),
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
			}),
		})

		children[id] = object
	end

	return e("Folder", nil, children)
end

function World:didMount()
	self._connection = RunService.Stepped:Connect(function()
		self:setState({
			cameraCFrame = Workspace.CurrentCamera.CFrame,
		})
	end)
end

function World:willUnmount()
	self._connection:Disconnect()
end

World = RoactRodux.connect(
	function(state)
		return {
			world = state.world,
		}
	end,
	function(dispatch)
		return {
			pickUpItem = function(...)
				return dispatch(pickUpItem(...))
			end,
		}
	end
)(World)

return World