extends Node


func _ready() -> void:
	$CreditsMenu.hide()

func _on_SummitSign_cutscene_finished() -> void:
	var tween = create_tween()
	$CreditsMenu.show()
	$CreditsMenu.modulate = Color.transparent
	tween.tween_property($CreditsMenu, "modulate", Color.white, 5)
	Global.platforming_player.state = Global.platforming_player.States.IDLE
	Global.platforming_player.in_cutscene = true
	yield(tween, "finished")
	$CreditsMenu.play()
