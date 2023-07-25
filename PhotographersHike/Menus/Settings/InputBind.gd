extends HSplitContainer

export var input_name: String
export var input_action_name: String
var input_events: String
export var press_key_popup_node_path: NodePath
onready var press_key_popup_node: Control = get_node(press_key_popup_node_path)

export var BIND_DISPLAY_CONTAINER_PATH: NodePath
onready var bind_display_container_node: Control = get_node(BIND_DISPLAY_CONTAINER_PATH)

export var BIND_DISPLAY_SCENE: PackedScene
export var MAX_BINDS: int


func _ready() -> void:
	_set_input_name(input_name)
	_update_input_events()


func _set_input_name(text: String) -> void:
	$InputName.text = text


func _update_input_events() -> void:
	for child in bind_display_container_node.get_children():
		child.queue_free()
	
	for event in InputMap.get_action_list(input_action_name):
		new_bind_display(event.as_text())


func new_bind_display(text: String) -> void:
	var bind_display = BIND_DISPLAY_SCENE.instance()
	bind_display_container_node.add_child(bind_display)
	bind_display.set_text(text)
	

func _on_ClearButton_pressed() -> void:
	InputHelper.remove_all_events(input_action_name)
	_update_input_events()


func _on_AddButton_pressed() -> void:
	if bind_display_container_node.get_child_count() >= MAX_BINDS:
		push_error("max of 3 binds, why? cuz i said so!")
		return
	
	var event: InputEvent = yield(press_key_popup_node.popup(), "completed")
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		return
		
	var error = InputHelper.set_action_key(input_action_name, event.as_text(), false)
	if error:
		push_error("error trying to remap action keybind")
	
	_update_input_events()
