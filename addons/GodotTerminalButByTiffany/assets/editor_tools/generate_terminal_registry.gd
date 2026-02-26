@tool
extends EditorScript

const FONT_PATH := "res://addons/GodotTerminalButByTiffany/Font/"
const APPS_PATH := "res://addons/GodotTerminalButByTiffany/assets/applications/"
const APP_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/app_registry.gd"
const FONT_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/font_registry.gd"
const FILE_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/file_registry.gd"


var directories: Array = []
var files: Array = []
var file_names = []


func _run():
	DirAccess.make_dir_recursive_absolute("res://addons/GodotTerminalButByTiffany/registries")
	scan_for_files(APP_OUTPUT_PATH,APPS_PATH,"")
	scan_for_files(FONT_OUTPUT_PATH,FONT_PATH,"")

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

func scan_for_files(PLACE_TO_SAVE: String, PLACE_TO_SCAN,type,include_extension: bool = false):
	files = []
	directories = []
	var lines := []
	lines.append("const APPLICATIONS := {")
	dir_contents(PLACE_TO_SCAN)
	for dir in directories:
		if dir.begins_with("."):
			pass
		elif dir.ends_with(".cache"):
			pass
		else:
			dir_contents(dir + "/")
	for file in files:
		var pure_file = file.get_file().get_basename()
		if ResourceLoader.exists(file):
			if include_extension:
				pure_file += "." + file.get_file().get_extension()
				print(file.get_file().get_extension())
			if file.is_empty():
				var line = '\t"%s": preload("%s"),' % [pure_file,file]
				lines.append(line)
			elif file.ends_with(type):
				var line = '\t"%s": preload("%s"),' % [pure_file,file]
				lines.append(line)
	lines.append("}")
	print("\n".join(lines))
	write(lines,PLACE_TO_SAVE)

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				if !file_name.begins_with("."):
					directories.append(path + file_name)
			else:
				print("Found file: " + file_name)
				if !file_name.begins_with("."):
					files.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func write(lines, path):
	var gun = FileAccess.open(path, FileAccess.WRITE)
	if gun == null:
		push_error("Failed to open output file: " + APP_OUTPUT_PATH)
		return
	gun.store_string("\n".join(lines))
	gun.close()
