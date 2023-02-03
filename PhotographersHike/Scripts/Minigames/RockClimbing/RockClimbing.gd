extends Node2D



var occupied_rock: Area2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		for rock in $Rocks.get_children():
			if !rock.touching_mouse:
				continue
			if !rock.in_range:
				print("rock not in range")
				continue
			if rock == occupied_rock:
				print("rock occupied") # Add code so the player doesn't jump
			occupied_rock = rock
				
