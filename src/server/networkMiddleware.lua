local function networkMiddleware(shouldReplicate, replicateCallback)
	return function(nextDispatch, store)
		return function(action)
			local beforeState = store:getState()
			local result = nextDispatch(action)
			local afterState = store:getState()

			if shouldReplicate(action, beforeState, afterState) then
				replicateCallback(action)
			end

			return result
		end
	end
end

return networkMiddleware