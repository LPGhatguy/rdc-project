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

	local value = self.__values[key]

	if value == nil then
		return Promise.resolve(nil)
	end

	if value.type == "table" then
		return Promise.resolve(HttpService:JSONDecode(value.value))
	else
		return Promise.resolve(value.value)
	end
end

local writeArgs = Typer.args(
	{"key", Typer.type("string")},
	{"value", Typer.any()}
)
function FakeDataStore.prototype:write(key, value)
	writeArgs(key, value)

	local valueType = typeof(value)

	if valueType == "table" then
		self.__values[key] = {
			type = valueType,
			value = HttpService:JSONEncode(value),
		}
	else
		self.__values[key] = {
			type = valueType,
			value = value,
		}
	end

	return Promise.resolve()
end

return FakeDataStore