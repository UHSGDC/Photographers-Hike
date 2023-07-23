extends Area2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var last_jump_path: PoolVector2Array
var last_jump_strength: float

func _ready() -> void:
	rng.randomize()      
	$Sprite.frame = rng.randi_range(0, 3)
