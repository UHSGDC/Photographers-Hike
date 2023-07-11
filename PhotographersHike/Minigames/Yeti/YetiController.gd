extends Node

export var yeti_scene: PackedScene

var yeti: Sprite


func _on_YetiController_body_entered(body: Node) -> void:
	if body.is_in_group("player") and !yeti:
		yeti = yeti_scene.instance()
		get_parent().add_child(yeti)
		yeti.global_position = $SpawnPosition.global_position
