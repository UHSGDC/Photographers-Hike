extends Node2D




const accepted_keys: Array = [KEY_SPACE, KEY_ENTER]

onready var screen_dimensions = get_viewport_rect().size

onready var label_style := preload("res://Fonts/Text Engine.tres")

var strlist

signal next


# Called when the node enters the scene tree for the first time.
func _ready():
	
	yield(text_dialog("Hello World (Use the 'space' or 'enter' keys, or just click the textbox)", 15, 0.1, "Test Subject"), "completed")
	yield(text_dialog("This is a very basic text engine", 15, 0.1, "Test Subject"), "completed")
	yield(text_dialog("I hope this is okay", 15, 0.1, "Test Subject"), "completed")
	yield(text_dialog("Text files can be read", 15, 0.1, "Test Subject"), "completed")
	yield(text_dialog("For example: res://test_textfile.tres contains the following text:", 15, 0.1, "Test Subject"), "completed")
	yield(text_dialog($FileOpener.load_file('res://test_textfile.tres'), 10, 0.1, "Test Subject"), "completed")
	

func wait(seconds: float):
	#use it like this: yield(wait(1), "completed")
	#DO NOT use the 'wait' function alone.
	yield(get_tree().create_timer(seconds), "timeout")



func get_json(file, key: String): #unfinished
	var contents: String = $FileOpener.load_file(file)
	


func text_dialog(string: String, size: int = label_style.size, delay: float = 0.0, speaker_name: String = "Nobody", sound = null):
	#'sound' parameter should be AudioStreamPlayer2D. Not implemented yet.	
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
	

	
	yield(self, "next")
	
	$CharacterName.hide()
	$TextOutput.hide()
	$CharacterName.text = ""
	$TextOutput.text = ""
	
	print("Done!")
	
	
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

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton or (event is InputEventKey and event.scancode in accepted_keys):
		emit_signal("next")
