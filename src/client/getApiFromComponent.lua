local function getApiFromComponent(componentInstance)
	local api = componentInstance._context.ClientApi

	if api == nil then
		error("Failed to find ClientApi in component's context!", 2)
	end

	return api
end

return getApiFromComponent