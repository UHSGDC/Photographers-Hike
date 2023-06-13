extends KinematicBody2D


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


enum STATES {
	PATROLLING,
	SLEEPING,
	CHASING
	IDLE
	NONE
}

var current_state: int
var entering_state: bool = false


func _ready() -> void:
	change_state(STATES. IDLE)


func _physics_process(delta: float) -> void:
	change_state(run_state(delta))
	
	
func change_state(new_state: int) -> void:
	if new_state != STATES.NONE:
		current_state = new_state
		entering_state = true
	
	
func run_state(delta: float) -> int:
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
	return STATES.NONE


func chase_player(delta: float) -> int:
	return STATES.NONE


func sleep(delta: float) -> int:
	return STATES.NONE
	
	
func idle(delta: float) -> int:
	return STATES.NONE
	
