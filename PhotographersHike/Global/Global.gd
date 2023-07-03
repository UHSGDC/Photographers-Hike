extends Node

# Singleton which stores references to other Nodes

var player_camera: Camera2D
var platforming_player: Player
var dialog_box: DialogBox
var camera_item: CameraItem

var current_level: String
var current_room: Area2D

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
	
	current_level = current_room.get_parent().name
	
	room_pause = true
	yield(get_tree().create_timer(room_pause_time),"timeout")
	room_pause = false
	
	