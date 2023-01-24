extends Area2D


var touching_mouse: bool = false


func _on_Rock_mouse_entered() -> void:
	touching_mouse = true


func _on_Rock_mouse_exited() -> void:
	touching_mouse = false
