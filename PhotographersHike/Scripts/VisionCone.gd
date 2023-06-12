extends Area2D
class_name VisionCone



export var VISION_RANGE = 1000
export var VISION_CONE = PI * 0.25  #45 * PI / 180



export(Color, RGBA) var color = Color(1, 1, 0, 0.25)



func _ready():
	update_vision_zone()
	print(position)
	

func _process(delta):
	update_vision_zone()
	update()
	#draw_polygon($CollisionPolygon2D.polygon, [color])
	
func update_vision_zone():
	var nb_points = 30
	var points_arc = PoolVector2Array()
	points_arc.push_back(Vector2(0, 0))
	
	#check for collisions
	var space_state = get_world_2d().direct_space_state
	for _i in range(nb_points+1):
		var angle_point = -VISION_CONE
		var point = Vector2(cos(angle_point), sin(angle_point)) * VISION_RANGE
		#check to see if this point's LOS is obstructed by an obstacle using a raycast
		var colliderRay = space_state.intersect_ray(global_position, global_position+point.rotated(global_rotation), [self], 2)
		if colliderRay:
			point = (colliderRay.position-global_position).rotated(-global_rotation)
		points_arc.push_back(point)
	#prints("points_arc is PoolVector2Array", points_arc is PoolVector2Array)
	
	
	
	$CollisionPolygon2D.polygon = points_arc #$LOSPolygon
	
func _draw():
	draw_colored_polygon($CollisionPolygon2D.polygon, color) #$LOSPolygon.polygon
	
	
