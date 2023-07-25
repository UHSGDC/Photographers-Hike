extends Label

	
func display_warning() -> void:
	$AnimationPlayer.play("Show Pan Warning")
	yield($AnimationPlayer, "animation_finished")
