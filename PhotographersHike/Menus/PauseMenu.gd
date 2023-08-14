extends BaseMenu

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
