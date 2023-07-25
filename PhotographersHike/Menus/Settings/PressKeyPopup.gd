extends ColorRect

signal input_selected(event)

var is_waiting_for_key: bool = false


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if not is_waiting_for_key: return
	get_tree().set_input_as_handled()
	
	
	if event is InputEventKey and event.is_pressed():
		accept_event()
		Global.emit_signal("input_changed")
		emit_signal("input_selected", event)
		self.is_waiting_for_key = false
		
		
		
	# TODO: Add something for mouse input


func popup() -> InputEvent:
	show()
	is_waiting_for_key = true
	var event = yield(self, "input_selected")
	
	hide()
	return event

