--[[
	This is a thunk for dropping items; a small intro to thunks is available in
	pickUpItem.
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