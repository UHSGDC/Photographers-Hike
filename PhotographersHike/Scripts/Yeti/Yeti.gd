extends Sprite


export var fist_scene: PackedScene

var active: bool = false

var is_near_player: bool = false
var can_punch: bool = true
var punches: int = 0

export var fist_distance: float
export var punch_cooldown: float
export var fist_amount: int


func _ready() -> void:
	active = true


func _process(delta: float) -> void:
	if active:
		check_distance()
		if !punches:
			follow_player()
		if is_near_player and punches < fist_amount and can_punch:
			punch()
			
			
func follow_player() -> void:
	position = lerp(position, Global.platforming_player.position, 0.05)


func check_distance() -> void:
	if position.distance_to(Global.platforming_player.position) < fist_distance:
		is_near_player = true
	else:
		is_near_player = false


func punch() -> void:
	var fist := fist_scene.instance()
	add_child(fist)
	fist.get_node("Sprite").scale = Vector2.ZERO
	fist.punch(self)
