extends BaseMenu

func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)


func show() -> void:
	.show()
	
	for child in $AlbumWindow.get_children():
		child.modulate = Color.black
		for secret in Global.secrets:
			if secret == child.name:
				child.modulate = Color.white
