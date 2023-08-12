extends CanvasLayer

var showing: bool = false

func _ready() -> void:
	Global.vision_circle = self


func _physics_process(delta: float) -> void:
	if showing:
		$TextureRect.rect_position = Global.platforming_player.global_position - Global.player_camera.global_position + Vector2(-240, -336)


func fade_in() -> void:
	showing = true
	$AnimationPlayer.play("Fade In")
	
func fade_out() -> void:
	$AnimationPlayer.play_backwards("Fade In")
	yield($AnimationPlayer,"animation_finished")
	showing = false
