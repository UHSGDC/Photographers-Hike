extends Node2D


func _ready() -> void:
	reset_arrow_progress()

func set_arrow_progress(value: float) -> void:
	$TextureRect.value = value * 100
	
func reset_arrow_progress() -> void:
	$TextureRect.value = 0
