extends Sprite

export var dialog_id: int

export(DialogBox.Levels) var level

func _on_InteractZone_player_interacted() -> void:
	$InteractZone.hide()
	yield(Global.dialog_box.play_dialog("sign", level, dialog_id), "completed")
	$InteractZone.show()
