extends TextureRect


func _ready():
	modulate.a = 255
	

func _on_Timer_timeout():
	if modulate.a:
		modulate.a = 0
	else:
		modulate.a = 255
