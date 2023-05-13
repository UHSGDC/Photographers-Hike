extends Area2D


export var vine_speed: Vector2
export var deacceleration: Vector2

var player: KinematicBody2D

func _physics_process(delta):
	if player:
		if abs(player.velocity.x) > vine_speed.x:
			player.velocity.x = lerp(abs(player.velocity.x), vine_speed.x, deacceleration.x * delta) * sign(player.velocity.x)
		if abs(player.velocity.y) > vine_speed.y:
			player.velocity.y = lerp(abs(player.velocity.y), vine_speed.y, deacceleration.y * delta) * sign(player.velocity.y)
			

func _on_Vine_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_Vine_body_exited(body):
	if body.is_in_group("player"):
		player = null
