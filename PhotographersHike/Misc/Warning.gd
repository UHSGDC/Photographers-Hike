extends Label

	
func _ready() -> void:
	show()
	
	
func display_warning() -> void:
	$AnimationPlayer.play("Show Pan Warning")
	yield($AnimationPlayer, "animation_finished")
