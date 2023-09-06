extends TileMap

tool


export var level_tilemap_path: NodePath
var level_tilemap: TileMap

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

export var generate_tilemap: bool setget set_generate_tilemap
export var clear_tilemap: bool setget set_clear_tilemap
export var lock_generation: bool


enum Foreground {
	GREEN_DRIP,
	GREEN_PLANT,
	SNOW_ROCK,
	SNOW_DRIP,
	STONE_ROCK,
	DIRT_ROCK,
	STONE_DRIP
}

enum Level {
	STONE = 7,
	DIRT = 8,
	SNOW = 10,
	LEAF = 11,
	COBBLESTONE = 12,
	PLATFORM = 13,
}

func set_clear_tilemap(new_value: bool) -> void:
	if lock_generation:
		return
	clear_tilemap = false
	clear()


func set_generate_tilemap(new_value: bool) -> void:
	generate_tilemap = false
	if lock_generation:
		return
	level_tilemap = get_node(level_tilemap_path)
	_generate_foreground_tiles()


func _generate_foreground_tiles() -> void:
	clear()
	for tile_pos in level_tilemap.get_used_cells():
		var tile_id = level_tilemap.get_cellv(tile_pos)		
		match tile_id:
			Level.STONE:
				_set_tile_above(tile_pos, Foreground.STONE_ROCK, 0.3)
				_set_tile_above(tile_pos, Foreground.GREEN_PLANT, 0.1)
				_set_tile_on(tile_pos, Foreground.GREEN_DRIP, 0.1)
				_set_tile_below(tile_pos, Foreground.STONE_DRIP, 0.2)
			Level.DIRT:
				if level_tilemap.get_cell_autotile_coord(tile_pos.x, tile_pos.y).y < 10:
					_set_tile_above(tile_pos, Foreground.DIRT_ROCK, 0.2)
					_set_tile_above(tile_pos, Foreground.GREEN_PLANT, 0.1)
					_set_tile_on(tile_pos, Foreground.GREEN_DRIP, 0.1)
			Level.SNOW:
				_set_tile_above(tile_pos, Foreground.STONE_ROCK, 0.2)
				_set_tile_above(tile_pos, Foreground.SNOW_ROCK, 0.5)
				_set_tile_on(tile_pos, Foreground.SNOW_DRIP, 0.4)
				_set_tile_below(tile_pos, Foreground.SNOW_DRIP, 0.3)
			Level.LEAF:
				if level_tilemap.get_cell_autotile_coord(tile_pos.x, tile_pos.y).y < 10:
					_set_tile_above(tile_pos, Foreground.GREEN_PLANT, 0.5)
					_set_tile_on(tile_pos, Foreground.GREEN_DRIP, 0.5)
					_set_tile_below(tile_pos, Foreground.GREEN_DRIP, 0.1)		
			
			
func _set_tile_above(tile_pos: Vector2, tile_id: int, probability: float) -> void:
	if level_tilemap.get_cellv(tile_pos + Vector2.UP) == -1:
		if rng.randf() > probability:
			return
			
		set_cellv(tile_pos + Vector2.UP, _get_random_tile_id(tile_id))


func _set_tile_on(tile_pos: Vector2, tile_id: int, probability: float) -> void:
	if level_tilemap.get_cellv(tile_pos + Vector2.UP) == -1:
		if rng.randf() > probability:
			return
		
		set_cellv(tile_pos, _get_random_tile_id(tile_id))


func _set_tile_below(tile_pos: Vector2, tile_id: int, probability: float) -> void:
	if level_tilemap.get_cellv(tile_pos + Vector2.DOWN) == -1:
		if rng.randf() > probability:
			return
		
		set_cellv(tile_pos + Vector2.DOWN, _get_random_tile_id(tile_id))

func _get_random_tile_id(tile_id) -> int:
	return tile_id + rng.randi_range(0, 3) * 7
