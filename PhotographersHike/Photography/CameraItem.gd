extends Node

onready var captured_image = $CanvasLayer/CapturedImage


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("take_picture"):
		take_screenshot()


func take_screenshot() -> void:
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Wait until the frame has finished before getting the texture.
	yield(VisualServer, "frame_post_draw")
	
	# Retrieve the captured image.
	var image = get_viewport().get_texture().get_data()
	image.resize(480, 288, 1)

	# Flip it on the y-axis (because it's flipped).
	image.flip_y()

	# Create a texture for it.
	var texture = ImageTexture.new()
	texture.create_from_image(image)

	# Set the texture to the captured image node.
	captured_image.set_texture(texture)
	
	var dir: Directory = Directory.new()
	if dir.open("user://screenshots"):
		dir.make_dir("user://screenshots")	
	
	image.save_png("user://screenshots/screenshot.png")

	
	print("pictureasdasd")
