local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Promise = require(ReplicatedStorage.Promise)
local Typer = require(ReplicatedStorage.RDC.Typer)

local FakeDataStore = {}
FakeDataStore.prototype = {}
FakeDataStore.__index = FakeDataStore.prototype

FakeDataStore.__instances = {}

setmetatable(FakeDataStore, {
	__mode = "v",
})

local newArgs = Typer.args(
	{"name", Typer.type("string")}
)
function FakeDataStore.new(name)
	newArgs(name)

	if FakeDataStore.__instances[name] then
		return FakeDataStore.__instances[name]
	end

	local self = {
		__values = {}
	}
	setmetatable(self, FakeDataStore)

	FakeDataStore[name] = self

	return self
end

local readArgs = Typer.args(
	{"key", Typer.type("string")}
)
function FakeDataStore.prototype:read(key)
	readArgs(key)

	local value = HttpService:JSONDecode(key)

	return Promise.resolve(value)
end

local writeArgs = Typer.args(
	{"key", Typer.type("string")},
	{"value", Typer.any()}
)
function FakeDataStore.prototype:write(key, value)
	writeArgs(key, value)

	self.__values[key] = HttpService:JSONEncode(value)

	return Promise.resolve()
end

return FakeDataStore