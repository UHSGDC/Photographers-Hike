extends Node

class_name CameraItem

signal close_picture

onready var captured_image = $CanvasLayer/CapturedImage

var picture_textures: Array setget ,get_picture_textures

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
	
	
#Add later

#func save_photo() -> void:
#	var dir: Directory = Directory.new()
#	if dir.open("user://screenshots"):
#		dir.make_dir("user://screenshots")	
#
#	image.save_png("user://screenshots/screenshot.png")

	
