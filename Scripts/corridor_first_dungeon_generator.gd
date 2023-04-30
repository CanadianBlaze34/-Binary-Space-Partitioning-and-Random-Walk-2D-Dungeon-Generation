extends SimpleRandomWalkDungeonGenerator

class_name CorridorFirstDungeonGenerator

# private
@export var _corridor_length : int = 14
@export var _corridor_count : int = 5
@export_range(0.1, 1.0) var _room_percent : float = 0.8

# public
@export var _corridor_randomize : RandomProperties

func _run_procedural_generation() -> void:
	
	var dungeon_random : RandomNumberGenerator = _dungeon_randomize.create_random_number_generator()
	var corridor_random : RandomNumberGenerator = _corridor_randomize.create_random_number_generator()
	
	_corridor_first_generation(dungeon_random, corridor_random)

func _corridor_first_generation(dungeon_random := RandomNumberGenerator.new(),
		corridor_random := RandomNumberGenerator.new()) -> void:
	
	# corridors' floors
	var floor_positions : Array[Vector2i] = []
	var potential_room_positions : Array[Vector2i] = []
	_create_corridors(floor_positions, potential_room_positions, corridor_random)
	
	# rooms' floors
	var dead_ends : Array[Vector2i] = _find_all_dead_ends(floor_positions)
	var room_floor_positions: Array[Vector2i] = _create_rooms(potential_room_positions, dead_ends, dungeon_random)
	ArrayUtility.union_with(floor_positions, room_floor_positions)
	
	# set the tilemp cells
	_tile_map_visualizer.paint_floor_tiles(floor_positions)
	WallGenerator.create_walls(floor_positions, _tile_map_visualizer)

func _create_corridors(floor_positions: Array[Vector2i], 
		potential_room_positions : Array[Vector2i], 
		corridor_random := RandomNumberGenerator.new()) -> void:
	
	var current_position : Vector2i = _start_position
	potential_room_positions.append(current_position)
	
#	var corridor_size : int = 1
	
	for i in _corridor_count:
		var corridor: Array[Vector2i] = ProceduralGenerationAlgorithms.random_walk_corridor(current_position, _corridor_length, corridor_random)
		
#		var corridor: Array[Vector2i] = ProceduralGenerationAlgorithms.\
#			random_walk_corridor_with_size(current_position, _corridor_length, corridor_size, corridor_random)
		
		current_position = corridor[-1]
		ArrayUtility.union_single_with(potential_room_positions, current_position)
		ArrayUtility.union_with(floor_positions, corridor)

func _find_all_dead_ends(floor_positions: Array[Vector2i]) -> Array[Vector2i]:
	
	var dead_ends : Array[Vector2i] = []
	for _position in floor_positions:
		
		var neighbours : int = 0
		for direction in Direction2D.cardinal_directions:
			if (_position + direction) in floor_positions:
				neighbours += 1
		
		if neighbours == 1:
			dead_ends.append(_position)
	
	return dead_ends

func _create_rooms(potential_room_positions: Array[Vector2i],
		dead_ends: Array[Vector2i],
		dungeon_random := RandomNumberGenerator.new()) -> Array[Vector2i]:
	
	# returns all the rooms' floor positions
	
	var room_positions : Array[Vector2i] = []
	var room_count : int = roundi(potential_room_positions.size() * _room_percent) - dead_ends.size()
	room_count = max(0, room_count)
	
	var _potential_room_positions: Array[Vector2i] =\
		ArrayUtility.remove_new(potential_room_positions, dead_ends)
	
	var rooms : Array[Vector2i] = ArrayUtility.slice_random(
		_potential_room_positions, room_count, dungeon_random)
	rooms.append_array(dead_ends)
	
	for _room_position in rooms:
		
		var floor_positions : Array[Vector2i] = SimpleRandomWalkDungeonGenerator._run_random_walk(
			_room_position, _random_dungeon.iterations, _random_dungeon.steps,
			_random_dungeon.start_randomly_each_iteration, dungeon_random)
		
		# Generate room area
		# Generate room area collision
		
		ArrayUtility.union_with(room_positions, floor_positions)
	
	return room_positions

func _on_generate_corridor_pressed() -> void:
	generate_dungeon()
