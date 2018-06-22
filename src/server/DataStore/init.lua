local RunService = game:GetService("RunService")

local LiveDataStore = require(script.LiveDataStore)
local FakeDataStore = require(script.FakeDataStore)

local DataStore = {}

function DataStore.new(name)
	if RunService:IsStudio() then
		return FakeDataStore.new(name)
	else
		return LiveDataStore.new(name)
	end
end

function DataStore.newLive(name)
	return LiveDataStore.new(name)
end

function DataStore.newFake(name)
	return FakeDataStore.new(name)
end

return DataStore