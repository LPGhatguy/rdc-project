local HttpService = game:GetService("HttpService")

local function getId()
	return HttpService:GetGUID(false)
end

local Item = {}

function Item.new()
	local self = {
		id = getId(),
	}

	return self
end

return Item