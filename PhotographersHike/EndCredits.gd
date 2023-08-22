extends Node


func _ready() -> void:
	$CreditsMenu.hide()

func _on_SummitSign_cutscene_finished() -> void:
	var tween = create_tween()
	$CreditsMenu.show()
	$CreditsMenu.modulate = Color.transparent
	tween.tween_property($CreditsMenu, "modulate", Color.white, 5)
	yield(tween, "finished")
	$CreditsMenu.play()
