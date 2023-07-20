extends TileMap

export var SPIKE_SCENE: PackedScene

const spikes_array: PoolIntArray = PoolIntArray([14, 15, 16, 17])

func _ready():
	yield(get_tree(), "idle_frame")
	_replace_tiles_with_spikes()

func _replace_tiles_with_spikes():
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if spikes_array.has(tile_id):	
			
			var direction: int
			match tile_id:
				14:
					direction = Spike.Facing.UP
				15:
					direction = Spike.Facing.LEFT
				16:
					direction = Spike.Facing.DOWN
				17:
					direction = Spike.Facing.RIGHT
			
			_replace_tile_with_spike(tile_pos, direction)
						

func _replace_tile_with_spike(tile_pos: Vector2, direction: int):
	# Clear the cell in TileMap
	if get_cellv(tile_pos) != INVALID_CELL:
		set_cellv(tile_pos, -1)
	
	# Spawn the object
	var spike: Spike = SPIKE_SCENE.instance()
	var spike_pos = map_to_world(tile_pos) * scale + global_position

	get_parent().add_child(spike)
	spike.global_position = spike_pos
	spike.init(direction)
		
	
