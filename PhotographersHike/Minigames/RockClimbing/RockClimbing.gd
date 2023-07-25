extends Area2D


var current_rock: Area2D
var last_rock: Area2D

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
var can_keyboard_aim: bool = true

var track_path: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

export var keyboard_aim_speed: float


func _ready() -> void:
	current_jump_velocity = min_jump_velocity
	Global.connect("hide_jump_arrow_toggled", self, "on_hide_jump_arrow_toggled")
	call_deferred("set_player_reference")
	call_deferred("connect_respawn_signal")
	randomize_rock_textures()
	
func connect_respawn_signal() -> void:
	Global.platforming_player.connect("respawn", self, "stop_tracking_path")	

	
func on_hide_jump_arrow_toggled(value: bool) -> void:
	$Line2D.modulate.a = int(!value)
	
	
func stop_tracking_path() -> void:
	track_path = false
	
	
func randomize_rock_textures() -> void:
	rng.randomize()
	for rock in $Rocks.get_children():
		rock.get_node("Sprite").frame = rng.randi_range(0, 3)
	
	
func set_player_reference() -> void:
	player = Global.platforming_player
	

func _physics_process(delta: float) -> void:	
	if player.in_minigame:
		move(delta)


func move(delta: float) -> void:
	if current_rock:
		player.position = lerp(player.global_position, current_rock.global_position, 0.2)
		player.velocity.x = sign(Vector2.RIGHT.rotated(jump_arrow.rotation).x)
		aim_arrow(delta)
		
	
	if Input.is_action_just_pressed("jump") && current_rock:
		can_charge = true
	if Input.is_action_pressed("jump") && current_rock && can_charge:
		charge_jump(delta)
	if Input.is_action_just_released("jump") && current_rock && can_charge:
		jump()
	
	if Input.is_action_just_pressed("interact"):
		reset_jump()
	
	if !current_rock:
		player.apply_gravity(delta)
		if track_path:
			last_rock.last_jump_path = add_point_to_rock_path(player.global_position, last_rock.last_jump_path)

	if player.is_on_floor() && !player.get_floor_angle():
		exit_minigame()

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	
func aim_arrow(delta: float) -> void:
	if Global.aim_with_mouse_rock_climbing:
		jump_arrow.look_at(get_global_mouse_position())
	elif can_keyboard_aim:
		var rotation_direction = Input.get_axis("left", "right")
		jump_arrow.rotate(rotation_direction * keyboard_aim_speed * delta)
	
	
		
func jump() -> void:
	# Actual Jump
	
	var jump_direction: Vector2 = Vector2.RIGHT.rotated(jump_arrow.rotation)
	
	var jump_velocity = current_jump_velocity
	
	if current_jump_velocity / max_jump_velocity > 0.95:
		jump_velocity = max_jump_velocity
	
	player.velocity = jump_velocity * jump_direction
	
	last_rock = current_rock
	track_path = true
	
	reset_jump()
	
	current_rock.last_jump_strength = jump_velocity
	current_rock.last_jump_rotation = jump_arrow.rotation
	can_keyboard_aim = false
	clear_path(current_rock)
	jump_arrow.hide()
	current_rock = null
	

func reset_jump() -> void:
	jump_arrow.reset_arrow_progress()	
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
	track_path = false
	current_rock = null
	player.in_minigame = false


func start_minigame() -> void:
	player.in_minigame = true
	

func _on_Rock_touched(body: Node) -> void:
	if body.is_in_group("rock"):
		track_path = false
		
		if player.velocity.length_squared() > pow(max_attach_speed, 2) && player.in_minigame:
			return
			
		if !player.in_minigame:
			start_minigame()
		
		jump_arrow.show()
		current_rock = body
		player.velocity.x = 0
		player.velocity.y = 0
		
		if body.last_jump_path.size() > 0:
			$Line2D.width = current_rock.last_jump_strength / max_jump_velocity * 3
			display_path(current_rock.last_jump_path)
			jump_arrow.rotation = current_rock.last_jump_rotation
			yield(get_tree().create_timer(0.2), "timeout")
		can_keyboard_aim = true


func display_path(path: PoolVector2Array):
	$Line2D.show()
	$Line2D.global_position = Vector2.ZERO
	$Line2D.points = path
	
	
func clear_path(rock: Area2D):
	rock.last_jump_path = PoolVector2Array()
	$Line2D.hide()


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
		
		
func add_point_to_rock_path(point: Vector2, path: PoolVector2Array) -> PoolVector2Array:
	path.append(point)
	return path
