extends KinematicBody2D

class_name Cougar

# AI
var x_input: int = 0
var jump_input: int = 0

# General
var velocity: Vector2 = Vector2.ZERO


# Patrolling
export var max_patrol_speed: float
export var patrol_acceleration: float
export var patrol_points_path: NodePath
onready var patrol_points: Node = get_node(patrol_points_path)
onready var patrol_array: Array = patrol_points.get_children()
var current_point: Vector2
var current_point_index: int = 0

export var point_distance_tolerance: float

# Chasing
export var max_chase_speed: float
export var chase_acceleration: float

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

# States

enum STATES {
	PATROLLING,
	SLEEPING,
	CHASING,
	IDLE,
	NONE
}

export(STATES) var initial_state
var current_state: int = STATES.NONE
var entering_state: bool = false

# Sleeping
var current_footsteps: int = 0
const MAX_FOOTSTEPS: int = 2


# Pathfinding

var current_path = []
onready var cougar_size: Vector2 = $CollisionShape2D.shape.extents

var player: KinematicBody2D
var navigation_node: Navigation2D

# Flipping
var facing_right: bool = false
onready var vision_cone_offset: float = $VisionCone.position.x

func _ready() -> void:
	call_deferred("_set_player_reference")
	reset_state()


func _set_player_reference() -> void:
	player = Global.platforming_player


func _physics_process(delta: float) -> void:
	change_state(run_states(delta))
	look()
	animate()


func animate() -> void:
	match current_state:
		STATES.CHASING:
			if !is_on_floor():
				if $AnimationPlayer.assigned_animation != "Jump":
					$AnimationPlayer.play("Jump")
					return
					
			if $AnimationPlayer.assigned_animation != "Run":
				$AnimationPlayer.play("Run")
		STATES.IDLE:
			if $AnimationPlayer.assigned_animation != "Lick":
				$AnimationPlayer.play("Lick")
		STATES.SLEEPING:
			$AnimationPlayer.queue("Sleep")
		STATES.PATROLLING:
			if !is_on_floor():
				if $AnimationPlayer.assigned_animation != "Jump":
					$AnimationPlayer.play("Jump")
					return
				
			if $AnimationPlayer.assigned_animation == "Sleep":
				$AnimationPlayer.play("Wake Up")
			else:
				$AnimationPlayer.queue("Walk")
	
	
func look() -> void:
	if sign(velocity.x) > 0:
		facing_right = true
		$VisionCone.position.x = -vision_cone_offset
		$VisionCone.facing_right = true
		$Sprite.scale.x = -1
	else:
		facing_right = false
		$VisionCone.position.x = vision_cone_offset
		$VisionCone.facing_right = false
		$Sprite.scale.x = 1
	
	
func reset_state() -> void:
	change_state(initial_state)
	
	
func change_state(new_state: int) -> void:
	if new_state != STATES.NONE:
		current_state = new_state
		entering_state = true
	
	
func run_states(delta: float) -> int:
	match current_state:
		STATES.PATROLLING:
			return patrol(delta)
		STATES.SLEEPING:
			return sleep(delta)
		STATES.CHASING:
			return chase_player(delta)
		STATES.IDLE:
			return idle(delta)
	
	return STATES.NONE


func patrol(delta: float) -> int:
	if entering_state:
		entering_state = false	
		$VisionCone.visible = true
		if !current_point:
			current_point = patrol_array[current_point_index].global_position
	
	follow_along_path()
	move(delta, patrol_acceleration, max_patrol_speed)
	
	if global_position.distance_to(current_point) < 24 and self.is_on_floor():
		current_point_index += 1
		if current_point_index >= patrol_array.size():
			current_point_index = 0
		current_point = patrol_array[current_point_index].global_position
	
	return STATES.NONE


func chase_player(delta: float) -> int:
	if entering_state:
		entering_state = false
	
	follow_along_path()
	move(delta, chase_acceleration, max_chase_speed)
	
	return STATES.NONE


func sleep(delta: float) -> int:
	x_input = 0
	move(delta, 0, 0)
	return STATES.NONE
	
	
func idle(delta: float) -> int:
	x_input = 0
	move(delta, 0, 0)
	return STATES.NONE



func follow_along_path() -> void:
	if current_path.size() == 0:
		return

	var next_step = current_path[0]

	# Before stopping following path, I make sure the character is not jumping,
	# otherwise it could stop mid-jump, causing it to fall from a platform
	if global_position.distance_to(get_current_target_point()) < 24 and self.is_on_floor():
		current_path = []
		return

	if should_jump(next_step):
		jump_input = 1
	else:
		jump_input = 0

	# remove point from path when reached
	if self.move_to_position(next_step):
		current_path.remove(0)	


func should_jump(next_step) -> bool:
	var y_distance := abs(global_position.y - next_step.y)
	return (
			$Sensors.is_facing_jumpable_blocker() or
			($Sensors.is_facing_edge() and global_position.y > next_step.y) or
			(y_distance < self.jump_height and global_position.y - 8 > next_step.y and abs(global_position.x - next_step.x) < 6)
			)

func get_current_target_point() -> Vector2:
	if current_state == STATES.PATROLLING:
		return current_point
	elif current_state == STATES.CHASING:
		return player.global_position
	else:
		return Vector2.ZERO


func _on_PathCalculationTimer_timeout() -> void:
	var path = navigation_node.get_simple_path(global_position, get_current_target_point())
	# if path has unreachable sections, calculate alternate paths
	# A section is considered unreachable when the Y distance between two points
	# is higher than the character's jump can reach.
	if not _is_path_reachable(path):
		path = _calculate_alternate_path()
	current_path = path
	# Removing first point as it will always be the NPC current position.
	if path.size() > 0:
		current_path.remove(0)


func _calculate_alternate_path():
	var offset = Vector2(20, 0)
	var alt_1 = navigation_node.get_simple_path(global_position - offset, get_current_target_point(), true)
	var alt_2 = navigation_node.get_simple_path(global_position + offset, get_current_target_point(), true)

	var is_alt_1_reachable = _is_path_reachable(alt_1)
	var is_alt_2_reachable = _is_path_reachable(alt_2)

	if not (is_alt_1_reachable or is_alt_2_reachable):
		return []

	if is_alt_1_reachable and not is_alt_2_reachable:
		return alt_1

	if not is_alt_1_reachable and is_alt_2_reachable:
		return alt_2

	if alt_1[0].distance_to(get_current_target_point()) < alt_2[0].distance_to(get_current_target_point()):
		return alt_1

	return alt_2


func _is_path_reachable(path):
	var previous = global_position
	for current in path:
		if previous.y > current.y and abs(previous.y - current.y) > self.jump_height:
			return false
		previous = current
	return true


func move_to_position(target: Vector2) -> bool:
	var y_distance := abs(global_position.y -  target.y)
	var direction := global_position.direction_to(target)
	direction.y = 0
	
	if abs(direction.x) < 0.5 and y_distance < 10:
		return true
	else:
		x_input = direction.normalized().x
		return false


func move(delta: float, acceleration: float, max_speed: float) -> void:
	# Horizontal Movement
	# Accelerates player in direction of input
	velocity.x += x_input * acceleration * delta

	# Deaccelerates player velocity.x to 0 if player isn't inputting a direction
	if !x_input:
		if abs(velocity.x) < idle_deacceleration * delta:
			velocity.x = 0
		else:
			velocity.x -= idle_deacceleration * sign(velocity.x) * delta

	# Clamps velocity.x to max_move_speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	#Jumping
	if is_on_floor():
		can_jump = true

	if jump_input:
		if can_jump:
			jump()

	apply_gravity(delta)


	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity(delta: float) -> void:
	var gravity: float = jump_gravity if velocity.y < 0 else fall_gravity
	if gravity:
		velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed	
	

func jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity


# Chase player if they get in vision cone
func _on_VisionCone_body_entered(body: Node) -> void:
	if body == Global.platforming_player and current_state == STATES.PATROLLING:
		$VisionCone.visible = false
		change_state(STATES.CHASING)


# Wake up cougar
func _on_SleepingDetection_body_entered(body: Node) -> void:
	if body == Global.platforming_player and current_state == STATES.SLEEPING:
		current_footsteps += 1
		if current_footsteps >= MAX_FOOTSTEPS:
			change_state(STATES.PATROLLING)
			current_footsteps == 0
			return
			
		$AnimationPlayer.play("Disturbed")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play_backwards("Disturbed")


func _on_BiteArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.respawn()
