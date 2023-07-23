extends TileMap


export var max_vine_speed: Vector2
export var deacceleration: Vector2
export var VINE_SCENE: PackedScene

var player: KinematicBody2D
var vines: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_replace_tiles_with_vines()


func _replace_tiles_with_vines() -> void:
	for tile_pos in get_used_cells():		
		if get_cellv(tile_pos) != INVALID_CELL:
			set_cellv(tile_pos, -1)
		
		new_vine(tile_pos)
		
		
func new_vine(tile_pos: Vector2) -> void:
	var vine = VINE_SCENE.instance()
	var vine_pos = map_to_world(tile_pos) * scale + global_position

	add_child(vine)
	vine.global_position = vine_pos
	
	vine.connect("body_entered", self, "_on_Vine_body_entered")
	vine.connect("body_exited", self, "_on_Vine_body_exited")
	vine.get_node("Sprite").frame = rng.randi_range(0, 1)


func _physics_process(delta):
	if vines:
		if abs(player.velocity.x) > max_vine_speed.x:
			var blend := pow(0.5, deacceleration.x * delta)
			player.velocity.x = lerp(abs(player.velocity.x), max_vine_speed.x, blend) * sign(player.velocity.x)
		if abs(player.velocity.y) > max_vine_speed.y:
			var blend := pow(0.5, deacceleration.y * delta)
			player.velocity.y = lerp(abs(player.velocity.y), max_vine_speed.y, blend) * sign(player.velocity.y)
			

func _on_Vine_body_entered(body):
	if body.is_in_group("player"):
		vines += 1
		player = body


func _on_Vine_body_exited(body):
	if body.is_in_group("player"):
		vines -= 1
		if !vines:
			player = null
