extends CanvasLayer

class_name Menus

enum {
	MAIN
	CREDITS
	PAUSE
	SETTINGS
	ALBUM
	SECRETS
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
		CREDITS:
			$CreditsMenu.show()
		PAUSE:
			$PauseMenu.show()
		SETTINGS:
			$SettingsMenu.show()
		ALBUM:
			$AlbumMenu.update_album()
			$AlbumMenu.show()
		SECRETS:
			$SecretsMenu.show()
		NONE:
			pass
			
			
	if menu != NONE:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
	previous_menu = current_menu
	current_menu = menu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_menu == PAUSE:
			change_menu(NONE)
		elif current_menu == NONE:
			change_menu(PAUSE)
