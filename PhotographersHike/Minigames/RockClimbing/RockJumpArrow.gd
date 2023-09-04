extends Node2D

var sound_indicator_played: bool = false

func _ready() -> void:
	reset_arrow_progress()

func set_arrow_progress(value: float) -> void:
	$ArrowProgress.value = value * 100
	if value > 0.95:
		if !sound_indicator_played:
			$MaxChargeSound.play()
			sound_indicator_played = true
		$ArrowProgress/ArrowFlash.visible = true
	else:
		$ArrowProgress/ArrowFlash.visible = false
		sound_indicator_played = false
		
	
func reset_arrow_progress() -> void:
	$ArrowProgress.value = 0
	$ArrowProgress/ArrowFlash.visible = false
