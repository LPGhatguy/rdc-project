local function removeItemFromWorld(itemId)
	assert(typeof(itemId) == "string")

	return {
		type = script.Name,
		itemId = itemId,
	}
end

return removeItemFromWorld