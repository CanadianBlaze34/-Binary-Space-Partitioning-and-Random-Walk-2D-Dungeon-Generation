class_name ProceduralGenerationAlgorithms

static func simple_random_walk(start_position : Vector2i, steps : int, 
		random := RandomNumberGenerator.new()) -> Array[Vector2i]:
	
	# returns an array of unique/non-repeating/non-duplicated positions
	
	var path : Array[Vector2i] = []
	
	path.append(start_position)
	var previous_position : Vector2i = start_position
	
	for i in steps:
		var new_position : Vector2i = previous_position +\
			Direction2D.random_cardinal_direction(random)
		ArrayUtility.union_single_with(path, new_position)
		previous_position = new_position
	
	return path

static func random_walk_corridor(start_position : Vector2i,
		corridor_length : int, random := RandomNumberGenerator.new()
		) -> Array[Vector2i]:
	
	var corridor : Array[Vector2i] = []
	var direction : Vector2i = Direction2D.random_cardinal_direction(random)
	var current_position : Vector2i = start_position
	corridor.append(current_position)
	
	for index in corridor_length:
		current_position += direction
		corridor.append(current_position)
	
	return corridor

static func random_walk_corridor_with_size(start_position : Vector2i,
		length : int, size : int, random := RandomNumberGenerator.new()
		) -> Array[Vector2i]:
	
	# practically making a rectangle with the length in a random direction
	# the length can be the width or the height of the rectangle but it should
	# be in a random direction
	
	var corridor : Array[Vector2i] = []
	var direction : Vector2i = Direction2D.random_cardinal_direction(random)
	#var current_position : Vector2i = start_position
	
	# possible out comes should be (0, 1), (0, -1), (-1, 0) or (1, 0)
	var size_direction := Vector2i(Vector2(direction).rotated(1.5708).round())
	
	var _size : Vector2i = size_direction * size + direction * length
	var _size_direction : Vector2i = size_direction + direction
	
	#corridor.append(current_position)
	
	var height : int = _size.y
	var width : int = _size.x
	
#	var size_centered_offset : Vector2i = (size_direction * size) / 2
	# don't want a size of 2 to have a centered offset
	var size_centered_offset : Vector2i = (size_direction * (size - 1)) / 2
	
	for y in abs(height): 
		for x in abs(width):
			corridor.append(start_position + Vector2i(x, y) * _size_direction - size_centered_offset)
	
	return corridor

static func binary_space_partitioning(space_to_split : Rect2i, min_width : int,
		min_height : int, random := RandomNumberGenerator.new()
		) -> Array[Rect2i]:
	
	var rooms_queue : Array[Rect2i] = []
	var rooms_list : Array[Rect2i] = []
	# C# Queue.Enqueue()
	rooms_queue.push_back(space_to_split)
	
#	print("-------------------")
	
	while rooms_queue.size():
		
		var room : Rect2i = rooms_queue.pop_front()
		# is big enough to split
		if room.size.y >= min_height and room.size.x >= min_width:
			# randomlly split the room vertically or horizontally
			var coin_flip : float = random.randf()
			if coin_flip < 0.5:
				# horizontally
				# can split into more than 2 rooms
				if room.size.y >= min_height * 2:
					_split_horizontally(min_height, rooms_queue, room, random)
				elif room.size.x >= min_width * 2:
					_split_vertically(min_width, rooms_queue, room, random)
				else:
					rooms_list.append(room)
				# vertically
			else:
				# can split into more than 2 rooms
				if room.size.x >= min_width * 2:
					_split_vertically(min_width, rooms_queue, room, random)
				elif room.size.y >= min_height * 2:
					_split_horizontally(min_height, rooms_queue, room, random)
				else:
					rooms_list.append(room)
		
		# can split into more than 2 rooms
#		if room.size.y >= min_height * 2 or room.size.x >= min_width * 2:
#			if random.randf() < 0.5:
#				if room.size.y >= min_height * 2:
#					_split_horizontally(min_height, rooms_queue, room)
#				elif room.size.x >= min_width * 2:
#					_split_vertically(min_width, rooms_queue, room)
#			else:
#				if room.size.x >= min_width * 2:
#					_split_vertically(min_width, rooms_queue, room)
#				elif room.size.y >= min_height * 2:
#					_split_horizontally(min_height, rooms_queue, room)
#		elif room.size.y >= min_height and room.size.x >= min_width:
#			print("append")
#			rooms_list.append(room)
	
	return rooms_list

static func _split_vertically(min_width : int, rooms_queue : Array[Rect2i],
		room : Rect2i, random := RandomNumberGenerator.new()) -> void:
#	print("vertically")

	var x_split : int = random.randi_range(1, room.size.x - 1)
#	var x_split : int = random.randi_range(min_width, room.size.x - min_width - 1)
#	var x_split : int = random.randi_range(min_width + 1, room.size.x - min_width - 1);
		
	var room_1 := Rect2i(room.position, Vector2i(x_split, room.size.y)) 
	var room_2 := Rect2i(Vector2i(room.position.x + x_split, room.position.y),
		Vector2i(room.size.x - x_split, room.size.y))
	rooms_queue.push_back(room_1)
	rooms_queue.push_back(room_2)

static func _split_horizontally(min_height : int, rooms_queue : Array[Rect2i],
		room : Rect2i, random := RandomNumberGenerator.new()) -> void:
#	print("horizontally")

	var y_split : int = random.randi_range(1, room.size.y - 1)
#	var y_split : int = random.randi_range(min_height, room.size.y - min_height - 1)
#	var y_split : int = random.randi_range(min_height + 1, room.size.y - min_height - 1)
	
	var room_1 := Rect2i(room.position, Vector2i(room.size.x, y_split)) 
	var room_2 := Rect2i(Vector2i(room.position.x, room.position.y + y_split),
		Vector2i(room.size.x, room.size.y - y_split))
	rooms_queue.push_back(room_1)
	rooms_queue.push_back(room_2)



