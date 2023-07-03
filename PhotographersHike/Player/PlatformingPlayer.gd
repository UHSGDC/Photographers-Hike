extends KinematicBody2D

class_name Player

# Input
var x_input: int = 0
var jump_input: int = 0

# General
var velocity: Vector2 = Vector2.ZERO

# Movement
export var max_move_speed: float
export var move_acceleration: float
export var idle_deacceleration: float

# Jumping
export var jump_height: float
export var jump_duration: float
export var fall_duration: float
export var max_fall_speed: float

# Determine the gravity and velocity using physics equations 
# based on the height and duration of jump
onready var fall_gravity: float = - (-2 * jump_height) / (fall_duration * fall_duration)
onready var jump_gravity: float =  - (-2 * jump_height) / (jump_duration * jump_duration)
onready var jump_velocity: float = - (2 * jump_height) / jump_duration

var can_jump: bool = true

# Quality of life jumping behavior
var coyote_time_length: float = 0.15
var jump_was_pressed: bool = false
var remember_jump_length: float = 0.1




# Room swapping

enum Touching_Side {
	BOTH,
	HORIZONTAL,
	VERTICAL,
	NONE
}


var current_checkpoint: Position2D


# Pausing player movement
var in_cutscene: bool = false
var in_minigame: bool = false
var death_pause: bool = false



func _ready() -> void:
	Global.platforming_player = self

# Delta is the time since physics_process was last called
# I multiply things by delta so things move correctly no matter the frame rate
func _physics_process(delta: float) -> void:
	
	input()
	
	# Pause player movement between rooms or when playing dialog
	if !Global.room_pause and !Global.dialog_box.dialog_playing and !in_cutscene and !death_pause:
		if !in_minigame:
			move(delta)


func move(delta: float) -> void:
	# Horizontal Movement
	
	# Accelerates player in direction of input
	velocity.x += x_input * move_acceleration * delta
	
	# Deaccelerates player velocity.x to 0 if player isn't inputting a direction
	if !x_input:
		if abs(velocity.x) < idle_deacceleration * delta:
			velocity.x = 0
		else:
			velocity.x -= idle_deacceleration * sign(velocity.x) * delta
	
	# Clamps velocity.x to max_move_speed
	if velocity.x > max_move_speed:
		velocity.x = lerp(velocity.x, max_move_speed, 0.4)
	elif velocity.x < -max_move_speed:
		velocity.x = lerp(velocity.x, -max_move_speed, 0.4)
		
	
	#Jumping
	if is_on_floor():
		can_jump = true
		if jump_was_pressed:
			jump()

	if jump_input:
		jump_was_pressed = true
		remember_jump_time()
		if can_jump:
			jump()
	
	if !is_on_floor():
		coyote_time()
	
	apply_gravity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func apply_gravity(delta: float) -> void:
	var gravity: float = jump_gravity if velocity.y < 0 else fall_gravity
	if gravity:
		velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	

func jump() -> void:
	velocity.y = jump_velocity


func coyote_time():
	yield(get_tree().create_timer(coyote_time_length), "timeout")
	can_jump = false


func remember_jump_time():
	yield(get_tree().create_timer(remember_jump_length), "timeout")
	jump_was_pressed = false


func input() -> void:
	# Resets input variables
	x_input = 0
	jump_input = 0
	
	# Checks for horizontal
	if Input.is_action_pressed("right"):
		x_input += 1
	if Input.is_action_pressed("left"):
		x_input -= 1
	# Checks for jump
	if Input.is_action_just_pressed("jump"):
		jump_input = 1


func _on_RoomDetector_area_entered(area: Area2D) -> void:
	# Gets collision shape and size of room
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size: Vector2 = collision_shape.shape.extents * 2
	
	if Global.current_room == area:
		return
	
	
	# Gives the player extra upward velocity if it is entering a room above it
	if Global.player_camera.current_room_size != Vector2.ZERO:
		var side = check_room_edge(Global.player_camera.current_room_center, Global.player_camera.current_room_size, collision_shape.global_position, size)
	
		if side == Global.UP:
			velocity.y = jump_velocity
	
	
	current_checkpoint = get_checkpoint(area)
	
	Global.change_room(area, collision_shape.global_position, size)	
	
	
func get_checkpoint(room: LevelRoom) -> Position2D:
	
	var closest_checkpoint: Position2D
	
	for checkpoint in room.get_checkpoints():
		if !closest_checkpoint:
			closest_checkpoint = checkpoint
			continue
		
		var dist_to_checkpoint = global_position.distance_squared_to(checkpoint.global_position)
		var dist_to_closest_checkpoint = global_position.distance_squared_to(closest_checkpoint.global_position)
		
		if dist_to_checkpoint < dist_to_closest_checkpoint:
			closest_checkpoint = checkpoint
		
	
	return closest_checkpoint
	

# Checks which edge of a touching b. If a and b are overlapping or not touching 
# the function will push_error(). a is the previous room and b is the room being entered
func check_room_edge(a_center: Vector2, a_size: Vector2, b_center: Vector2, b_size: Vector2) -> int:
	
	var relative_center: Vector2 = a_center - b_center
	
	var total_size: Vector2 = a_size + b_size
	
	var horizontal_overlap: int = int(total_size.x / 2 - abs(relative_center.x))
	var vertical_overlap: int = int(total_size.y / 2 - abs(relative_center.y))
	
	var touching: int
	
	if horizontal_overlap > 0 and vertical_overlap > 0:
		touching = Touching_Side.BOTH
	elif horizontal_overlap > 0 and vertical_overlap == 0:
		touching = Touching_Side.VERTICAL
	elif horizontal_overlap == 0 and vertical_overlap > 0:
		touching = Touching_Side.HORIZONTAL	
	elif horizontal_overlap <= 0 and vertical_overlap <= 0:
		touching = Touching_Side.NONE
	else:
		push_error("error calculating room edge")
		
	match touching:
		Touching_Side.BOTH:
			push_error("rooms overlapping or entering the same room")
		Touching_Side.NONE:
			push_error("player crossed two rooms that are not touching")
		Touching_Side.VERTICAL:
			if a_center.y < b_center.y: # up is negative y
				return Global.DOWN
			elif a_center.y > b_center.y:
				return Global.UP
			else:
				push_error("rooms touching vertically, but at same y coordinate")
		Touching_Side.HORIZONTAL:
			if a_center.x < b_center.x:
				return Global.RIGHT
			elif a_center.x > b_center.x:
				return Global.LEFT
			else:
				push_error("rooms touching horizontally, but at same x coordinate")
				
	# Fail safe
	return Global.RIGHT
	


func respawn() -> void:
	death_pause = true
	hide()
	velocity = Vector2.ZERO
	
	yield(get_tree().create_timer(0.2), "timeout")
	global_position = current_checkpoint.global_position
	
	show()
	death_pause = false