local function networkMiddleware(replicate)
	return function(nextDispatch, store)
		return function(action)
			local beforeState = store:getState()
			local result = nextDispatch(action)
			local afterState = store:getState()

			replicate(action, beforeState, afterState)

			return result
		end
	end
end

return networkMiddleware