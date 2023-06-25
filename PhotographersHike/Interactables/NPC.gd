extends KinematicBody2D

export(DialogBox.Levels) var level
export var npc_name: String

var current_dialogue: int = 0


func _on_InteractZone_player_interacted() -> void:
	Global.dialog_box.play_dialog(npc_name, level, current_dialogue)
	
	
