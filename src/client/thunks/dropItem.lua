--[[
	This is a thunk for picking up items!

	Thunks are dispatched just like regular actions, but handled by a special
	middleware included with Rodux but not enabled by default. They can be used
	to get a reference to the store and are useful for causing side effects,
	like sending events over the network!
]]

local function dropItem(api, itemId)
	return function(store)
		local state = store:getState()

		local item = state.inventory[itemId]

		if item == nil then
			warn("Can't drop item with ID " .. itemId)
			return
		end

		api:dropItem(itemId)
	end
end

return dropItem