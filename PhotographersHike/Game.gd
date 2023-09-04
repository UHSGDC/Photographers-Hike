extends Node

export var world_scene: PackedScene

onready var world: Node2D = $World


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart_game()


func restart_game() -> void:
	world.queue_free()
	world = world_scene.instance()
	add_child(world)
	call_deferred("reset_Global")
	
	
func reset_Global() -> void:
	Global.secrets = []
	Global.deaths = 0
	Global.cave_cutscene_played = false
	Global.settings_menu.update_settings()
