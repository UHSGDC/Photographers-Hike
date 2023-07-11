extends Area2D

## right is 1 and left is -1
export var direction: int
export var strength: float

const air_multiplier: float = 1.5


var player = Global.platforming_player

export var wind_particles_scene: PackedScene
var wind_particles: CPUParticles2D

var in_wind: bool = false

func _ready() -> void:
	call_deferred("_set_player_reference")


func _set_player_reference() -> void:
	player = Global.platforming_player


func _physics_process(delta: float) -> void:

	if !in_wind:
		return
	
	if player.is_on_floor() && abs(player.velocity.x) >= 10:
		player.velocity.x += strength * delta * direction
	if !player.is_on_floor():
		player.velocity.x += strength * delta * direction * air_multiplier


func _on_WindZone_area_entered(area: Area2D) -> void:
	if area.get_parent() == player: # Create a better check for player
		wind_particles = wind_particles_scene.instance()
		add_child(wind_particles)
		wind_particles.global_position = global_position
		wind_particles.global_position.x += - wind_particles.x_offset * direction
		
		wind_particles.direction.x = direction
		
		wind_particles.speed_scale = strength / 500
		
		yield(get_tree().create_timer(0.2),"timeout")
		in_wind = true


func _on_WindZone_area_exited(area: Area2D) -> void:
	in_wind = false
	yield(get_tree().create_timer(0.1),"timeout")
	wind_particles.queue_free()
