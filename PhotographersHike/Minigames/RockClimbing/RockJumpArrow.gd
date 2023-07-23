extends Node2D


func _ready() -> void:
	reset_arrow_progress()

func set_arrow_progress(value: float) -> void:
	$ArrowProgress.value = value * 100
	$ArrowProgress/ArrowFlash.visible = value > 0.95
	
func reset_arrow_progress() -> void:
	$ArrowProgress.value = 0
	$ArrowProgress/ArrowFlash.visible = false
