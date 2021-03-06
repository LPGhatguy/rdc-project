--[[
	This is a thunk for picking up items!

	Thunks are dispatched just like regular actions, but handled by a special
	middleware included with Rodux but not enabled by default. They can be used
	to get a reference to the store and are useful for causing side effects,
	like sending events over the network!
]]

local function pickUpItem(api, itemId)
	return function(store)
		local state = store:getState()

		local item = state.world[itemId]

		if item == nil then
			warn("Can't pick up item with ID " .. itemId)
			return
		end

		api:pickUpItem(itemId)
	end
end

return pickUpItem