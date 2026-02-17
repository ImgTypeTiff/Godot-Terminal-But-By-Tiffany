@tool
extends EditorScript

const FONT_PATH := "res://addons/GodotTerminalButByTiffany/Font/"
const APPS_PATH := "res://addons/GodotTerminalButByTiffany/applications/"
const APP_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/app_registry.gd"
const FONT_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/font_registry.gd"

func _run():
	var dir := DirAccess.open(APPS_PATH)
	if dir == null:
		push_error("Applications folder not found: " + APPS_PATH)
		return

	var files := []
	for f in dir.get_files():
		if f.ends_with(".gd"):
			var full_path := APPS_PATH + f
			if FileAccess.file_exists(full_path):
				files.append(f)
			else:
				push_error("Skipping missing file: " + full_path)

	files.sort()

	if files.size() == 0:
		push_warning("No valid command scripts found in " + APPS_PATH)
		return

	var lines := []
	lines.append("# AUTO-GENERATED — DO NOT EDIT")
	lines.append("")
	lines.append("const APPLICATIONS := {")

	for i in range(files.size()):
		var name = files[i].get_basename()
		var full_path = APPS_PATH + files[i]
		# write preload only if file exists
		if FileAccess.file_exists(full_path):
			var line := '\t"%s": preload("%s")' % [name, full_path]
			if i < files.size() - 1:
				line += ","
			lines.append(line)
			print("Registering command:", name)
		else:
			push_warning("Skipping missing file: " + full_path)
	
	lines.append("}")
	
	# ensure output folder exists
	DirAccess.make_dir_recursive_absolute("res://addons/GodotTerminalButByTiffany/registries")

	var f := FileAccess.open(APP_OUTPUT_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Failed to open output file: " + APP_OUTPUT_PATH)
		return
	f.store_string("\n".join(lines))
	f.close()

	print("Registry generated successfully at:", APP_OUTPUT_PATH)
	font_registry()

func font_registry():
	var dir = DirAccess.open(FONT_PATH)
	for f in dir.get_files():
		if f.ends_with(".ttf"):
			var lines := []
			lines.append("# AUTO-GENERATED — DO NOT EDIT")
			lines.append("")
			lines.append("const APPLICATIONS := {")
			var full_path = FONT_PATH + f
			var name = f
			var line = '\t"%s": preload("%s")' % ["font", full_path]
			lines.append(line)
			lines.append("}")
			var gun = FileAccess.open(FONT_OUTPUT_PATH, FileAccess.WRITE)
			if gun == null:
				push_error("Failed to open output file: " + APP_OUTPUT_PATH)
				return
			gun.store_string("\n".join(lines))
			gun.close()
