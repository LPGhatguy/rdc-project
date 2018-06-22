local Typer = {}

function Typer.decorate(schema, fn)
	return function(...)
		Typer.checkArgs(schema, ...)

		return fn(...)
	end
end

function Typer.checkArgs(schema, ...)
	if select("#", ...) > #schema then
		local message = ("Too many arguments passed in. Expected %d arguments or fewer, got %d"):format(
			#schema,
			select("#", ...)
		)
		error(message, 3)
	end

	for index, entry in ipairs(schema) do
		local value = select(index, ...)
		local success, err = entry(value, index)

		if not success then
			error(err, 3)
		end
	end

	return ...
end

function Typer.instance(argName, expectedInstanceClass)
	assert(typeof(argName) == "string", "argName must be a string")
	assert(typeof(expectedInstanceClass) == "string", "expectedInstanceClass must be a string")

	return function(value, index)
		local actualType = typeof(value)

		if actualType ~= "Instance" then
			local message = ("Bad argument %s (#%d), expected instance that is a %s, got value of type %s"):format(
				argName,
				index,
				expectedInstanceClass,
				actualType
			)

			return false, message
		end

		if value:IsA(expectedInstanceClass) then
			return true
		else
			local message = ("Bad argument %s (#%d), expected instance that is a %s, got instance of class %s"):format(
				argName,
				index,
				expectedInstanceClass,
				value.ClassName
			)

			return false, message
		end
	end
end

function Typer.type(argName, expectedType)
	assert(typeof(argName) == "string", "argName must be a string")
	assert(typeof(expectedType) == "string", "expectedType must be a string")

	return function(value, index)
		local actualType = typeof(value)
		if actualType == expectedType then
			return true
		else
			local message = ("Bad argument %s (#%d), expected value of type %s, got value of type %s"):format(
				argName,
				index,
				expectedType,
				actualType
			)

			return false, message
		end
	end
end

function Typer.any(argName)
	assert(typeof(argName) == "string", "argName must be a string")

	return function(value, index)
		if value ~= nil then
			return true
		else
			local message = ("Bad argument %s (#%d), expected any non-nil value, got nil"):format(
				argName,
				index
			)

			return false, message
		end
	end
end

function Typer.optional(innerCheck)
	assert(typeof(innerCheck) == "function")

	return function(value)
		if value == nil then
			return true
		else
			return innerCheck(value)
		end
	end
end

return Typer