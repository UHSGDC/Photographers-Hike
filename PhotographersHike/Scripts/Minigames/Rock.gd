extends Area2D



var touching_mouse: bool = false
var occupied: bool = false

func _on_Rock_mouse_entered() -> void:
	$Light2D.enabled = true
	touching_mouse = true


func _on_Rock_mouse_exited() -> void:
	$Light2D.enabled = false
	touching_mouse = false
