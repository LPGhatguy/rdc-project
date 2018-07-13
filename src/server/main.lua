local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules

local Rodux = require(Modules.Rodux)

-- The Rodux DevTools aren't available yet! Check the README for more details.
-- local RoduxVisualizer = require(Modules.RoduxVisualizer)

local commonReducers = require(Modules.RDC.commonReducers)
local Dictionary = require(Modules.RDC.Dictionary)
local Item = require(Modules.RDC.objects.Item)

local addPlayer = require(Modules.RDC.actions.addPlayer)
local addItemsToPlayerInventory = require(Modules.RDC.actions.addItemsToPlayerInventory)
local removeItemFromPlayerInventory = require(Modules.RDC.actions.removeItemFromPlayerInventory)
local addItemsToWorld = require(Modules.RDC.actions.addItemsToWorld)
local removeItemFromWorld = require(Modules.RDC.actions.removeItemFromWorld)

local serverReducers = require(script.Parent.serverReducers)
local ServerApi = require(script.Parent.ServerApi)
local networkMiddleware = require(script.Parent.networkMiddleware)
local getRandomItemName = require(script.Parent.getRandomItemName)

return function(context)
	local reducer = Rodux.combineReducers(Dictionary.join(commonReducers, serverReducers))

	local api

	--[[
		This function contains our custom replication logic for Rodux actions.

		Using the Redux pattern as a way to sychronize replicated data is a new
		idea. Vocksel introduced the idea to me, and I used this project partly
		as a test bed to try it out.
	]]
	local function replicate(action, beforeState, afterState)
		-- Create a version of each action that's explicitly flagged as
		-- replicated so that clients can handle them explicitly.
		local replicatedAction = Dictionary.join(action, {
			replicated = true,
		})

		-- This is an action that everyone should see!
		if action.replicateBroadcast then
			return api:storeAction(ServerApi.AllPlayers, replicatedAction)
		end

		-- This is an action that we want a specific player to see.
		if action.replicateTo ~= nil then
			local player = Players:GetPlayerByUserId(action.replicateTo)

			if player == nil then
				return
			end

			return api:storeAction(player, replicatedAction)
		end

		-- We should probably replicate any actions that modify data shared
		-- between the client and server.
		for key in pairs(commonReducers) do
			if beforeState[key] ~= afterState[key] then
				return api:storeAction(ServerApi.AllPlayers, replicatedAction)
			end
		end

		return
	end

	--[[
		For hot-reloading, we want to save a list of every action that gets run
		through the store. This lets us iterate on our reducers, but otherwise
		keep any state we want across reloads.
	]]
	local function saveActionsMiddleware(nextDispatch)
		return function(action)
			table.insert(context.savedActions, action)

			return nextDispatch(action)
		end
	end

	-- This is a case where the simplicify of reducers shines!
	-- We produce the state that this store should start at based on the actions
	-- that the previous store had executed.
	local initialState = nil
	for _, action in ipairs(context.savedActions) do
		initialState = reducer(initialState, action)
	end

	-- local devTools = RoduxVisualizer.createDevTools({
	-- 	mode = RoduxVisualizer.Mode.Plugin,
	-- })

	local middleware = {
		-- Our minimal middleware to save actions to our context.
		saveActionsMiddleware,

		-- Middleware to replicate actions to the client, using the replicate
		-- callback defined above.
		networkMiddleware(replicate),

		-- Once the Rodux DevTools are available, this will be revisited!
		-- devTools.middleware,
	}

	local store = Rodux.Store.new(reducer, initialState, middleware)

	-- Construct our ServerApi, which creates RemoteEvent objects for our
	-- clients to listen to.
	api = ServerApi.create({
		clientStart = function(player)
			store:dispatch(addPlayer(tostring(player.UserId)))

			api:initialStoreState(player, store:getState())
		end,

		pickUpItem = function(player, itemId)
			local state = store:getState()
			local item = state.world[itemId]

			if item == nil then
				warn("Player can't pick up item " .. itemId)
				return
			end

			store:dispatch(removeItemFromWorld(itemId))
			store:dispatch(addItemsToPlayerInventory(tostring(player.UserId), {
				[itemId] = item,
			}))
		end,

		dropItem = function(player, itemId)
			local playerId = tostring(player.UserId)
			local state = store:getState()
			local inventory = state.playerInventories[playerId]

			if inventory == nil then
				warn("Couldn't find player inventory " .. playerId)
				return
			end

			local item = inventory[itemId]

			if item == nil then
				warn("Player can't drop item " .. itemId)
				return
			end

			local character = player.Character

			if character == nil then
				warn("Can't drop item for player, no character: " .. playerId)
				return
			end

			local root = character:FindFirstChild("HumanoidRootPart")

			if root == nil then
				warn("No HumanoidRootPart in character from " .. playerId)
				return
			end

			local newPosition = root.Position + root.CFrame.lookVector * 4
			local newItem = Dictionary.join(item, {
				position = newPosition,
			})

			store:dispatch(removeItemFromPlayerInventory(playerId, itemId))
			store:dispatch(addItemsToWorld({
				[itemId] = newItem,
			}))
		end,
	})

	-- The hot-reloading shim has a place for us to stick destructors, since we
	-- need to clean up everything on the server before unloading.
	table.insert(context.destructors, function()
		store:destruct()
	end)

	table.insert(context.destructors, function()
		api:destroy()
	end)

	local worldItems = {}
	for _ = 1, 15 do
		local item = Item.new()
		local x = math.random(-20, 20)
		local z = math.random(-20, 20)

		item.position = Vector3.new(x, 1.5, z)
		item.name = getRandomItemName()

		worldItems[item.id] = item
	end

	store:dispatch(addItemsToWorld(worldItems))

	print("Server started!")
end