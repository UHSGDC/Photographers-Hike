extends CPUParticles2D


func restart() -> void:
	.restart()
	for child in get_children():
		child.restart()
	
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
