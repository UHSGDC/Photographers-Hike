extends Area2D


export(String, "Base Camp", "Dense Forest", "Sparse Forest", "Snowy Tundra", "Summit") var level


func _ready() -> void:
	$CanvasLayer/Popup.text = level


func _on_LevelPopup_body_entered(body: Node) -> void:
	if body.is_in_group("player") and Global.current_level != level:
		$CanvasLayer/Popup.display_warning()
		Global.current_level = level
