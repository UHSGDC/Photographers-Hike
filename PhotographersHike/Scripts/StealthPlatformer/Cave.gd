extends Node2D


func _ready() -> void:
	for cougar in $Cougars.get_children():
		cougar.navigation_node = $Navigation2D
