extends CPUParticles2D


export var x_offset: int


func _ready() -> void:
	$WindSound.play()
	$WindSound.pitch_scale = 1 / speed_scale -0.1
