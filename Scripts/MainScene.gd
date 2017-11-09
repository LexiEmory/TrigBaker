extends Control

var minimumValue = 0.0
var maximumValue = 0.0
var step = 0.0
var outputFile = ""
var outputFormat = ""
var function = 0
var processThread = null

var currentX = 0

var outputFileObj = null

func _ready():
	set_process(true)
	pass

func _on_TargetBrowse_pressed():
	get_node("FileDialog").popup()
	pass 


func _on_FileDialog_file_selected( path ):
	get_node("MainVBox/OptionsContainer/TargetFileContainer/TargetInput").set_text(path)
	pass


func _on_StatusStart_pressed():	
	# get options
	minimumValue = get_node("MainVBox/OptionsContainer/StartValueContainer/StartValueSpinbox").get_value()
	maximumValue = get_node("MainVBox/OptionsContainer/EndValueContainer/EndValueSpinbox").get_value()
	step = get_node("MainVBox/OptionsContainer/StepContainer/StepSpinbox").get_value()
	outputFile = get_node("MainVBox/OptionsContainer/TargetFileContainer/TargetInput").get_text()
	outputFormat = get_node("MainVBox/OptionsContainer/OutputFormatContainer/OutputFormatInput").get_text()
	function = get_node("MainVBox/OptionsContainer/FunctionContainer/FunctionOption").get_selected()
	
	# set x
	currentX = minimumValue
	
	# set progress values
	var progressNode = get_node("MainVBox/StatusContainer/StatusProgress")
	progressNode.set_min(minimumValue)
	progressNode.set_max(maximumValue)
	progressNode.set_value(currentX)

	# start process
	processThread = Thread.new()
	processThread.start(self, "processData", true)
	pass

func _process(delta):
	get_node("MainVBox/StatusContainer/StatusProgress").set_value(currentX)
	pass

func processData(testvar):
	var yValue = 0
	
	outputFileObj = File.new()
	outputFileObj.open(outputFile, File.WRITE)
	
	while currentX <= maximumValue:
		if function == 0:
			yValue = cos(currentX)
		elif function == 1:
			yValue = acos(currentX)
		elif function == 2:
			yValue = cosh(currentX)
		elif function == 3:
			yValue = sin(currentX)
		elif function == 4:
			yValue = asin(currentX)
		elif function == 5:
			yValue = sinh(currentX)
		elif function == 6:
			yValue = tan(currentX)
		elif function == 7:
			yValue = atan(currentX)
		elif function == 8:
			yValue = tanh(currentX)
		currentX += step
		outputFileObj.store_line(outputFormat % [String(currentX), String(yValue)])
	
	outputFileObj.close()
	pass
