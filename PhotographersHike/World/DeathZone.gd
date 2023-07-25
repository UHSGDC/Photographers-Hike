extends Area2D

class_name DeathZone

func _ready() -> void:
	var error = connect("body_entered", self, "_on_DeathZone_body_entered")
	if error:
		push_error("error connecting deathzone entered signal to self")

func _on_DeathZone_body_entered(body: Node) -> void:
	if body.is_in_group("player") and !body.death_pause:
		body.respawn()
