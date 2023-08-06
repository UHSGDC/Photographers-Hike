extends AnimationPlayer


func _process(delta):
	if Input.is_key_pressed(KEY_0):
		
		
		yield(Global.player_camera.screen_shake(1), "completed")
		play("Drop Snow and Flash")
	if Input.is_key_pressed(KEY_9):
		play("RESET")
