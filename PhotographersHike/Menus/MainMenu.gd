extends BaseMenu


func _on_Play_pressed():
	menus.change_menu(menus.NONE)
	

func _on_Settings_pressed() -> void:
	menus.change_menu(menus.SETTINGS)


func _on_Album_pressed() -> void:
	menus.change_menu(menus.ALBUM)


func _on_Credits_pressed() -> void:
	menus.change_menu(menus.CREDITS)
