local Typer = require(script.Parent.Typer)

return {
	clientStart = {
		from = "client",
		arguments = Typer.args(),
	},
	initialStoreState = {
		from = "server",
		arguments = Typer.args(
			{"state", Typer.any()}
		)
	},
	storeAction = {
		from = "server",
		arguments = Typer.args(
			{"action", Typer.type("table")}
		)
	},
}