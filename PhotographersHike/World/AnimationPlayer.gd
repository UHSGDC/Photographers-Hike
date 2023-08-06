extends AnimationPlayer


var completed: bool = false


func _ready():
	 call_deferred("connect_respawn_signal")


func connect_respawn_signal() -> void:
	Global.platforming_player.connect("respawn", self, "_on_player_respawn")


func _process(delta):		
	if Input.is_key_pressed(KEY_9):
		play("RESET")


func _on_player_respawn():
	if !completed:
		play("RESET")

func _on_Activator_body_entered(body):
	if completed:
		return
	
	yield(Global.player_camera.screen_shake(0.5), "completed")
	play("Drop Snow and Flash")
	
	
func kill_yeti() -> void:
	get_parent().get_parent().get_node("Yeti").queue_free()


func _on_CompleteZone_body_entered(body):
	completed = true
