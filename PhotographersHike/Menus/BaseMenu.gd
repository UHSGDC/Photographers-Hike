extends Control

class_name BaseMenu

var menus: Menus

func _input(event: InputEvent) -> void:
	if menus.current_menu != menus.MAIN and menus.current_menu != menus.NONE and Input.is_action_just_pressed("menu_cancel"):
		_back_input()

func _back_input() -> void:
	menus.change_menu(menus.previous_menu)
