extends Node2D


export var max_vine_speed: Vector2
export var deacceleration: Vector2

var player: KinematicBody2D
var vines: int = 0


func _ready() -> void:
	for child in get_children():
		child.connect("body_entered", self, "_on_Vine_body_entered")
		child.connect("body_exited", self, "_on_Vine_body_exited")


func _physics_process(delta):
	if vines:
		if abs(player.velocity.x) > max_vine_speed.x:
			player.velocity.x = lerp(abs(player.velocity.x), max_vine_speed.x, deacceleration.x * delta) * sign(player.velocity.x)
		if abs(player.velocity.y) > max_vine_speed.y:
			player.velocity.y = lerp(abs(player.velocity.y), max_vine_speed.y, deacceleration.y * delta) * sign(player.velocity.y)
			

func _on_Vine_body_entered(body):
	if body.is_in_group("player"):
		vines += 1
		player = body


func _on_Vine_body_exited(body):
	if body.is_in_group("player"):
		vines -= 1
		if !vines:
			player = null
