@tool
extends EditorScript
const REGISTRIES_FOLDER := "res://addons/GodotTerminalButByTiffany/registries"
const FONT_PATH := "res://addons/GodotTerminalButByTiffany/Font/"
const APPS_PATH := "res://addons/GodotTerminalButByTiffany/assets/applications/"
const APP_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/app_registry.gd"
const FONT_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/font_registry.gd"
const FILE_OUTPUT_PATH := "res://addons/GodotTerminalButByTiffany/registries/file_registry.gd"

const VALID_EXTENSIONS := [
	"tscn",
	"tres",
	"res",
	"gd",
	"png",
	"ogg",
	"wav",
	"mp3",
	"ttf",
	"svg",
]

var directories: Array = []
var files: Array = []
var file_names = []


func _run():
	DirAccess.make_dir_recursive_absolute("res://addons/GodotTerminalButByTiffany/registries")
	scan_for_files(APP_OUTPUT_PATH,APPS_PATH,"")
	scan_for_files(FONT_OUTPUT_PATH,FONT_PATH,"")
	recursive_dict()

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
	write(lines,PLACE_TO_SAVE)

func dir_contents(path):
	print(path)
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if !file_name.begins_with("."):
					directories.append(path + file_name)
			else:
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

func recursive_dict():
	var tree = scan_directory("res://", true)

	write_dictionary_as_gd(
		"FILES",
		tree,
		FILE_OUTPUT_PATH
	)

var no_go = ["res://addons/GodotTerminalButByTiffany/registries","res://addons/GodotTerminalButByTiffany/assets/applications" , "res://addons/GodotTerminalButByTiffany/assets/editor_tools","res://addons/GodotTerminalButByTiffany"]

func scan_directory(path: String, include_extension := false) -> Dictionary:
	var result := {}
	
	if no_go.has(path):
		return result
	var dir := DirAccess.open(path)
	if dir == null:
		return result
	print(path)
	dir.list_dir_begin()
	var name := dir.get_next()

	while name != "":
		if name.begins_with("."):
			name = dir.get_next()
			continue
		var full_path
		if path == "res://":
			full_path = path + name
		else:
			full_path = path + "/" + name

		if dir.current_is_dir():
			# Folder → nested dictionary
			if !no_go.has(full_path):
				result[name] = scan_directory(full_path, include_extension)
		else:
			if !no_go.has(full_path):
				var ext := name.get_extension()
				if VALID_EXTENSIONS.has(ext):
					var key := name.get_basename()
					if include_extension:
						key += "." + ext
					if !full_path == FILE_OUTPUT_PATH:
						result[key] = full_path

		name = dir.get_next()

	dir.list_dir_end()
	return result

func write_dictionary_as_gd(name: String, dict: Dictionary, path: String):
	var lines := []
	lines.append("const %s := %s" % [name, _dict_to_string(dict, 0)])

	write(lines, path)

func _dict_to_string(dict: Dictionary, indent := 0) -> String:
	var tabs := "\t".repeat(indent)
	var inner := []

	var keys := dict.keys()
	keys.sort()

	for key in keys:
		var value = dict[key]

		if value is Dictionary:
			inner.append('%s"%s": %s' % [
				tabs + "\t",
				key,
				_dict_to_string(value, indent + 1)
			])
		elif value is String:
			inner.append('%s"%s": preload("%s")' % [
				tabs + "\t",
				key,
				value
			])
		else:
			push_error(
				"Invalid value type in registry: %s (%s)" %
				[value, typeof(value)]
			)

	return "{\n%s\n%s}" % [
		",\n".join(inner),
		tabs
	]
