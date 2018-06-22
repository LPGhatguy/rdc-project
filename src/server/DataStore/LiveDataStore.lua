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

local newSchema = {
	Typer.type("name", "string"),
}
function LiveDataStore.new(name)
	Typer.checkArgs(newSchema, name)

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

local readSchema = {
	Typer.type("key", "string"),
}
function LiveDataStore.prototype:read(key)
	Typer.checkArgs(readSchema, key)

	error("NYI")
end

local writeSchema = {
	Typer.type("key", "string"),
	Typer.any("value"),
}
function LiveDataStore.prototype:write(key, value)
	Typer.checkArgs(writeSchema, key, value)

	error("NYI")
end

return LiveDataStore