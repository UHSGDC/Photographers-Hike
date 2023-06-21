extends TextureRect




func _ready():
	modulate.a = 255
	$Timer.connect("timeout", self, "_on_Timer_timeout")



func _on_Timer_timeout():
	if modulate.a:
		modulate.a = 0
	else:
		modulate.a = 255
