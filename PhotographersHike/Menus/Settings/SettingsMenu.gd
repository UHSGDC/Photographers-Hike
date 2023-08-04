extends BaseMenu


func hide() -> void:
	.hide()
	$KeybindsPopup.call_deferred("hide")


func _back_input() -> void:
	if $KeybindsPopup.visible:
		$KeybindsPopup.hide()
		get_tree().set_input_as_handled()
		return


func _on_Back_pressed():
	menus.change_menu(menus.previous_menu)
