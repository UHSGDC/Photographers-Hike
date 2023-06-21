extends KinematicBody2D

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

func _ready() -> void:
	Global.platforming_player = self


# Delta is the time since physics_process was last called
# I multiply things by delta so things move correctly no matter the frame rate
func _physics_process(delta: float) -> void:
	input()
	
	# Pause player movement between rooms
	if !Global.room_pause:
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
	velocity.x = clamp(velocity.x, -max_move_speed, max_move_speed)
	
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
	
	# Gives the player extra upward velocity if it is entering a room above it
	if Global.player_camera.current_room_size != Vector2.ZERO:
		var side = check_room_edge(Global.player_camera.current_room_center, Global.player_camera.current_room_size, collision_shape.global_position, size)
	
		if side == Global.UP:
			velocity.y = jump_velocity
	
	# Changes camera's current room and size. check PlayerCamera script for more info
	Global.change_room(collision_shape.global_position, size)


# Checks which edge of a touching b. If a and b are overlapping or not touching 
# the function will push_error(). a is the previous room and b is the room being entered
func check_room_edge(a_center: Vector2, a_size: Vector2, b_center: Vector2, b_size: Vector2) -> int:
	
	var relative_center: Vector2 = a_center - b_center
	
	var total_size: Vector2 = a_size + b_size
	
	var horizontal_overlap: int = total_size.x / 2 - abs(relative_center.x)
	var vertical_overlap: int = total_size.y / 2 - abs(relative_center.y)
	
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
			push_error("rooms overlapping")
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
	
