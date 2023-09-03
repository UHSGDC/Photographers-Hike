extends BaseMenu

func show() -> void:
	.show()
	$ColorRect/VBoxContainer/Secrets.visible = Global.summit
	if Global.platforming_player.current_cutscene and Global.platforming_player.current_cutscene.can_skip:
		$ColorRect/VBoxContainer/Skip.show()
	else:
		$ColorRect/VBoxContainer/Skip.hide()

func _back_input() -> void:
	menus.change_menu(menus.NONE)
	get_tree().set_input_as_handled()

func _on_Settings_pressed():
	menus.change_menu(menus.SETTINGS)


func _on_Resume_pressed():
	menus.change_menu(menus.NONE)


func _on_Album_pressed() -> void:
	menus.change_menu(menus.ALBUM)


func _on_Main_pressed() -> void:
	menus.change_menu(menus.MAIN)


func _on_Skip_pressed() -> void:
	menus.change_menu(menus.NONE)
	Global.platforming_player.current_cutscene.skip()


func _on_Secrets_pressed() -> void:
	menus.change_menu(menus.SECRETS)
