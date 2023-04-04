extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass   
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_Full_Checkbox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Border_Checkbox_pressed():
	OS.window_borderless = !OS.window_borderless


func _on_VSYNC_Checkbox_pressed():
	OS.vsync_enabled = !OS.vsync_enabled


func _on_Back_to_game_pressed():
	get_tree().change_scene("res://Scenes/Testing.tscn")
