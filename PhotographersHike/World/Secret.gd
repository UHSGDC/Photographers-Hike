extends Area2D

func _ready() -> void:
	$LevelTilemap.show()


func _on_ActivationArea_body_entered(body: Node) -> void:
	var tween = create_tween()
	tween.tween_property($LevelTilemap, "modulate", Color.transparent, 0.3)


func _on_ActivationArea_body_exited(body: Node) -> void:
	var tween = create_tween()
	tween.tween_property($LevelTilemap, "modulate", Color.white, 0.3)


func _on_Secret_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		return
	
	Global.secrets.append(name)
	
	set_deferred("monitoring", false)
	$AnimationPlayer.play("Found")
	
	
func reset_player() -> void:
	var tween = create_tween()
	tween.tween_property(Global.platforming_player, "modulate", Color.transparent, 0.3)
	yield(tween, "finished")
	Global.platforming_player.global_position = Global.platforming_player.current_checkpoint.global_position
	tween = create_tween()
	tween.tween_property(Global.platforming_player, "modulate", Color.white, 0.3)
	yield(tween, "finished")
