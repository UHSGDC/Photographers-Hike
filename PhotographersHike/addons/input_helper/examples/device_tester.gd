extends Control


onready var current_device: Label = $Vbox/CurrentDevice

func _ready() -> void:
	var guessed_device_name = InputHelper.guess_device_name()
	current_device.text = guessed_device_name
	InputHelper.connect("device_changed", self, "_on_device_changed")

### Signals

func _on_device_changed(next_device, index):
	current_device.text = next_device
