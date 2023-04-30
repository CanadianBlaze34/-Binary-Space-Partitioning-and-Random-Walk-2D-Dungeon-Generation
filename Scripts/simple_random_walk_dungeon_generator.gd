extends DungeonGenerator

class_name SimpleRandomWalkDungeonGenerator

# protected
@export var _random_dungeon : SimpleRandomWalkResource
@export var _dungeon_randomize : RandomProperties

func _run_procedural_generation() -> void:
	
	var random : RandomNumberGenerator = _dungeon_randomize.create_random_number_generator()
	
	var floor_positions : Array[Vector2i] = SimpleRandomWalkDungeonGenerator._run_random_walk(_start_position, 
		_random_dungeon.iterations, _random_dungeon.steps,
		_random_dungeon.start_randomly_each_iteration, random)
	
#	for position in floor_positions:
#		print(position)
#	print("%d positions." % [floor_positions.size()])
	
	_tile_map_visualizer.clear()
	_tile_map_visualizer.paint_floor_tiles(floor_positions)
	
	WallGenerator.create_walls(floor_positions, _tile_map_visualizer)

static func _run_random_walk(start_position : Vector2i, iterations : int,
		steps : int, start_randomly_each_iteration: bool,
		random := RandomNumberGenerator.new()) -> Array[Vector2i]:
	
	var current_position : Vector2i = start_position
	var floor_positions : Array[Vector2i] = []
	
	# Generate the path without duplicated positions
	for i in iterations:
		var path : Array[Vector2i] = ProceduralGenerationAlgorithms.simple_random_walk(current_position, steps, random)
		
		ArrayUtility.union_with(floor_positions, path)
		
		if start_randomly_each_iteration:
			current_position = ArrayUtility.pick_random(floor_positions, random)
	
	return floor_positions

func _on_button_pressed() -> void:
	generate_dungeon()



