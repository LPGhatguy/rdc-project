local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Promise)
local Typer = require(ReplicatedStorage.RDC.Typer)

local FakeDataStore = {}
FakeDataStore.prototype = {}
FakeDataStore.__index = FakeDataStore.prototype

FakeDataStore.__instances = {}

setmetatable(FakeDataStore, {
	__mode = "v",
})

local newSchema = {
	Typer.type("name", "string"),
}
function FakeDataStore.new(name)
	Typer.checkArgs(newSchema, name)

	if FakeDataStore.__instances[name] then
		return FakeDataStore.__instances[name]
	end

	local self = {}
	setmetatable(self, FakeDataStore)

	FakeDataStore[name] = self

	return self
end

local readSchema = {
	Typer.type("key", "string"),
}
function FakeDataStore.prototype:read(key)
	Typer.checkArgs(readSchema, key)

	error("NYI")
end

local writeSchema = {
	Typer.type("key", "string"),
	Typer.any("value"),
}
function FakeDataStore.prototype:write(key, value)
	Typer.checkArgs(writeSchema, key, value)

	error("NYI")
end

return FakeDataStore