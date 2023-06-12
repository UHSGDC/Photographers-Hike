extends Sprite


func _ready():
	visible = true
	$Timer.connect("timeout", self, "_on_Timer_timeout")



func _on_Timer_timeout():
	visible = not visible

