extends Panel

export var press_key_popup_path: NodePath
export var warning_container_path: NodePath


func _ready() -> void:
	hide()	
	
	for child in $SettingsWindow/ScrollContainer/MarginContainer/VBoxContainer.get_children():
		child.press_key_popup_node = get_node(press_key_popup_path)
		child.warning_container_node = get_node(warning_container_path)
		

func _on_KeybindSetting_pressed() -> void:
	show()


func _on_Close_pressed():
	hide()


func _on_Reset_pressed():
	InputHelper.reset_all_actions()
