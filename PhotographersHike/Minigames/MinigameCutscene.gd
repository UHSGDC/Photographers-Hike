extends Area2D

signal finished_zoom

export var zoom: Vector2

var zoom_signal_emitted: bool = false

export var player_jump_cast_scene: PackedScene

var should_move_player_to_target: bool = false

var jump_cast: RayCast2D

var was_cutscene_played: bool = false

var player: Player

export var player_cutscene_max_speed: float
export var player_cutscene_jump_multiplier: float

var should_stop: bool




func _process(delta: float) -> void:
	if Global.player_camera.zoom_to == Global.player_camera.zoom:
		if !zoom_signal_emitted:
			emit_signal("finished_zoom")
			zoom_signal_emitted = true
	else:
		zoom_signal_emitted = false

func _physics_process(delta: float) -> void:
	if should_move_player_to_target:
		move_player_to_target(delta)
		if sign(jump_cast.cast_to.x) != sign(player.velocity.x):
			jump_cast.cast_to.x = -jump_cast.cast_to.x
		player.state = player.get_state()


func play_cutscene() -> void:
	# zoom out
	
	$Path2D/PathFollow2D/CutsceneCamera.zoom = zoom
	Global.player_camera.zoom_speed = 0.6
	Global.player_camera.zoom_to = zoom
	yield(self, "finished_zoom")
	
	# follow path
	$Path2D/PathFollow2D/CutsceneCamera.global_position = Global.player_camera.global_position
	Global.player_camera.current = false
	$Path2D/PathFollow2D/CutsceneCamera.current = true
	
	var tween = create_tween()
	tween.tween_property($Path2D/PathFollow2D/CutsceneCamera, "position", Vector2.ZERO, 0.3)
	yield(tween, "finished")
	
	$AnimationPlayer.play("Follow Path")
	yield($AnimationPlayer, "animation_finished")
	
	# return from path
	$AnimationPlayer.play_backwards("Follow Path")
	yield($AnimationPlayer, "animation_finished")
	
	tween = create_tween()
	tween.tween_property($Path2D/PathFollow2D/CutsceneCamera, "global_position", Global.player_camera.global_position, 0.3)
	yield(tween, "finished")
	
	
	# zoom out
	Global.player_camera.current = true
	$Path2D/PathFollow2D/CutsceneCamera.current = false
	Global.player_camera.zoom_to = Vector2.ONE



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


	player.apply_gravity(delta)

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


func get_move_direction() -> float:
	return sign($CutsceneZone.global_position.x - player.global_position.x)


func create_jump_cast() -> RayCast2D:
	var jump_cast_instance: RayCast2D = player_jump_cast_scene.instance()
	player.add_child(jump_cast_instance)
	jump_cast_instance.global_position = player.global_position
	return jump_cast_instance


func _on_CutsceneZone_body_entered(body: Node) -> void:
	if body != player:
		return

	if was_cutscene_played:
		return

	yield(get_tree().create_timer(0.1), "timeout")

	should_stop = true


	yield(get_tree().create_timer(0.2), "timeout")
	was_cutscene_played = true
	should_move_player_to_target = false
	jump_cast.queue_free()
	jump_cast = null

	yield(play_cutscene(), "completed")
	player.in_cutscene = false


func _on_MinigameCutscene_body_entered(body: Node) -> void:
	if was_cutscene_played:
		return
	if body.is_in_group("player"):
		player = body

	should_move_player_to_target = true
	player.in_cutscene = true

	jump_cast = create_jump_cast()

	should_stop = false
