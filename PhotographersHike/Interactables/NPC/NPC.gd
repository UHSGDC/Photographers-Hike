extends KinematicBody2D

class_name NPC

export(DialogBox.Levels) var level
export var npc_name: String

var current_dialog: int = 0

	
func player_interacted() -> void:
	Global.dialog_box.play_dialog(npc_name, level, current_dialog)
