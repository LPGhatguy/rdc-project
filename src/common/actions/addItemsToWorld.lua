local function addItemsToWorld(items)
	assert(typeof(items) == "table" and #items == 0)

	return {
		type = script.Name,
		items = items,
	}
end

return addItemsToWorld