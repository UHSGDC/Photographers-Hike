extends DeathZone

class_name Spike

enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}


func init(direction: int) -> void:
	match direction:
		Facing.UP:
			$Sprite.frame_coords.x = 0
			$Up.disabled = false
		Facing.DOWN:
			$Sprite.frame_coords.x = 1
			$Down.disabled = false
		Facing.LEFT:
			$Sprite.frame_coords.x = 2
			$Left.disabled = false
		Facing.RIGHT:
			$Sprite.frame_coords.x = 3
			$Right.disabled = false
			
