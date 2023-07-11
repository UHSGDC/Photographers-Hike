extends Sprite


export var fist_scene: PackedScene

var active: bool = false

var is_near_player: bool = false
var can_punch: bool = true
var punches: int = 0

export var fist_distance: float
export var punch_cooldown: float
export var fist_amount: int


enum STATES {
	IDLE
	FOLLOWING
	CHARGING
	CHARGINGPUNCHING
	PUNCHING
}

var current_state: int = STATES.IDLE


func _ready() -> void:
	$AnimationPlayer.play("Spawn")
	yield($AnimationPlayer, "animation_finished")
	
	active = true


func _process(delta: float) -> void:
	if active:
		current_state = get_state()
		check_distance()
		if !punches:
			follow_player()
		if is_near_player and punches < fist_amount and can_punch:
			punch()

			
func get_state() -> int:
	if !punches:
		return STATES.FOLLOWING
	elif punches > 1:
		return STATES.CHARGINGPUNCHING
	elif punches == 1 and can_punch:
		return STATES.PUNCHING
	elif punches == 1 and !can_punch:
		return STATES.CHARGING
	else:
		return STATES.IDLE
			
			
func follow_player() -> void:
	global_position = lerp(global_position, Global.platforming_player.global_position, 0.05)


func check_distance() -> void:
	if global_position.distance_to(Global.platforming_player.global_position) < fist_distance:
		is_near_player = true
	else:
		is_near_player = false


func punch() -> void:
	var fist := fist_scene.instance()
	add_child(fist)
	fist.get_node("Sprite").scale = Vector2.ZERO
	fist.punch(self)
