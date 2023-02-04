extends Node2D


export var total_jumps: int = 10
onready var current_jumps: int = total_jumps

onready var jump_counter: CanvasLayer = $JumpCounter

var occupied_rock: Area2D

func _ready() -> void:
	$JumpCounter.update_jumps(current_jumps)


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
			else:
				if current_jumps == 0:
					print("player ran out of jumps should fall now")
					break
				current_jumps -= 1
				$JumpCounter.update_jumps(current_jumps)
			occupied_rock = rock
				
