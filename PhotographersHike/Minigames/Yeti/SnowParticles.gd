extends CPUParticles2D


func restart() -> void:
	.restart()
	for child in get_children():
		child.restart()
