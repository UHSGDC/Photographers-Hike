extends Node2D


var completed: bool = false

func _ready():
	 call_deferred("connect_respawn_signal")


func connect_respawn_signal() -> void:
	Global.platforming_player.connect("respawn", self, "_on_player_respawn")


func _on_player_respawn() -> void:
	Global.player_camera.end_screen_shake()
	

func _on_YetiActivation_area_entered(area: Area2D) -> void:
	if Global.player_camera.should_screen_shake:
		area.active = false
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("Drop Snow and Flash")
		yield(get_tree().create_timer(0.5), "timeout")
		Global.player_camera.end_screen_shake()
		completed = true
		area.queue_free()
		Global.yeti = null
		
		MusicPlayer.play_song("Summit")


func _on_ScreenShakeZone_body_entered(body: Node) -> void:
	if completed or !Global.yeti:
		return
		
	Global.player_camera.start_screen_shake()


func play_snow_particles() -> void:
	$SnowParticles.restart()
