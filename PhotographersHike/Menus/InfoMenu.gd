extends BaseMenu

func _on_LinkButton_pressed():
	var error = OS.shell_open("https://github.com/Aj-Cdr/Photographer-s-Hike-UHSGDC-Info")
	if error:
		push_error("error trying to open github link")
