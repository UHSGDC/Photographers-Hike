extends CanvasLayer

class_name Menus

enum {
	MAIN
	INFO
	PAUSE
	SETTINGS
	ALBUM
	NONE
}

var current_menu: int
var previous_menu: int


func _ready() -> void:
	show()
	
	for child in get_children():
		child.menus = self
	
	yield(get_tree().create_timer(0.1), "timeout")
	change_menu(MAIN)


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
		ALBUM:
			$AlbumMenu.update_album()
			$AlbumMenu.show()	
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
	
	if current_menu != MAIN and current_menu != PAUSE and current_menu != NONE:
		if event.is_action_pressed("menu_cancel"):
			change_menu(previous_menu)
			
			
	
	
		
