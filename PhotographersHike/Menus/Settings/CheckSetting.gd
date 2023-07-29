extends HSplitContainer

signal toggled(button_pressed)

export var text: String

func _ready() -> void:
	$Label.text = text
	

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("button_pressed", button_pressed)
