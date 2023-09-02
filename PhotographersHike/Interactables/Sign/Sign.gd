extends Sprite

signal cutscene_finished


export var picture_texture: Texture

export var player_jump_cast_scene: PackedScene

var should_move_player_to_sign: bool = false

var jump_cast: RayCast2D

export var should_play_cutscene: bool = false

var player: Player

export var player_cutscene_max_speed: float
export var player_cutscene_jump_multiplier: float


var should_stop: bool

export var can_skip: bool = true

var should_skip: bool = false

var falling: bool = false


func _ready():
	$DirectionLabel.modulate = Color.transparent


func _physics_process(delta: float) -> void:
	if should_move_player_to_sign:
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
		$JumpSound.play()
		player.dust_particles()
		
		
	player.apply_gravity(delta)
	
	falling = !player.is_on_floor()
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if falling and player.is_on_floor():
		$LandSound.play()


func get_move_direction() -> float:
	return sign(position.x - player.position.x)


func _on_CutsceneActivation_body_entered(body: Node) -> void:
	if player:
		return
	if body == Global.platforming_player:
		player = body
		
	if !should_play_cutscene:
		return
	
	should_move_player_to_sign = true
	player.in_cutscene = true
	player.current_cutscene = self
	
	jump_cast = create_jump_cast()
	
	should_stop = false
	
	
func create_jump_cast() -> RayCast2D:
	var jump_cast_instance: RayCast2D = player_jump_cast_scene.instance()
	player.add_child(jump_cast_instance)
	jump_cast_instance.global_position = player.global_position
	return jump_cast_instance


func _on_SignArea_body_entered(body: Node) -> void:
	if body != player:
		return
	
	if !should_play_cutscene:
		var tween = get_tree().create_tween()
		tween.tween_property($DirectionLabel, "modulate", Color.white, 0.5)
	else:
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		should_stop = true
		
		
		
		yield(get_tree().create_timer(0.05), "timeout")
		if should_skip:
			return
		
		can_skip = false
		player.state = player.States.PICTURE
		should_play_cutscene = false
		should_move_player_to_sign = false
		jump_cast.queue_free()
		jump_cast = null
		
		Global.player_camera.zoom_speed = 0.3
		Global.player_camera.zoom_to = Vector2.ONE * 0.5
		
		yield(player, "animation_finished") # Player animation done
		
		Global.camera_item.display_and_store_image(picture_texture.get_data())
		$VictorySound.play()
		yield(get_tree().create_timer(1), "timeout")
		Global.player_camera.zoom_to = Vector2.ONE
		yield(player, "animation_finished")
		
		player.in_cutscene = false
		player.current_cutscene = null
		emit_signal("cutscene_finished")
		
		var tween = get_tree().create_tween()
		tween.tween_property($DirectionLabel, "modulate", Color.white, 0.5)


func _on_SignArea_body_exited(body: Node) -> void:
	if body != player:
		return
	var tween = get_tree().create_tween()
	tween.tween_property($DirectionLabel, "modulate", Color.transparent, 0.5)
	

func skip() -> void:
	should_skip = true
	Global.platforming_player.global_position = $SkipPosition.global_position
	yield(get_tree().create_timer(0.1), "timeout")
	should_stop = true
	Global.camera_item.display_and_store_image(picture_texture.get_data())
	$VictorySound.play()
	should_play_cutscene = false
	should_move_player_to_sign = false
	if jump_cast:
		jump_cast.queue_free()
	jump_cast = null
	player.in_cutscene = false
	player.current_cutscene = null
	var tween = get_tree().create_tween()
	tween.tween_property($DirectionLabel, "modulate", Color.white, 0.5)
	
