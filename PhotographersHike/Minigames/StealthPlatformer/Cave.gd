extends Node2D


func _ready() -> void:
	for child in get_children():
		if child.is_in_group("cougar"):
			child.navigation_node = $Navigation2D
