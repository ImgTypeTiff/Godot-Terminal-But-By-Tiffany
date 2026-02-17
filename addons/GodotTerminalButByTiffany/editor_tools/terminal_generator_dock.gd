@tool
extends EditorPlugin

var dock
var button

func _enter_tree():
	# Create the dock container
	dock = VBoxContainer.new()
	dock.name = "Terminal Tools" # This is the tab title

	# Create the button
	button = Button.new()
	button.text = "Generate Terminal Registry"
	button.tooltip = "Scan commands folder and regenerate the terminal registry"
	button.pressed.connect(_on_button_pressed)
	dock.add_child(button)

	# Add the dock to the left side
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	dock.show()

func _exit_tree():
	remove_control_from_docks(dock)
	dock.queue_free()

func _on_button_pressed():
	var generator_script = load("res://addons/terminal/tools/generate_terminal_registry.gd")
	if generator_script:
		generator_script.new()._run()
		
		# Show small popup confirmation
		var editor = get_editor_interface()
		var dialog = AcceptDialog.new()
		editor.get_editor_viewport().add_child(dialog)
		dialog.dialog_text = "Terminal registry regenerated!"
		dialog.popup_centered_minsize()
	else:
		push_error("Generator script not found!")
