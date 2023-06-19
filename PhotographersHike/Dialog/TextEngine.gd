extends Control
#I know that the head node is a control node (not Node2D), but I didn't want to create issues by renaming the node


const dialog_json_filepath: String = "res://dialog.json" #don't have the file yet

const OptionScale = Vector2(0.4, 0.2)




var next_indicator = load("res://Dialog//NextIcon.tscn")

onready var screen_dimensions = get_viewport_rect().size

onready var label_style := preload("res://Fonts/Text Engine.tres")



var answer: String


signal next
signal answered


# Important thing to note: if you want the background to pause, use yield(func, "completed") like I do here
func _ready():
	#$TextOutput.max_lines_visible = 4

	var name: String = yield(input_dialog("What is your name?"), "completed")

	yield(text_dialog("Hi " + name +  ". (Use the 'space' or 'enter' keys, or just click the textbox)", 15, 0.05, "Test Subject"), "completed")

	if yield(question_dialog("Would you like to proceed?", 15, 0.05), "completed") == "Yes":


		yield(text_dialog("An indicator arrow will appear at the bottom of the textbox... now!", 15, 0.05, "Test Subject"), "completed")
		yield(text_dialog("Text can go really fast...", 15, 0.01, "Test Subject"), "completed")
		yield(text_dialog("Or instantaneously...", 15, 0, "Test Subject"), "completed")
		yield(text_dialog("Or VERY slowly...", 15, 0.25, "Test Subject"), "completed")
		yield(text_dialog("Text files can be read", 15, 0.05, "Test Subject"), "completed")
		yield(text_dialog("As well as JSON files", 15, 0.05, "Test Subject"), "completed")
		for index in range(3):
			yield(json_text_dialog("Test Subject", str(index), 15, 0.05), "completed")
		yield(json_text_dialog("Test Subject", "Farewell", 15, 0.05), "completed")
		yield(text_dialog("Line1\nLine2\nLine3\nLine4\nLine5\nLine6", 15, 0.05), "completed")

func wait(seconds: float):
	#use it like this: yield(wait(1), "completed")
	#DO NOT use the 'wait' function alone.
	yield(get_tree().create_timer(seconds), "timeout")





func text_output(string: String, size: int = label_style.size, delay: float = 0.0, speaker_name: String = "", sound = null) -> void:
	#does not return anything, just saves some typing
	$Input.hide()
	if speaker_name:
		$CharacterName.text = speaker_name
		label_style.size = size
		$CharacterName.show()
	else:
		$CharacterName.hide()
	$TextOutput.show()
	if delay <= 0.0:
		$TextOutput.text = string
	else:
		$TextOutput.text = ""
		for character in string:
			$TextOutput.text += character
			yield(wait(delay), "completed")


func text_disappear():
	$CharacterName.hide()
	$TextOutput.hide()
	$CharacterName.text = ""
	$TextOutput.text = ""


func text_dialog(string: String, size: int = label_style.size, delay: float = 0.0, speaker_name: String = "", sound = null):
	#'sound' parameter should be AudioStreamPlayer2D. Not implemented yet.	
	#should make it so it sounds like Celeste, but I need sounds in order to test it out and implement this
	yield(text_output(string, size, delay, speaker_name, sound), "completed")

	var NextIndicator = next_indicator.instance()
	add_child(NextIndicator)

	yield(self, "next")

	NextIndicator.queue_free()
	text_disappear()

	return

func json_text_dialog(speaker_name: String = "", key = "", size: int = label_style.size, delay: float = 0.0, sound = null) -> void:
	yield(text_dialog($FileOpener.read_json(dialog_json_filepath)[speaker_name][key], size, delay, speaker_name, sound), "completed")
	return


func question_dialog(string: String, size: int = label_style.size, delay: float = 0.0, speaker_name: String = "", answer_options: Array = ["Yes", "No"], sound = null):
	var answerOptionScenes: Array = []
	var OptionCoords: Vector2 = Vector2(402, 199) #start pos
	#no more than 4 dialog options supported

	$TextOutput.rect_size.x = 315

	#use the subprocess (is it called that...?)
	yield(text_output(string, size, delay, speaker_name, sound), "completed")

	var optionBoxInstance

#	for option in answer_options:
#
#		optionBoxInstance = AnswerOptionScene.instance().init(option, OptionCoords, OptionScale)
#		add_child(optionBoxInstance)
#
#		optionBoxInstance.rect_position = OptionCoords
#		OptionCoords.y += 24 #this value works the best for spacing
#
#
#		answerOptionScenes.append(optionBoxInstance)
#		optionBoxInstance.connect("clicked", self, "_on_Answer_Selected")

	yield(self, "answered")

	$TextOutput.rect_size.x = 446

	for node in answerOptionScenes:
		node.queue_free()

	text_disappear()

	return answer

func json_question_dialog(speaker_name: String = "", key = "", size: int = label_style.size, delay: float = 0.0, sound = null) -> void:
	return yield(question_dialog($FileOpener.read_json(dialog_json_filepath)[speaker_name][key], size, delay, speaker_name, sound), "completed")

func _on_Answer_Selected(option):
	answer = option
	emit_signal("answered")


func input_dialog(question: String): #returns a value based on input
	text_disappear()
	$Input.show()
	$Input.init(question)

	yield(self, "answered")

	return answer


func json_input_dialog(speaker_name: String = "", key = ""):
	return yield(input_dialog($FileOpener.read_json(dialog_json_filepath)[speaker_name][key]), "completed")

#func set_size(size: int):
#	label_style.size = size



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_released("ui_accept"):
		emit_signal("next")

#func _on_Area2D_input_event(_viewport, event, _shape_idx):
#	if event is InputEventMouseButton or (event is InputEventKey and event.scancode in accepted_keys):
#		emit_signal("next")

func _on_ClickDetection_pressed():
	emit_signal("next")
