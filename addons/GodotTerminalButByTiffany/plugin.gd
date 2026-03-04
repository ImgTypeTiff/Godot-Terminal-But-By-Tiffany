@tool
extends EditorPlugin

var terminal_dock: VBoxContainer
var generate_button: TextureButton

const TERMINAL_AUTOLOAD_NAME = "Terminal"
const SCENELOADER_AUTOLOAD_NAME = "Loading"

func _enter_tree():
	add_autoload_singleton(TERMINAL_AUTOLOAD_NAME, "res://addons/GodotTerminalButByTiffany/assets/terminal.gd")
	#add_autoload_singleton(SCENELOADER_AUTOLOAD_NAME, "res://addons/GodotTerminalButByTiffany/assets/loading/loading.tscn")
	var fs := EditorInterface.get_resource_filesystem()
	fs.connect("filesystem_changed", Callable(self, "_on_filesystem_changed"))
	print("Terminal plugin initialized")
# uid://ckypo4jsjuepe uid://ckypo4jsjuepe
func _exit_tree():
	remove_autoload_singleton(TERMINAL_AUTOLOAD_NAME)
	#remove_autoload_singleton(SCENELOADER_AUTOLOAD_NAME)
	var fs := EditorInterface.get_resource_filesystem()
	if fs.is_connected("filesystem_changed", Callable(self, "_on_filesystem_changed")):
		fs.disconnect("filesystem_changed", Callable(self, "_on_filesystem_changed"))


func _on_filesystem_changed():
	var generator_script = load("res://addons/GodotTerminalButByTiffany/assets/editor_tools/generate_terminal_registry.gd")
	if generator_script:
		generator_script.new()._run()
	print("filesystem changed")
