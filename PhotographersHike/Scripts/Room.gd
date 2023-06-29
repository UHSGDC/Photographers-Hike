extends Area2D

class_name LevelRoom

func get_checkpoints() -> Array:
	return $Checkpoints.get_children()
