extends VBoxContainer

export var answer_button_scene: PackedScene

signal answer_selected(text)


func init(answer_text_array: PoolStringArray) -> void:
	for text in answer_text_array:
		var answer_button: Button = answer_button_scene.instance()
		add_child(answer_button)
		answer_button.text = text
		answer_button.connect("pressed", self, "_on_answer_selected", [text])

	
func _on_answer_selected(text: String) -> void:
	emit_signal("answer_selected", text)
	for child in get_children():
		child.queue_free()
