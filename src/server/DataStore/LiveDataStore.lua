local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Promise = require(ReplicatedStorage.Promise)
local Typer = require(ReplicatedStorage.RDC.Typer)

local LiveDataStore = {}
LiveDataStore.prototype = {}
LiveDataStore.__index = LiveDataStore.prototype

LiveDataStore.__instances = {}

setmetatable(LiveDataStore, {
	__mode = "v",
})

local newArgs = Typer.args(
	{"name", Typer.type("string")}
)
function LiveDataStore.new(name)
	newArgs(name)

	if LiveDataStore.__instances[name] then
		return LiveDataStore.__instances[name]
	end

	local self = {
		__internal = DataStoreService:GetDataStore(name),
	}
	setmetatable(self, LiveDataStore)

	LiveDataStore[name] = self

	return self
end

local readArgs = Typer.args(
	{"key", Typer.type("string")}
)
function LiveDataStore.prototype:read(key)
	readArgs(key)

	return Promise.new(function(resolve, reject)
		spawn(function()
			local success, result = self.__internal.GetAsync(self.__internal, key)

			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

local writeArgs = Typer.args(
	{"key", Typer.type("string")},
	{"value", Typer.any()}
)
function LiveDataStore.prototype:write(key, value)
	writeArgs(key, value)

	return Promise.new(function(resolve, reject)
		spawn(function()
			local success, result = self.__internal.SetAsync(self.__internal, key, value)

			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

return LiveDataStore