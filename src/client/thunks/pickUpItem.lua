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