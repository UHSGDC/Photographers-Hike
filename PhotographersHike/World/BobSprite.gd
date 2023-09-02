extends Sprite


var time: float = 0

func _process(delta: float) -> void:
	time += delta
	offset.y = sin(time * PI) * 4;
