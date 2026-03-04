extends TerminalApplication

func _init():
	app_name="Help"
	description="Shows descriptions of all available programs"
	
func run(terminal : Terminal, params : Array):
	if(is_verbose(params)):
		for key in AppList:
			var application: TerminalApplication = AppList[key].new()
			var help_text = key + " - " + application.app_name + ": " + application.description
			terminal.add_to_log(help_text)
		pass
	else:
		for key in AppList:
			terminal.add_to_log(key)
		pass


func is_verbose(params):
	var verbose_tags = ['verbose','-v']
	for param in params:
		if param.to_lower() in verbose_tags:
			return true
	return false
