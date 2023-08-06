extends Area2D


func punch(yeti: Area2D) -> void:
	yeti.punches += 1
	yeti.can_punch = false
	global_position = Global.platforming_player.global_position

	$AnimationPlayer.play("punch")
	
	
	$CanPunchTimer.start(yeti.punch_cooldown)
	yield($CanPunchTimer, "timeout")
	yeti.can_punch = true
	
	yield($AnimationPlayer, "animation_finished")
	
	yeti.punches -= 1
	
	queue_free()


func _on_YetiFist_body_entered(body: Node) -> void:
	if !Global.platforming_player.death_pause:
		Global.platforming_player.respawn()
