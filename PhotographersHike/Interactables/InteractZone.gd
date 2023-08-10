extends Area2D


var player_in_range: bool = false

signal player_interacted


func _ready() -> void:
	$InteractInput.hide()
	set_interact_input_label()
	Global.connect("input_changed", self, "set_interact_input_label")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range and !Global.dialog_box.dialog_playing:
		emit_signal("player_interacted")


func set_interact_input_label() -> void:
	if InputHelper.device == InputHelper.DEVICE_KEYBOARD or InputHelper.device == InputHelper.DEVICE_GENERIC:
		$InteractInput.text = InputHelper.get_action_key("interact")
	else:
		$InteractInput.text = "Button" + str(InputHelper.get_action_button("interact"))
		

func _on_InteractZone_body_entered(body: Node) -> void:
	if body == Global.platforming_player:
		player_in_range = true
		set_interact_input_label()
		$InteractInput.show()


func _on_InteractZone_body_exited(body: Node) -> void:
	if body == Global.platforming_player:
		player_in_range = false
		$InteractInput.hide()
