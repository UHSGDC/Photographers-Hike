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


func _ready() -> void:
	Global.player_camera = self
	
	# Sets smoothing to 1 and back to follow_smoothing
	# I do this so the camera appears as if it starts at the first room not at (0, 0)

	smoothing_enabled = false
	smoothing = 1
	yield(get_tree().create_timer(0.1),"timeout")
	smoothing = follow_smoothing


func _physics_process(delta: float) -> void:
	
	
	
	if zoom_to != zoom:
		zoom.x = move_toward(zoom.x, zoom_to.x, zoom_speed * delta)
		zoom.y = move_toward(zoom.y, zoom_to.y, zoom_speed * delta)
		
	zoom_view_size.x = view_size.x * zoom.x
	zoom_view_size.y = view_size.y * zoom.y

	# Get target position
	var target_position := calculate_target_position(current_room_center, current_room_size)
	
	
	# Interpolate(lerp) camera position to target position by the smoothing
	if zoom_to != zoom:
		position = target_position
	else:
		position = lerp(position, target_position, smoothing)
	
	

func calculate_target_position(room_center: Vector2, room_size: Vector2) -> Vector2:
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
		return_position.x = clamp(Global.platforming_player.position.x, left_limit, right_limit)


	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		var top_limit: float = room_center.y - y_margin
		var bottom_limit: float = room_center.y + y_margin
		return_position.y = clamp(Global.platforming_player.position.y, top_limit, bottom_limit)
	
	return return_position
