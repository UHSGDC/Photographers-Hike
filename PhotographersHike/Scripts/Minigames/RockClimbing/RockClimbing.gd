extends Node2D


var current_rock: Area2D

var velocity: Vector2 = Vector2.ZERO

export var min_jump_velocity: float
export var max_jump_velocity: float
export var jump_charge_speed: float = 300
var current_jump_velocity: float
var jump_charge_increasing: int = 1

export var air_speed: float
export var max_attach_speed_squared: float 

export var gravity: float

var can_jump: bool = true

export var rock_detector_scene: PackedScene

var rock_detector

onready var player: KinematicBody2D = Global.platforming_player

var can_charge: bool = false


func _ready() -> void:
	current_jump_velocity = min_jump_velocity
	

func _physics_process(delta: float) -> void:
	if player.in_minigame:
		move(delta)
		
func move(delta: float) -> void:
	
	if current_rock:
		player.position = lerp(player.position, current_rock.global_position, 0.2)
	
	if Input.is_action_just_pressed("jump") && current_rock:
		can_charge = true
	if Input.is_action_pressed("jump") && current_rock && can_charge:
		charge_jump(delta)
	if Input.is_action_just_released("jump") && current_rock && can_charge:
		jump()
	
	if !current_rock:
		apply_gravity(delta)

	if player.is_on_floor():
		exit_minigame()

	
	velocity = player.move_and_slide(velocity, Vector2.UP)
	
		
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta
	
		
func jump() -> void:
	# Actual Jump
	velocity.y = -current_jump_velocity
	
	if Input.is_action_pressed("right"):
		velocity.x += air_speed
	
	if Input.is_action_pressed("left"):
		velocity.x -= air_speed
	
	# Resetting Jump
	current_rock = null
	
	current_jump_velocity = min_jump_velocity
	jump_charge_increasing = 1
	
	can_charge = false
	

		
func charge_jump(delta: float) -> void:
	if current_jump_velocity >= max_jump_velocity:
		jump_charge_increasing = -1
	if current_jump_velocity <= min_jump_velocity:
		jump_charge_increasing = 1
		
	current_jump_velocity += jump_charge_speed * jump_charge_increasing * delta

func exit_minigame() -> void:
	current_rock = null
	player.in_minigame = false
	player.velocity = velocity
	print("exited minigame")


func start_minigame() -> void:
	player.in_minigame = true
	

func _on_Rock_touched(body: Node) -> void:
	
	if body.is_in_group("rock"):
		if velocity.length_squared() > max_attach_speed_squared:
			return
		if !player.in_minigame:
			start_minigame()
			
		
		current_rock = body
		velocity.x = 0
		velocity.y = 0


func _on_RockClimbing_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		rock_detector = rock_detector_scene.instance()
		player.call_deferred("add_child", rock_detector)
		rock_detector.connect("area_entered", self, "_on_Rock_touched")


func _on_RockClimbing_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		rock_detector.queue_free()
		rock_detector = null
