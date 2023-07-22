extends Node2D


var current_rock: Area2D

var velocity: Vector2 = Vector2.ZERO

export var min_jump_velocity: float
export var max_jump_velocity: float
export var jump_charge_speed: float = 300
var current_jump_velocity: float
var jump_charge_direction: int = 1

export var max_attach_speed: float 

var can_jump: bool = true

export var rock_detector_scene: PackedScene
export var jump_arrow_scene: PackedScene

var rock_detector: Node2D
var jump_arrow: Node2D


var player: Player

var can_charge: bool = false


func _ready() -> void:
	current_jump_velocity = min_jump_velocity
	call_deferred("set_player_reference")
	
	
func set_player_reference() -> void:
	player = Global.platforming_player
	

func _physics_process(delta: float) -> void:	
	if player.in_minigame:
		move(delta)


func move(delta: float) -> void:
	if current_rock:
		player.position = lerp(player.global_position, current_rock.global_position, 0.2)
		jump_arrow.look_at(get_global_mouse_position())
		player.velocity.x = sign(get_global_mouse_position().x - player.global_position.x)
		
	
	if Input.is_action_just_pressed("jump") && current_rock:
		can_charge = true
	if Input.is_action_pressed("jump") && current_rock && can_charge:
		charge_jump(delta)
	if Input.is_action_just_released("jump") && current_rock && can_charge:
		jump()
	
	if !current_rock:
		player.apply_gravity(delta)

	if player.is_on_floor() && !player.get_floor_angle():
		exit_minigame()

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
		
func jump() -> void:
	# Actual Jump
	
	var jump_direction: Vector2 = (get_global_mouse_position() - player.global_position).normalized()
	
	player.velocity = current_jump_velocity * jump_direction
	
	
	# Resetting Jump
	
	jump_arrow.reset_arrow_progress()
	jump_arrow.hide()
	current_rock = null
	current_jump_velocity = min_jump_velocity
	jump_charge_direction = 1
	can_charge = false
	

		
func charge_jump(delta: float) -> void:
	
	if current_jump_velocity >= max_jump_velocity:
		jump_charge_direction = -1
	if current_jump_velocity <= min_jump_velocity:
		jump_charge_direction = 1
	
	current_jump_velocity += jump_charge_speed * jump_charge_direction * delta
	
	jump_arrow.set_arrow_progress(current_jump_velocity / max_jump_velocity)


func exit_minigame() -> void:
	current_rock = null
	player.in_minigame = false


func start_minigame() -> void:
	player.in_minigame = true
	

func _on_Rock_touched(body: Node) -> void:
	
	if body.is_in_group("rock"):
		if player.velocity.length_squared() > pow(max_attach_speed, 2) && player.in_minigame:
			return
			
		if !player.in_minigame:
			start_minigame()
		
		jump_arrow.show()
		current_rock = body
		player.velocity.x = 0
		player.velocity.y = 0


func _on_RockClimbing_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Add rock detector
		rock_detector = rock_detector_scene.instance()
		player.call_deferred("add_child", rock_detector)
		var error = rock_detector.connect("area_entered", self, "_on_Rock_touched")
		if error:
			push_error("error connecting rock detector signal to self")		
		
		jump_arrow = jump_arrow_scene.instance()
		player.add_child(jump_arrow)
		jump_arrow.hide()


func _on_RockClimbing_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		# Remove rock detector
		rock_detector.queue_free()
		rock_detector = null
		
		jump_arrow.queue_free()
		jump_arrow = null
