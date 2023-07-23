extends CanvasLayer

export var position_path_array: Array

var position_array: Array

func _ready():
	Global.debug = self
	for item in position_path_array:
		position_array.append(get_node(item))


func _on_AreaSwitcher_item_selected(index: int) -> void:
	Global.platforming_player.global_position = position_array[index].global_position
