extends Node

signal print_log(statement : String)
signal force_log(statements : Array)
var profile_list: Array = ["tiffany@terminal"]
var profile = profile_list[0]
var log : Array = []
var path := "res://addons/GodotTerminalButByTiffany/applications/"

var variables := {
	"camid": Callable(self, "get_cam_id")
}
const FontRegistry = preload("res://addons/GodotTerminalButByTiffany/registries/font_registry.gd").APPLICATIONS
const AppRegistry = preload("res://addons/GodotTerminalButByTiffany/registries/app_registry.gd")

func get_cam_id() -> String:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return "null"
	return str(cam.get_instance_id())


func run_command(command : String):
	add_to_log(profile + ": " + command)

	var regex := RegEx.new()
	regex.compile("[^\\s\"']+|\"([^\"]*)\"|'([^']*)'")
	var split_command := regex.search_all(command).map(
		func(x): return x.get_string().strip_edges()
	)

	for i in range(split_command.size()):
		var s = split_command[i]
		if s.begins_with("$"):
			var v := variables.get(s.substr(1), s)
			if v is Callable:
				s = str(v.call())
			else:
				s = str(v)
		split_command[i] = s

	if split_command.is_empty():
		return

	run_application(split_command[0], split_command.slice(1))

func run_application(application_id: String, params: Array):
	if AppRegistry.APPLICATIONS.has(application_id):
		AppRegistry.APPLICATIONS[application_id].new().run(self, params)
	else:
		add_to_log("Application not found")

func add_to_log(statement : String):
	log.append(statement)
	emit_signal("print_log", statement)
