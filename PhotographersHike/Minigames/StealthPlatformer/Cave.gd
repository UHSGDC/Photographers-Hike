extends Node2D


var cougars: Array
var cougar_positions: PoolVector2Array

var in_cave: bool = false


func _ready() -> void:
	Global.connect("room_changed", self, "Global_room_changed")
	call_deferred("connect_player_respawn")
	
	
	for child in get_children():
		if child.is_in_group("cougar"):
			cougars.append(child)
			cougar_positions.append(child.global_position)
			child.navigation_node = $Navigation2D


func connect_player_respawn() -> void:
	Global.platforming_player.connect("respawn", self, "Global_room_changed")
	

func Global_room_changed() -> void:
	if !in_cave:
		return
	for cougar_id in cougars.size():
		cougars[cougar_id].global_position = cougar_positions[cougar_id]
		cougars[cougar_id].reset_state()
		cougars[cougar_id].current_footsteps = 0


func _on_Cave_body_entered(body: Node):
	if body.is_in_group("player"):
		in_cave = true


func _on_Cave_body_exited(body: Node):
	if body.is_in_group("player"):
		in_cave = false
