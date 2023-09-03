extends Node

# Singleton which stores references to other Nodes
signal room_changed
signal input_changed
signal jump_arrow_toggled(value)
signal faster_jump_charging_toggled(value)
signal level_changed(current_level)

var player_camera: Camera2D
var platforming_player: Player
var dialog_box: DialogBox
var camera_item: CameraItem
var speedrun_timer: CanvasLayer
var debug: CanvasLayer
var vision_circle: CanvasLayer
var cave_cutscene_played: bool = false
var yeti: Area2D

var deaths: int = 0

var current_level: String setget set_current_level
var current_room: Area2D

var aim_with_mouse_rock_climbing: bool = false

var room_pause: bool = false
export var room_pause_time: float = 0.2

var secrets: Array = []

var summit: bool = false

enum {
	UP
	RIGHT
	DOWN
	LEFT
}


func set_current_level(new_value: String) -> void:
	current_level = new_value
	MusicPlayer.play_song(new_value)
	emit_signal("level_changed", new_value)	


func change_room(room_node: LevelRoom, room_position: Vector2, room_size: Vector2) -> void:
	
	player_camera.current_room_center = room_position
	player_camera.current_room_size = room_size
	
	current_room = room_node
	
	room_pause = true
	yield(get_tree().create_timer(room_pause_time),"timeout")
	room_pause = false
	
	emit_signal("room_changed")
