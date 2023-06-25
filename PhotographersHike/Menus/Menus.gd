extends CanvasLayer

class_name Menus

enum {
	MAIN
	INFO
	PAUSE
	SETTINGS
	NONE
}

var current_menu: int
var previous_menu: int


func _ready() -> void:
	for child in get_children():
		child.menus = self
	
	change_menu(NONE)


func change_menu(menu: int) -> void:
	for child in get_children():
		child.hide()
	
	match menu:
		MAIN:
			$MainMenu.show()
		INFO:
			$InfoMenu.show()
		PAUSE:
			$PauseMenu.show()
		SETTINGS:
			$SettingsMain.show()
		NONE:
			pass
			
			
	if menu != NONE:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
	previous_menu = current_menu
	current_menu = menu



func _input(event):
	if event.is_action_pressed("pause"):
		if current_menu == PAUSE:
			change_menu(NONE)
		elif current_menu == NONE:
			change_menu(PAUSE)
	
	if current_menu != MAIN and current_menu != PAUSE:
		if event.is_action_pressed("menu_cancel"):
			change_menu(previous_menu)
			
			
	
	
		
