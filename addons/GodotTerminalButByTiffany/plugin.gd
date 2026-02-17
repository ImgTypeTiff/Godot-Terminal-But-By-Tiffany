@tool
extends EditorPlugin

var terminal_dock: VBoxContainer
var generate_button: TextureButton

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const AUTOLOAD_NAME = "Terminal"
const generator_script = preload("res://addons/GodotTerminalButByTiffany/editor_tools/generate_terminal_registry.gd")

func _enter_tree():
	generator_script.new()._run()
	# The autoload can be a scene or script file.
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/GodotTerminalButByTiffany/assets/terminal.gd")
	# (keep all your current initialization code here)
	# Example placeholder:
	print("Terminal plugin initialized")

	# --- Create dock container ---
	terminal_dock = VBoxContainer.new()
	terminal_dock.name = "Terminal Tools"  # this becomes the tab name

	# --- Create the generate button ---
	generate_button = TextureButton.new()
	generate_button.texture_normal = load("res://addons/GodotTerminalButByTiffany/smol.png")
	generate_button.tooltip_text = "Scan commands folder and regenerate the terminal registry"
	generate_button.pressed.connect(_on_generate_pressed)
	terminal_dock.add_child(generate_button)
	generate_button.scale = Vector2(0.1,0.1)

	# --- Add dock to left panel ---
	add_control_to_dock(DOCK_SLOT_LEFT_UL, terminal_dock)
	terminal_dock.show()

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
	if terminal_dock:
		remove_control_from_docks(terminal_dock)
		terminal_dock.queue_free()

func _on_generate_pressed():
	var generator_script = load("res://addons/GodotTerminalButByTiffany/editor_tools/generate_terminal_registry.gd")
	if generator_script:
		generator_script.new()._run()

		# Show small popup confirmation
		var dialog = AcceptDialog.new()
		get_editor_interface().get_base_control().add_child(dialog)
		dialog.dialog_text = "Terminal registry regenerated!"
		dialog.popup_centered()
	else:
		push_error("Generator script not found!")
