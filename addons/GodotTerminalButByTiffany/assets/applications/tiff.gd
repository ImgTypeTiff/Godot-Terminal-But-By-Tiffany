extends TerminalApplication

var test = preload("res://addons/GodotTerminalButByTiffany/registries/file_registry.gd")

func _init():
	app_name="Test"
	description="Print Test"
	
func run(terminal : Terminal, params : Array):
	terminal.add_to_log(str(test.FILES))
	
