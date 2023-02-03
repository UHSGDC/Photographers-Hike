extends Area2D


func _on_RockDetector_area_entered(area: Area2D) -> void:
	if not area is Rock:
		print("area detected besides rock")
		return
		
	area.in_range = true


func _on_RockDetector_area_exited(area: Area2D) -> void:
	if not area is Rock:
		print("area detected besides rock")
		return
		
	area.in_range = false
