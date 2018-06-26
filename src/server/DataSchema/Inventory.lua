local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Typer = require(ReplicatedStorage.RDC.Typer)

local Item = Typer.object({
	id = Typer.type("string"),
	itemKind = Typer.type("string"),
})

local Inventory = Schema.perUser({
	[1] = Typer.object({
		items = Typer.listOf(Item),
	})
})

return Inventory