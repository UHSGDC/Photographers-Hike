extends BaseMenu


func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)


func _on_ShowSpeedrunTimerBox_toggled(button_pressed):
	Global.speedrun_timer.visible = button_pressed


func _on_ShowDebugBox_toggled(button_pressed):
	Global.debug.visible = button_pressed


func _on_AimWithMouseCheckbox_toggled(button_pressed):
	Global.aim_with_mouse_rock_climbing = button_pressed


func _on_FullscreenCheckbox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_BorderlessBox_toggled(button_pressed):
	OS.window_borderless = button_pressed


func _on_HideJumpArrowBox_toggled(button_pressed):
	Global.emit_signal("hide_jump_arrow_toggled", button_pressed)


func _on_FasterJumpChargingBox_toggled(button_pressed):
	Global.emit_signal("faster_jump_charging_toggled", button_pressed)
