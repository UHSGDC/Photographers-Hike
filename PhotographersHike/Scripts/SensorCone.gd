extends Node2D
class_name SensorCone






export var radius: int = 5

export var angle_width: int = 35 #degrees

export var angle_of_elevation: int = 0

export var arc_smoothness: int = 20

export var color: Color = Color.white


func _init():
	pass

func _physics_process(delta):
	
	draw_arc(position, radius, angle_of_elevation-(angle_width/2), angle_of_elevation+(angle_width/2), arc_smoothness, color)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func draw_circle_arc(center: Vector2, radius: int, width_angle, angle_of_elevation, direction, color: Color):
	var nbPoints = 32
	var pointsArc = PoolVector2Array()
	
	for i in range(nbPoints):
		pass
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
