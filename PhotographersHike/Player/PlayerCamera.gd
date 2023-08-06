extends Camera2D

# Amount of smoothing used to follow the player value is from 0 to 1
export var follow_smoothing: float = 0.1

# The amount of smoothing used by the code
var smoothing: float

var current_room_center: Vector2
var current_room_size: Vector2

onready var view_size: Vector2 = get_viewport_rect().size
var zoom_view_size: Vector2

var zoom_to: Vector2 = Vector2.ONE

var zoom_speed: float = 0.3

export var pan_speed: float
var panned_position: Vector2
var panning: bool = false

const SCREEN_SHAKE_UPDATE_TIME: float = 0.05

var should_screen_shake: bool = false


func _ready() -> void:
	Global.player_camera = self
	
	
	# Sets smoothing to 1 and back to follow_smoothing
	# I do this so the camera appears as if it starts at the first room not at (0, 0)

	smoothing_enabled = false
	smoothing = 1
	yield(get_tree().create_timer(0.1),"timeout")
	smoothing = follow_smoothing


func screen_shake(length: float) -> void:
	start_screen_shake()
	yield(get_tree().create_timer(length), "timeout")
	end_screen_shake()


func start_screen_shake() -> void:
	should_screen_shake = true
	while should_screen_shake:
		offset = Vector2(randf() * 2, randf() * 2)
		yield(get_tree().create_timer(SCREEN_SHAKE_UPDATE_TIME), "timeout")
	offset = Vector2.ZERO
	
func end_screen_shake() -> void:
	should_screen_shake = false


func _physics_process(delta: float) -> void:
	if zoom_to != zoom:
		zoom.x = move_toward(zoom.x, zoom_to.x, zoom_speed * delta)
		zoom.y = move_toward(zoom.y, zoom_to.y, zoom_speed * delta)
		
	zoom_view_size.x = view_size.x * zoom.x
	zoom_view_size.y = view_size.y * zoom.y

	# Get target position
	
	panning = check_for_panning()
	
	
	var target_position: Vector2
	if panning:
		var pan_input: Vector2 = Vector2(Input.get_axis("menu_left", "menu_right"), Input.get_axis("menu_up", "menu_down"))
		panned_position += pan_speed * pan_input * delta
		
		
		target_position = calculate_target_position(current_room_center, current_room_size, panned_position)
		
		if pan_just_pressed():
			var pan_warning: PoolStringArray
			if panned_position.x > target_position.x and Input.is_action_just_pressed("menu_right"):
				pan_warning.append("right")
			elif panned_position.x < target_position.x and Input.is_action_just_pressed("menu_left"):
				pan_warning.append("left")
			
			if panned_position.y > target_position.y and Input.is_action_just_pressed("menu_down"):
				pan_warning.append("lower")
			elif panned_position.y < target_position.y and Input.is_action_just_pressed("menu_up"):
				pan_warning.append("upper")	
		
			if pan_warning.size():
				display_pan_warning(pan_warning)
		
		
		panned_position = target_position
	else:
		target_position = calculate_target_position(current_room_center, current_room_size, Global.platforming_player.global_position)
	
	
	# Interpolate(lerp) camera position to target position by the smoothing
	if zoom_to != zoom:
		position = target_position
	else:
		position = lerp(position, target_position, smoothing)


func display_pan_warning(pan_warning: PoolStringArray) -> void:
	var text: String = "Unable to pan! \n Camera reached %s bound of room."
	
	var direction_text: String
	for direction in pan_warning.size():
		if direction == 0:
			direction_text = pan_warning[direction]
		elif direction == 1:
			direction_text += " and " + pan_warning[direction]
		else:
			push_error("error displaying pan warning. more than 2 directions chosen")
		
	
	text = text % direction_text
	
	$PanWarning/Label.text = text
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Show Pan Warning")


func pan_just_pressed() -> bool:
	return Input.is_action_just_pressed("menu_up") or Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_left") or Input.is_action_just_pressed("menu_right")


func check_for_panning() -> bool:
	if Input.is_action_just_pressed("interact"):
		return false
	if Global.platforming_player.x_input or Global.platforming_player.jump_input:
		return false
	if pan_just_pressed():
		if !panning:
			panned_position = calculate_target_position(current_room_center, current_room_size, Global.platforming_player.global_position)
			return true
	
	return panning
	

func calculate_target_position(room_center: Vector2, room_size: Vector2, subject_position: Vector2) -> Vector2:
	# The distance from the center of the room to the camera boundary on one side.
	# When the room is the same size as the screen the x and y margin are zero
	var x_margin: float = (room_size.x - zoom_view_size.x) / 2
	var y_margin: float = (room_size.y - zoom_view_size.y) / 2
	
	
	var return_position: Vector2 = Vector2.ZERO
	
	# if the zoom_view_size >= room_size the camera position should just be room center
	if x_margin <= 0:
		return_position.x = room_center.x
	# Clamps the return position to the left and right limits if the x_margin is positive
	else:
		var left_limit: float = room_center.x - x_margin
		var right_limit: float = room_center.x + x_margin
		return_position.x = clamp(subject_position.x, left_limit, right_limit)


	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		var top_limit: float = room_center.y - y_margin
		var bottom_limit: float = room_center.y + y_margin
		return_position.y = clamp(subject_position.y, top_limit, bottom_limit)
	
	return return_position
