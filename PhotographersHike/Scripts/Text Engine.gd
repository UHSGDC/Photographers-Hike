extends Node2D




const accepted_keys: Array = [KEY_SPACE, KEY_ENTER]
const dialog_json_filepath: String = "res://dialog.json" #don't have the file yet

var next_indicator = load("res://Scenes//NextIcon.tscn")

onready var screen_dimensions = get_viewport_rect().size

onready var label_style := preload("res://Fonts/Text Engine.tres")



var strlist

signal next


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(text_dialog("Hello World (Use the 'space' or 'enter' keys, or just click the textbox)", 15, 0.05, "Test Subject"), "completed")
	yield(text_dialog("An indicator arrow will appear at the bottom of the textbox... now!", 15, 0.05, "Test Subject"), "completed")
	yield(text_dialog("Text can go really fast...", 15, 0.01, "Test Subject"), "completed")
	yield(text_dialog("Or instantaneously...", 15, 0, "Test Subject"), "completed")
	yield(text_dialog("Or VERY slowly...", 15, 0.25, "Test Subject"), "completed")
	yield(text_dialog("Text files can be read", 15, 0.05, "Test Subject"), "completed")
	yield(text_dialog("As well as JSON files", 15, 0.05, "Test Subject"), "completed")
	for index in range(3):
		yield(json_text_dialog("Test Subject", str(index), 15, 0.05), "completed")
	yield(json_text_dialog("Test Subject", "Farewell", 15, 0.05), "completed")

func wait(seconds: float):
	#use it like this: yield(wait(1), "completed")
	#DO NOT use the 'wait' function alone.
	yield(get_tree().create_timer(seconds), "timeout")


func text_dialog(string: String, size: int = label_style.size, delay: float = 0.0, speaker_name: String = "Nobody", sound = null):
	#'sound' parameter should be AudioStreamPlayer2D. Not implemented yet.	
	#should make it so it sounds like Celeste, but I need sounds in order to test it out and implement this
	$CharacterName.text = speaker_name
	label_style.size = size
	$CharacterName.show()
	$TextOutput.show()
	if delay <= 0.0:
		$TextOutput.text = string
	else:
		$TextOutput.text = ""
		for character in string:
			$TextOutput.text += character
			yield(wait(delay), "completed")
	
	var NextIndicator = next_indicator.instance()
	add_child(NextIndicator)
	
	yield(self, "next")
	
	NextIndicator.queue_free()
	$CharacterName.hide()
	$TextOutput.hide()
	$CharacterName.text = ""
	$TextOutput.text = ""
	
	return

func json_text_dialog(speaker_name: String = "", key = "", size: int = label_style.size, delay: float = 0.0, sound = null) -> void:
	yield(text_dialog($FileOpener.read_json(dialog_json_filepath)[speaker_name][key], size, delay, speaker_name, sound), "completed")
	return


#func set_size(size: int):
#	label_style.size = size
#func increase_size(size: int):
#	label_style.size += size
#func decrease_size(size: int):
#	label_style.size -= size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton or (event is InputEventKey and event.scancode in accepted_keys):
		emit_signal("next")
