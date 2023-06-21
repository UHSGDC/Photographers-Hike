extends Area2D


func punch(yeti: Sprite) -> void:
	yeti.punches += 1
	yeti.can_punch = false
	global_position = Global.platforming_player.global_position

	$AnimationPlayer.play("punch")

	yield(get_tree().create_timer(yeti.punch_cooldown), "timeout")
	yeti.can_punch = true
	
	yield($AnimationPlayer, "animation_finished")
	
	yeti.punches -= 1
	
	queue_free()


func _on_YetiFist_body_entered(body: Node) -> void:
	print_debug("kill player")
