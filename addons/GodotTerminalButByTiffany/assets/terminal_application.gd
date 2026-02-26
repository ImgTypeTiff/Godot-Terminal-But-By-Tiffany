class_name TerminalApplication
var name : String = "Application"
var description : String = ""
const AppList = Terminal.AppRegistry.APPLICATIONS
var _terminal1: Terminal

func run(terminal : Terminal, params : Array):
	_terminal1 = terminal
	terminal.add_to_log("Running Application...")
	
func breakdown_params(params):
	var to_return = []
	for i in range(params.size()):
		var param_breakdown = [params[i], i]
		to_return += [param_breakdown]
	return to_return

func add_to_log(text):
	_terminal1.add_to_log(text)
