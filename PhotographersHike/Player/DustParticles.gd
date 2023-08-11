extends CPUParticles2D




func restart() -> void:
	.restart()
	$CPUParticles2D.restart()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
