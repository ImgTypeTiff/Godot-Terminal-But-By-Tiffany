@tool
extends EditorPlugin

var button
var container

func _enter_tree():
	container = HBoxContainer.new()
	
	button = Button.new()
	button.text = "Generate Terminal Registry"
	button.tooltip = "Scan commands folder and regenerate the terminal registry"
	button.pressed.connect(_on_button_pressed)
	container.add_child(button)
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, container)
	container.show()

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, container)
	container.queue_free()

func _on_button_pressed():
	var generator_script = load("res://addons/terminal/editor_tools/generate_terminal_registry.gd")
	if generator_script:
		generator_script.new()._run()
		
		# show small popup confirmation
		var editor = get_editor_interface()
		var dialog = AcceptDialog.new()
		editor.get_editor_viewport().add_child(dialog)
		dialog.dialog_text = "Terminal registry regenerated!"
		dialog.popup_centered_minsize()
	else:
		push_error("Generator script not found!")
