extends CanvasLayer

onready var shader: ShaderMaterial = $ColorRect.material

func _ready() -> void:
	Global.vision_circle = self


func _physics_process(delta: float) -> void:	
	shader.set_shader_param("center", Global.platforming_player.global_position - Global.player_camera.global_position + Vector2(240, 144))


func fade_in() -> void:
	$AnimationPlayer.play("Fade In")
	
func fade_out() -> void:
	$AnimationPlayer.play_backwards("Fade In")
