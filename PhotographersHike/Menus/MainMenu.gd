extends BaseMenu


func _on_Play_pressed():
	menus.change_menu(menus.NONE)


func _on_Info_pressed():
	menus.change_menu(menus.INFO)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed() -> void:
	menus.change_menu(menus.SETTINGS)


func _on_Album_pressed() -> void:
	menus.change_menu(menus.ALBUM)
