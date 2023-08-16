extends TextureRect


func _ready() -> void:
	modulate.a = 255
	
func show() -> void:
	.show()
	modulate.a = 255
	$Timer.start()

func hide() -> void:
	.hide()
	$Timer.stop()
	

func _on_Timer_timeout() -> void:
	if modulate.a:
		modulate.a = 0
	else:
		modulate.a = 255
