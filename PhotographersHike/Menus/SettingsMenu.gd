extends BaseMenu


func _on_Full_Checkbox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Border_Checkbox_pressed():
	OS.window_borderless = !OS.window_borderless


func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)


func _on_ShowSpeedrunTimerBox_toggled(button_pressed):
	Global.speedrun_timer.visible = button_pressed


func _on_ShowDebugBox_toggled(button_pressed):
	Global.debug.visible = button_pressed


func _on_AimWithMouseCheckbox_toggled(button_pressed):
	Global.aim_with_mouse_rock_climbing = button_pressed
