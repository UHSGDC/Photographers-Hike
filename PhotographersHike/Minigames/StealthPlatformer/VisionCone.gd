extends Area2D


export var length: float
export var collision_length: float
export var angle: float
export var collision_angle: float 
onready var angle_rad: float = deg2rad(angle)
onready var collision_angle_rad: float = deg2rad(collision_angle)
onready var angle_slice: float = angle_rad / precision
onready var collision_angle_slice: float = collision_angle_rad / precision

export var precision: float = 20

var facing_right = false

var cast_vector: Vector2


func _physics_process(delta: float) -> void:
	
	
	if facing_right:
		cast_vector = Vector2.RIGHT
	else:
		cast_vector = Vector2.LEFT
	


func _on_PolygonTimer_timeout():
	var points: PoolVector2Array = [Vector2.ZERO]
	var collision_points: PoolVector2Array = [Vector2.ZERO]
	
	for i in precision + 1:
		var current_angle = i * angle_slice - angle_rad / 2
		$TileCast.cast_to = cast_vector.rotated(current_angle) * length
		$TileCast.force_raycast_update()
		if $TileCast.is_colliding():
			points.append($TileCast.get_collision_point() - $TileCast.global_position)
		else:
			points.append($TileCast.cast_to)
		
		current_angle = i * collision_angle_slice - collision_angle_rad / 2
		$TileCast.cast_to = cast_vector.rotated(current_angle) * collision_length
		$TileCast.force_raycast_update()
		if $TileCast.is_colliding():
			collision_points.append($TileCast.get_collision_point() - $TileCast.global_position)
		else:
			collision_points.append($TileCast.cast_to)
			
	$Polygon2D.polygon = points
	$CollisionShape2D.polygon = collision_points
