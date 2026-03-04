extends TerminalApplication

func _init():
	app_name="Clear"
	description="Clears the log"
	
func run(terminal : Terminal, params : Array):
	terminal.clear()
