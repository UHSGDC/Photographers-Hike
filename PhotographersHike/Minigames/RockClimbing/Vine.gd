extends Area2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	$Sprite.frame = rng.randi_range(0, 1)

