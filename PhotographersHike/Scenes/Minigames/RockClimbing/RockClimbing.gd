extends Node2D


# Declare member variables here. Examples:
# var a: int = 2

var occupied_rock: Area2D

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		for rock in $Rocks.get_children():
			var in_range = true # Need to check whether rock is in range
			if rock.touching_mouse && in_range:
				if rock == occupied_rock:
					print("already on this rock")
				occupied_rock = rock
				
