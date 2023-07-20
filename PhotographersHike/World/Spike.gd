extends DeathZone

class_name Spike

enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func init(direction: int) -> void:
	rng.randomize()
	
	match direction:
		Facing.UP:
			$Sprite.frame_coords.y = 0
			$Up.disabled = false
		Facing.DOWN:
			$Sprite.frame_coords.y = 3
			$Down.disabled = false
		Facing.LEFT:
			$Sprite.frame_coords.y = 1
			$Left.disabled = false
		Facing.RIGHT:
			$Sprite.frame_coords.y = 2
			$Right.disabled = false
			
	$Sprite.frame_coords.x = rng.randi_range(0, 2)
