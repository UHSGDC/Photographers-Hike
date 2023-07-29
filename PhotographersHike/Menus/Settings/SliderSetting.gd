extends HSplitContainer

signal value_changed(value)

export var text: String

func _ready() -> void:
	$Label.text = text


func _on_HSlider_value_changed(value: float) -> void:
	emit_signal("value_changed", value)
