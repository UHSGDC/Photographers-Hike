extends Node2D

signal player_in_area

export var yeti_scene: PackedScene

var yeti: Area2D

var player: Player

export var player_jump_cast_scene: PackedScene

var should_move_player_to_target: bool = false

var jump_cast: RayCast2D

export var player_cutscene_max_speed: float
export var player_cutscene_jump_multiplier: float

var should_stop: bool

var can_skip: bool = true

func _ready() -> void:
	$CougarFist/Cougar/AnimationPlayer.play("Sleep")


func _physics_process(delta: float) -> void:
	if should_move_player_to_target:
		move_player_to_target(delta)
		if sign(jump_cast.cast_to.x) != sign(player.velocity.x):
			jump_cast.cast_to.x = -jump_cast.cast_to.x
		player.state = player.get_state()


func move_player_to_target(delta: float) -> void:

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


	player.apply_gravity(delta)

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


func get_move_direction() -> float:
	return sign($CutsceneZone.global_position.x - player.global_position.x)


func create_jump_cast() -> RayCast2D:
	var jump_cast_instance: RayCast2D = player_jump_cast_scene.instance()
	player.add_child(jump_cast_instance)
	jump_cast_instance.global_position = player.global_position
	return jump_cast_instance
	

func _on_YetiController_body_entered(body: Node) -> void:
	if body.is_in_group("player") and !yeti:
		player = body
	else:
		return

	should_move_player_to_target = true
	player.in_cutscene = true
	player.current_cutscene = self

	jump_cast = create_jump_cast()

	should_stop = false	


func _on_CutsceneZone_body_entered(body: Node) -> void:
	if body != player:
		return

	if yeti:
		return

	yield(get_tree().create_timer(0.1), "timeout")

	should_stop = true


	yield(get_tree().create_timer(0.2), "timeout")
	should_move_player_to_target = false
	jump_cast.queue_free()
	jump_cast = null

	# Drop wall
	$AnimationPlayer.play("Drop Wall")
	yield($AnimationPlayer, "animation_finished")
	MusicPlayer.play_song("Boss", false)
	# Spawn yeti
	yeti = yeti_scene.instance()
	yeti.active = false
	
	$Path2D/PathFollow2D.add_child(yeti)
	$AnimationPlayer.play("Move Yeti")
	yield($AnimationPlayer, "animation_finished")
	$Path2D/PathFollow2D.remove_child(yeti)
	
	
	get_parent().add_child(yeti)
	yeti.global_position = $Path2D/PathFollow2D.global_position
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	$AnimationPlayer.play("Punch Cougar")
	yield($AnimationPlayer, "animation_finished")
	
	player.in_cutscene = false
	player.current_cutscene = null
	yield(get_tree().create_timer(0.5), "timeout")
	yeti.active = true
	
	
func skip() -> void:
	Global.platforming_player.global_position = $CutsceneZone.global_position
	$AnimationPlayer.playback_speed = 100
