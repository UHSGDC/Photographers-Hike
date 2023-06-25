extends BaseMenu


func _on_Quit_pressed():
	get_tree().quit()


func _on_Menu_pressed():
	menus.change_menu(menus.MAIN)


func _on_Settings_pressed():
	menus.change_menu(menus.SETTINGS)


func _on_Resume_pressed():
	menus.change_menu(menus.NONE)
