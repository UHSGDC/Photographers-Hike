extends BaseMenu


func _on_Full_Checkbox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Border_Checkbox_pressed():
	OS.window_borderless = !OS.window_borderless


func _on_VSYNC_Checkbox_pressed():
	OS.vsync_enabled = !OS.vsync_enabled


func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)
