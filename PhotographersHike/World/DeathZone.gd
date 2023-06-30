extends Area2D


func _on_DeathZone_body_entered(body: Node) -> void:
	if body == Global.platforming_player:
		Global.platforming_player.respawn()
