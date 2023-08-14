extends Control

class_name BaseMenu

var menus: Menus

func _input(event: InputEvent) -> void:
	if !visible:
		return
	
	if menus.current_menu != menus.MAIN and menus.current_menu != menus.NONE and (Input.is_action_just_pressed("menu_cancel") or Input.is_action_just_pressed("pause")):
		_back_input()
		
		
		

func _back_input() -> void:
	menus.change_menu(menus.previous_menu)
	get_tree().set_input_as_handled()
