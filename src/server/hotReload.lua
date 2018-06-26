local ReplicatedStorage = game:GetService("ReplicatedStorage")

local reloadScheduled = false

local reloadBindable = Instance.new("RemoteEvent")
reloadBindable.Name = "HotReloaded"
reloadBindable.Parent = ReplicatedStorage

local function listenToChangesRecursive(root, connections, callback)
	table.insert(connections, (root.Changed:Connect(callback)))
	table.insert(connections, (root.ChildAdded:Connect(callback)))

	for _, child in ipairs(root:GetChildren()) do
		listenToChangesRecursive(child, connections, callback)
	end
end

local function replace(object)
	-- Do you ever get that feeling that everything in your house has been
	-- replaced by an exact replica?

	local new = object:Clone()
	new.Parent = object.Parent
	object:Destroy()
end

local function hotReload(options)
	local objectsToWatch = options.watch
	local beforeUnload = options.beforeUnload
	local afterReload = options.afterReload

	local connections = {}

	local function changeCallback()
		if reloadScheduled then
			return
		end

		reloadScheduled = true

		spawn(function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end

			beforeUnload()

			for _, object in ipairs(objectsToWatch) do
				replace(object)
			end

			wait(0)

			afterReload()
			reloadBindable:FireAllClients()

			reloadScheduled = false
		end)
	end

	spawn(function()
		for _, object in ipairs(objectsToWatch) do
			listenToChangesRecursive(object, connections, changeCallback)
		end
	end)
end

return hotReload