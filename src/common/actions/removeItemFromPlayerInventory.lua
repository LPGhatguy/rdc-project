local function removeItemFromPlayerInventory(userId, itemId)
	assert(typeof(userId) == "string")
	assert(typeof(itemId) == "string")

	return {
		type = script.Name,
		itemId = itemId,
	}
end

return removeItemFromPlayerInventory