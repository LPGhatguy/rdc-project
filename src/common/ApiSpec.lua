local Typer = require(script.Parent.Typer)

return {
	clientStart = {
		from = "client",
		arguments = {},
	},
	coolStoryClient = {
		from = "server",
		arguments = {
			Typer.instance("voxelPiece", "Part"),
		},
	},
}