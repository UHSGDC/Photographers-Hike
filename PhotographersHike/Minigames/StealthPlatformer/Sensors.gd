extends Node


onready var _character = get_parent()

onready var _blocker_detection_direction = $LowerRay.cast_to.x
onready var _edge_detection_position = $EdgeDetectionRay.position.x


var _sensors_flipped = false

func _ready():
	$UpperRay.position.y = -_character.jump_height + 6


func _process(_delta):
	if _sensors_flipped == _character.facing_right:
		return

	_sensors_flipped = _character.facing_right

	if _sensors_flipped:
		_turn_right()
	else:
		_turn_left()


func _turn_right():
	$LowerRay.cast_to.x = _blocker_detection_direction * -1
	$LowerRay.position.x = _edge_detection_position * -1
	$UpperRay.cast_to.x = _blocker_detection_direction * -1
	$UpperRay.position.x = _edge_detection_position * -1
	$EdgeDetectionRay.position.x = _edge_detection_position * -1


func _turn_left():
	$LowerRay.cast_to.x = _blocker_detection_direction
	$LowerRay.position.x = _edge_detection_position
	$UpperRay.cast_to.x = _blocker_detection_direction
	$UpperRay.position.x = _edge_detection_position
	$EdgeDetectionRay.position.x = _edge_detection_position


func is_facing_jumpable_blocker():
	return $LowerRay.is_colliding() and not $UpperRay.is_colliding()


func is_facing_impossible_blocker():
	return $LowerRay.is_colliding() and $UpperRay.is_colliding()


func is_facing_edge():
		return not $EdgeDetectionRay.is_colliding()

