extends Node2D




const accepted_keys: Array = [KEY_SPACE, KEY_ENTER]

onready var screen_dimensions = get_viewport_rect().size

onready var label_style := preload("res://Fonts/Text Engine.tres")

var strlist

signal next


# Called when the node enters the scene tree for the first time.
func _ready():
	#show_text(test, 8)
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

#func translate_string_to_ASCII_list(string: String) -> Array:
#	var stringlist = Array()
#	for i in string:
#		stringlist.append(ord(i))
#	return stringlist
#
#func load_image(path: String) -> ImageTexture:
#	var image = Image.new()
#	var texture: ImageTexture = ImageTexture.new()
#	image.load(path)
#	texture.create_from_image(image)
#	return texture
#
#
#func get_ASCII_image(ASCII_id: int) -> Sprite:
#	var ASCII_string
#	if len(str(ASCII_id)) < 3:
#		ASCII_string = "0" + str(ASCII_id)
#	else:
#		ASCII_string = str(ASCII_id)
#
#	var texture: ImageTexture = load_image("res://Art//ASCII Characters (Transparent Background)//tile" + ASCII_string + ".png")
#	var image_sprite = Sprite.new()
#	image_sprite.texture = texture
#	return image_sprite
#
#
#func get_Image_list(string: String) -> Array:
#	var ImageArray = Array()
#	for character in string:
#		ImageArray.append(get_ASCII_image(ord(character)))
#	return ImageArray
#
#func show_text(string: String, size: int, delay: int = 0):
#	var image_list = get_Image_list(string)
#	var start_coords = Vector2(0, 50)
## warning-ignore:unused_variable
#	var separation
#	prints("size:", size)
#	image_list[0].position = start_coords
#	image_list[0].show()
#	for i in range(1, len(image_list)):
#		image_list[i].position = image_list[i-1].position
#		if image_list[i].position.x + size > screen_dimensions.x:
#			image_list[i].position.y += image_list[i-1].texture.get_height()/2 + image_list[i].texture.get_height()/2 + 1
#			image_list[i].position.x = start_coords.x
#		else:
#			image_list[i].position.x += image_list[i-1].texture.get_width()/2 #image_list[i].texture.get_width()/2
#		print("image_list[", i, "].position: ", image_list[i].position)
#	for char_image in image_list:
#		add_child(char_image)
#		char_image.show()
#		yield(wait(delay), "completed")
#
#
#	print(image_list)
#
#	return
#
#never mind, maybe using a text label would be a better idea...

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
	
#	while not Input.is_action_pressed("ui_accept"):
#		pass
		#I did some research and couldn't find a better way to do this...
		#BUT, this may not be a good way to solve this... because the window will think that Godot is not responding
	
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
