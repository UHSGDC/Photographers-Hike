extends Node

# Singleton which stores references to other Nodes
signal room_changed
signal input_changed
signal jump_arrow_toggled(value)
signal faster_jump_charging_toggled(value)

var player_camera: Camera2D
var platforming_player: Player
var dialog_box: DialogBox
var camera_item: CameraItem
var speedrun_timer: CanvasLayer
var debug: CanvasLayer

var current_level: String
var current_room: Area2D

var aim_with_mouse_rock_climbing: bool = false

var level_text_dictionary: Dictionary = {
	"Base" : "Base Camp",
	"DenseForest" : "Dense Forest",
	"SparseForest" : "Sparse Forest",
	"Snowy" : "Snowy Tundra",
	"Summit" : "Summit"
}

var room_pause: bool = false
export var room_pause_time: float = 0.2


enum {
	UP
	RIGHT
	DOWN
	LEFT
}


func change_room(room_node: LevelRoom, room_position: Vector2, room_size: Vector2) -> void:
	
	player_camera.current_room_center = room_position
	player_camera.current_room_size = room_size
	
	current_room = room_node
	
	current_level = level_text_dictionary[current_room.get_parent().name]
	
	room_pause = true
	yield(get_tree().create_timer(room_pause_time),"timeout")
	room_pause = false
	
	emit_signal("room_changed")
