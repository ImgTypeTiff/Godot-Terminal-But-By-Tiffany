extends TerminalApplication

func _init():
	app_name="tiff"
	description="the scene loader of all time."
	
func run(terminal : Terminal, params : Array):
	terminal.add_to_log("Running Application")
