extends NPC


func player_interacted() -> void:
	Global.dialog_box.play_dialog(npc_name, level, current_dialog)
