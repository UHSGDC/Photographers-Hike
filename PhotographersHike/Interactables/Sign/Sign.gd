extends Sprite


export var picture_texture: Texture

export var player_jump_cast_scene: PackedScene

var should_move_player_to_sign: bool = false

var jump_cast: RayCast2D

var was_cutscene_played: bool = false

var player: KinematicBody2D

export var player_cutscene_max_speed: float
export var player_cutscene_jump_multiplier: float


var should_stop: bool

func _physics_process(delta: float) -> void:
	if should_move_player_to_sign:
		move_player_to_sign(delta)
		if sign(jump_cast.cast_to.x) != sign(player.velocity.x):
			jump_cast.cast_to.x = -jump_cast.cast_to.x


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
		
		
	player.apply_gravity(delta)
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


func get_move_direction() -> float:
	return sign(position.x - player.position.x)


func _on_CutsceneActivation_body_entered(body: Node) -> void:
	if was_cutscene_played:
		return
	if body == Global.platforming_player:
		player = body
	
	should_move_player_to_sign = true
	player.in_cutscene = true
	
	jump_cast = create_jump_cast()
	
	should_stop = false
	
	
func create_jump_cast() -> RayCast2D:
	var jump_cast: RayCast2D = player_jump_cast_scene.instance()
	player.add_child(jump_cast)
	jump_cast.global_position = player.global_position
	return jump_cast


func _on_SignArea_body_entered(body: Node) -> void:
	if body == player and !was_cutscene_played:
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		should_stop = true
		
		yield(get_tree().create_timer(0.2), "timeout")
		was_cutscene_played = true
		should_move_player_to_sign = false
		jump_cast.queue_free()
		jump_cast = null
		
		yield(get_tree().create_timer(0.5), "timeout")
		player.in_cutscene = false
		Global.camera_item.display_and_store_image(picture_texture.get_data())
