extends BaseMenu

export var desktop_only_settings: Array 

func _ready() -> void:
	if !OS.has_feature("pc"):
		for setting in desktop_only_settings:
			get_node(setting).queue_free()


func hide() -> void:
	.hide()
	$KeybindsPopup.call_deferred("hide")


func _back_input() -> void:
	if $KeybindsPopup.visible:
		$KeybindsPopup.hide()
		get_tree().set_input_as_handled()
		return
		
	._back_input()


func _on_Back_pressed():
	menus.change_menu(menus.previous_menu)


func _on_SpeedrunTimer_value_changed(value: bool) -> void:
	Global.speedrun_timer.visible = value


func _on_DebugMenu_value_changed(value: bool) -> void:
	Global.debug.visible = value


func _on_PreviousJumpArrow_value_changed(value: bool) -> void:
	Global.emit_signal("jump_arrow_toggled", value)


func _on_Fullscreen_value_changed(value: bool) -> void:
	OS.window_fullscreen = value


func _on_SlowerCharging_value_changed(value: bool) -> void:
	Global.emit_signal("faster_jump_charging_toggled", !value)


func _on_AimWKeyboard_value_changed(value: bool) -> void:
	Global.aim_with_mouse_rock_climbing = !value
