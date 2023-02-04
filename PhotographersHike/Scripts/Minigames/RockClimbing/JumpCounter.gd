extends CanvasLayer


func update_jumps(jumps: int) -> void:
	$Label.text = "Jumps Left: " + String(jumps)
