class_name WallGenerator

static func create_walls(floor_positions : Array[Vector2i],
		tile_map_visualizer : TileMapVisualizer) -> void:
			
	var basic_wall_positions : Array[Vector2i] = find_walls_in_direction(floor_positions,
#			Direction2D.cardinal_directions)
			Direction2D.orthogonal_directions)
	
	tile_map_visualizer.paint_wall_tiles(basic_wall_positions)
	

static func find_walls_in_direction(floor_positions: Array[Vector2i],
		directions : Array[Vector2i]) -> Array[Vector2i]:
	
	var wall_positions : Array[Vector2i] = []
	
	for _position in floor_positions:
		for direction in directions:
			var neighbour_position = _position + direction
			if not neighbour_position in floor_positions:
				wall_positions.append(neighbour_position)
	
	return wall_positions



