extends Area2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	$Sprite.frame = rng.randi_range(0, 3)
