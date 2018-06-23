local Typer = require(script.Parent.Typer)

return {
	clientStart = {
		from = "client",
		arguments = Typer.args(),
	},
	coolStoryClient = {
		from = "server",
		arguments = Typer.args(
			{"voxelPiece", Typer.instance("Part")}
		),
	},
}