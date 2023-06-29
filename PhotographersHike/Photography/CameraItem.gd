extends Node

class_name CameraItem

signal close_picture

onready var captured_image = $CanvasLayer/CapturedImage

var picture_textures: Array setget ,get_picture_textures
var picture_times: PoolStringArray setget ,get_picture_times
var picture_levels: PoolStringArray setget, get_picture_levels

var can_take_picture: bool = true

var center: Vector2

var Rng: RandomNumberGenerator
		

func _ready() -> void:
	Global.camera_item = self
	center = captured_image.rect_position
	Rng = RandomNumberGenerator.new()
	Rng.randomize()
		
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("take_picture") and can_take_picture:
		take_screenshot()


func take_screenshot() -> void:
	yield(VisualServer, "frame_post_draw")
	# Retrieve the captured image.
	var image = get_viewport().get_texture().get_data()

	# Flip it on the y-axis (because it's flipped).
	image.flip_y()

	display_and_store_image(image)
	

func display_and_store_image(image: Image) -> void:
	
	# Set the texture to the captured image node.
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	captured_image.set_texture(texture)
	randomize_image_rotation()
	randomize_image_position()


	picture_textures.append(texture)
	picture_levels.append("Base")
	
	var time_dictionary: Dictionary = Time.get_time_dict_from_system()
	
	var minute_string: String
	if time_dictionary["minute"] < 10:
		minute_string = "0" + str(time_dictionary["minute"])
	else:
		minute_string = str(time_dictionary["minute"])
	
	var time_string: String = str(wrapi(time_dictionary["hour"], 1, 13)) + ":" + minute_string
	
	picture_times.append(time_string)
	
	
	can_take_picture = false
	$AnimationPlayer.play("take_picture")
	yield($AnimationPlayer, "animation_finished")
	can_take_picture = true

	
func randomize_image_rotation() -> void:
	captured_image.rect_rotation = Rng.randf_range(-5, 5)
	
	
func randomize_image_position() -> void:
	captured_image.rect_position = center + Vector2(Rng.randf_range(-5, 5), Rng.randf_range(-5, 5))
	
	
func get_picture_textures() -> Array:
	return picture_textures
	
	
func get_picture_levels() -> PoolStringArray:
	return picture_levels
	

func get_picture_times() -> PoolStringArray:
	return picture_times
	
	
#Add later

#func save_photo() -> void:
#	var dir: Directory = Directory.new()
#	if dir.open("user://screenshots"):
#		dir.make_dir("user://screenshots")	
#
#	image.save_png("user://screenshots/screenshot.png")

	