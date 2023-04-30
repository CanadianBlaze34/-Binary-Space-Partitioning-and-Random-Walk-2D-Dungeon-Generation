extends SimpleRandomWalkDungeonGenerator

class_name RoomFirstDungeonGenerator

# private
@export var _min_room_width : int = 4
@export var _min_room_height : int = 4

@export var _dungeon_width : int = 20
@export var _dungeon_height : int = 20

@export_range(0, 10) var _room_offset = 1
@export var _simple_random_walk_rooms : bool = false

@export var _corridor_randomize : RandomProperties

func _run_procedural_generation() -> void:
	
	var room_random : RandomNumberGenerator = _dungeon_randomize.create_random_number_generator()
	var corridor_random : RandomNumberGenerator = _corridor_randomize.create_random_number_generator()
	_create_rooms(room_random, corridor_random)

func _create_rooms(room_random := RandomNumberGenerator.new(), 
		corridor_random := RandomNumberGenerator.new()) -> void:
	
	# rooms
	var rooms_list : Array[Rect2i] = ProceduralGenerationAlgorithms.binary_space_partitioning(
		Rect2i(_start_position, Vector2i(_dungeon_width, _dungeon_height)),
		_min_room_width, _min_room_height, room_random)
	
	var floor_positions : Array[Vector2i] = []
	
	if _simple_random_walk_rooms:
		floor_positions = _craete_rooms_randomly(rooms_list, room_random)
	else:
		floor_positions = _create_simple_rooms(rooms_list)
	
	# corridors
	var room_centers : Array[Vector2i] = []
	for room in rooms_list:
		room_centers.append(room.get_center())
	
	var corridors : Array[Vector2i] = _connect_corridors(room_centers, corridor_random)
	ArrayUtility.union_with(floor_positions, corridors)
	
	_tile_map_visualizer.paint_floor_tiles(floor_positions)
	WallGenerator.create_walls(floor_positions, _tile_map_visualizer)

func _craete_rooms_randomly(rooms_list : Array[Rect2i], room_random := RandomNumberGenerator.new()) -> Array[Vector2i]:
	
	var floor_positions : Array[Vector2i] = []
	
	for i in rooms_list.size():
		
		var room_bounds : Rect2i = rooms_list[i]
		var room_floor : Array[Vector2i] = _run_random_walk(room_bounds.get_center(), _random_dungeon.iterations,
			_random_dungeon.steps, _random_dungeon.start_randomly_each_iteration, room_random)
		
		# adding Vector2i.ONE so the edge of the offset is included in the has_point method
		var room_floor_offset := Rect2i(room_bounds.position + _room_offset * Vector2i.ONE, 
			room_bounds.size - _room_offset * Vector2i.ONE + Vector2i.ONE)
		
		for _position in room_floor:
			if room_floor_offset.has_point(_position):
				ArrayUtility.union_single_with(floor_positions, _position)
#				floor_positions.append(_position)
	
	return floor_positions

func _connect_corridors(room_centers : Array[Vector2i], 
		corridor_random := RandomNumberGenerator.new()) -> Array[Vector2i]:
	var corridors : Array[Vector2i] = []
	var current_room_center : Vector2i = ArrayUtility.pick_random(room_centers, corridor_random)
	room_centers.erase(current_room_center)
	
	while room_centers.size():
		var closest : Vector2i = _find_closest_point_to(current_room_center, room_centers)
		room_centers.erase(closest)
		var new_corridor : Array[Vector2i] = _create_corridor(current_room_center, closest)
		current_room_center = closest
		ArrayUtility.union_with(corridors, new_corridor)
	
	return corridors

func _find_closest_point_to(current_room_center: Vector2i,
		room_centers : Array[Vector2i]) -> Vector2i:
	
	var closest := Vector2i.ZERO
	var distance : float = INF
	
	for _position in room_centers:
		var current_distance : float = Vector2(_position).distance_squared_to(current_room_center)
		if current_distance < distance:
			distance = current_distance
			closest = _position
	
	return closest

func _create_corridor(current_room_center: Vector2i, destination: Vector2i
		) -> Array[Vector2i]:
	
	var corridor : Array[Vector2i] = []
	var _position : Vector2i = current_room_center
	corridor.append(_position)
	
	# y direction
	while _position.y != destination.y: 
		if destination.y > _position.y:
			_position += -Vector2i.UP # up is (0, -1), needs to be reversed
		elif destination.y < _position.y:
			_position += -Vector2i.DOWN # down is (0, -1), needs to be reversed
		corridor.append(_position)
	
	# x direction
	while _position.x != destination.x: 
		if destination.x > _position.x:
			_position += Vector2i.RIGHT
		elif destination.x < _position.x:
			_position += Vector2i.LEFT
		
		corridor.append(_position)
	
	return corridor

func _create_simple_rooms(rooms_list : Array[Rect2i]) -> Array[Vector2i]:
	var floor_positions : Array[Vector2i] = []
	for room in rooms_list:
		for col in range(_room_offset, room.size.x - _room_offset):
			for row in range(_room_offset, room.size.y - _room_offset):
				var _position : Vector2i = room.position + Vector2i(col, row)
				floor_positions.append(_position)
				# make room area 2d
				# make room collision
	return floor_positions

func _on_generate_rooms_first_pressed() -> void:
	generate_dungeon()

