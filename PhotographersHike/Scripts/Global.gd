extends Node

# Singleton which stores references to other Nodes

onready var player_camera = get_tree().current_scene.get_node("PlayerCamera")
onready var platforming_player = get_tree().current_scene.get_node("PlatformingPlayer")

