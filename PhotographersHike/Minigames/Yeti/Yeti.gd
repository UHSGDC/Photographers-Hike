extends Area2D


export var fist_scene: PackedScene

export var active: bool = false

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

var player_invinciblity: bool = false


func _ready() -> void:
	Global.yeti = self
	$AnimationPlayer.play("Spawn")
	yield($AnimationPlayer, "animation_finished")
	call_deferred("_connect_respawn_signal")
	
func _connect_respawn_signal() -> void:
	Global.platforming_player.connect("respawn", self, "_on_Player_respawn")


func _process(delta: float) -> void:
	if active and !player_invinciblity:
		current_state = get_state()
		check_distance()
		if !punches:
			follow_player(delta)
		if is_near_player and punches < fist_amount and can_punch:
			punch()
			
	if player_invinciblity:
		if Global.platforming_player.x_input != 0 and Global.platforming_player.velocity.x != 0:
			player_invinciblity = false

			
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
			
			
func follow_player(delta: float) -> void:
	global_position = lerp(global_position, Global.platforming_player.global_position, 5 * delta)


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
	

func _on_Player_respawn() -> void:
	for child in get_children():
		if child is Area2D:
			child.queue_free()
	punches = 0
	can_punch = true
	global_position = Global.current_room.get_node("YetiSpawn").global_position
	player_invinciblity = true

