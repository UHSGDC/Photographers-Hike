extends KinematicBody2D

class_name NPC

export(DialogBox.Levels) var level
export var npc_name: String

var current_dialog: int = 0

export var player_jump_cast_scene: PackedScene

var should_move_player: bool = false

var jump_cast: RayCast2D

var was_cutscene_played: bool = false

var player: Player

export var player_cutscene_max_speed: float
export var player_cutscene_jump_multiplier: float

var should_stop: bool

var can_skip: bool = true
var should_skip: bool = false

var falling: bool = false
	
func _physics_process(delta: float) -> void:
	if should_move_player:
		move_player_to_sign(delta)
		if sign(jump_cast.cast_to.x) != sign(player.velocity.x):
			jump_cast.cast_to.x = -jump_cast.cast_to.x
		player.state = player.get_state()


func move_player_to_sign(delta: float) -> void:
	
	var direction: float
	
	if !should_stop:
		direction = get_move_direction()
	else:
		direction = 0
	
	
	player.velocity.x += direction * player.move_acceleration * delta
	
	# Deaccelerates player velocity.x to 0 if player isn't inputting a direction
	if !direction:
		if abs(player.velocity.x) < player.idle_deacceleration * delta:
			player.velocity.x = 0
		else:
			player.velocity.x -= player.idle_deacceleration * sign(player.velocity.x) * delta
	
	# Clamps velocity.x to max_move_speed
	if player.velocity.x > player_cutscene_max_speed:
		player.velocity.x = lerp(player.velocity.x, player_cutscene_max_speed, 0.4)
	elif player.velocity.x < -player_cutscene_max_speed:
		player.velocity.x = lerp(player.velocity.x, -player_cutscene_max_speed, 0.4)
	
	if player.is_on_floor() and jump_cast.is_colliding():
		player.velocity.y = player.jump_velocity * player_cutscene_jump_multiplier
		player.dust_particles()
		$JumpSound.play()
		
		
	player.apply_gravity(delta)
	
	falling = !player.is_on_floor()
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if falling and player.is_on_floor():
		$LandSound.play()
	
	
func get_move_direction() -> float:
	return sign($DialogActivation.global_position.x - player.global_position.x)


func create_jump_cast() -> RayCast2D:
	var jump_cast_instance: RayCast2D = player_jump_cast_scene.instance()
	player.add_child(jump_cast_instance)
	jump_cast_instance.global_position = player.global_position
	return jump_cast_instance


func _on_CutsceneActivation_body_entered(body: Node) -> void:
	if was_cutscene_played:
		return
	if body.is_in_group("player"):
		player = body
	else:
		return
	can_skip = true
	should_move_player = true
	player.in_cutscene = true
	player.current_cutscene = self

	jump_cast = create_jump_cast()

	should_stop = false
	
	
func _on_DialogActivation_body_entered(body: Node) -> void:
	if body != player:
		return

	if was_cutscene_played:
		return

	yield(get_tree().create_timer(0.1), "timeout")

	should_stop = true


	yield(get_tree().create_timer(0.2), "timeout")
	was_cutscene_played = true
	should_move_player = false
	jump_cast.queue_free()
	jump_cast = null
	
	can_skip = false
	if !should_skip:
		yield(Global.dialog_box.play_dialog(npc_name, level, current_dialog), "completed")
	
	player.in_cutscene = false
	player.current_cutscene = null
	

func skip() -> void:
	Global.platforming_player.global_position = $Position2D.global_position
	should_skip = true



