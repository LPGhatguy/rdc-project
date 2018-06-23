local Typer = {}

local function makeCheck(name, fn)
	local check = {
		isCheck = true,
		name = name,
		fn = fn,
	}

	setmetatable(check, {
		__call = function(_, ...)
			return fn(...)
		end
	})

	return check
end

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

	for index, check in ipairs(schema) do
		local value = select(index, ...)
		local success, err = check.fn(value)

		if not success then
			local message = ("Bad argument %s (#%d), expected %s, but %s"):format(
				"<unknown>",
				index,
				check.name,
				err
			)
			error(message, 3)
		end
	end

	return ...
end

function Typer.args(...)
	local argsSchema = {...}

	return function(...)
		if select("#", ...) > #argsSchema then
			local message = ("Too many arguments passed in. Expected %d arguments or fewer, got %d"):format(
				#argsSchema,
				select("#", ...)
			)
			error(message, 3)
		end

		for index, argSchema in ipairs(argsSchema) do
			local argName = argSchema[1]
			local argCheck = argSchema[2]
			local value = select(index, ...)

			local success, err = argCheck.fn(value)

			if not success then
				local message = ("Bad argument %s (#%d), expected %s, but %s"):format(
					argName,
					index,
					argCheck.name,
					err
				)
				error(message, 3)
			end

		end
	end
end

function Typer.instance(expectedInstanceClass)
	assert(typeof(expectedInstanceClass) == "string", "expectedInstanceClass must be a string")

	local name = ("Instance(%s)"):format(expectedInstanceClass)

	return makeCheck(name, function(value)
		local actualType = typeof(value)

		if actualType ~= "Instance" then
			local message = ("got value of type %s"):format(actualType)

			return false, message
		end

		if value:IsA(expectedInstanceClass) then
			return true
		else
			local message = ("got instance of class %s"):format(value.ClassName)

			return false, message
		end
	end)
end

function Typer.type(expectedType)
	assert(typeof(expectedType) == "string", "expectedType must be a string")

	return makeCheck(expectedType, function(value)
		local actualType = typeof(value)
		if actualType == expectedType then
			return true
		else
			local message = ("got value of type %s"):format(actualType)

			return false, message
		end
	end)
end

function Typer.any()
	return makeCheck("any", function(value)
		if value ~= nil then
			return true
		else
			local message = "got nil"

			return false, message
		end
	end)
end

function Typer.optional(innerCheck)
	assert(typeof(innerCheck) == "table" and innerCheck.isCheck)

	local name = ("optional(%s)"):format(innerCheck.name)

	return makeCheck(name, function(value)
		if value == nil then
			return true
		else
			return innerCheck(value)
		end
	end)
end

function Typer.listOf(innerCheck)
	assert(typeof(innerCheck) == "table" and innerCheck.isCheck)

	local name = ("list(%s"):format(innerCheck.name)

	return makeCheck(name, function(list)
		local actualType = typeof(list)

		if actualType ~= "table" then
			return false, ("got value of type %s"):format(actualType)
		end

		for key, value in pairs(list) do
			local keyType = typeof(key)

			if keyType ~= "number" then
				return false, ("got non-number key %s (of type %s)"):format(tostring(key), keyType)
			end

			local success, err = innerCheck(value)

			if not success then
				return false, ("had bad value at key %d, %s"):format(key, err)
			end
		end

		return true
	end)
end

return Typer