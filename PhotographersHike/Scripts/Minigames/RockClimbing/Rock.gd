extends Area2D

class_name Rock

var in_range: bool = false
var touching_mouse: bool = false

func _on_Rock_mouse_entered() -> void:
	$Light2D.enabled = true
	touching_mouse = true


func _on_Rock_mouse_exited() -> void:
	$Light2D.enabled = false
	touching_mouse = false
