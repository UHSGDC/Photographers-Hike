extends Sprite


export var fist_scene: PackedScene

var active: bool = false

var can_punch: bool = false


func _ready() -> void:
	active = true


func _process(delta: float) -> void:
	if active:
		follow_player()
		if can_punch:
			punch()
			
			
func follow_player() -> void:
	print("following player")


func punch() -> void:
	print("punching player")
