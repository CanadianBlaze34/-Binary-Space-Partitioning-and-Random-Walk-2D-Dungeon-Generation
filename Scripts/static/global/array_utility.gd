class_name ArrayUtility

static func union_single(array, element):
	# returns a copy of the Array, with the element added
	# if the element is not in the array
	var copied_array = array.duplicate()
	
	if not element in copied_array:
		copied_array.append(element)
	
	return copied_array

static func union(array, _array):
	# returns an Array, with all the elements in _array and
	# array with no duplicates
	
	var copied_array = array.duplicate()
	
	for index in _array.size():
		var element = _array[index]
		if not element in copied_array:
			copied_array.append(element)
	
	return copied_array

static func union_single_with(array, element):
	# adds the element to array if the element is not in array
	if not element in array:
		array.append(element)

static func union_with(array_to, array_from):
	# adds all the non-duplicated elements form array_from into array_to
	for index in array_from.size():
		var element = array_from[index]
		if not element in array_to:
				array_to.append(element)

static func duplicates(array) -> Array:
	
	var _duplicates : Array = []
	
	for i in array.size():
		var counter : int = array.count(array[i])
		if counter > 1 and not array[i] in _duplicates:
			_duplicates.append(array[i])
	
	return _duplicates

static func remove(array, elements):
	for element in elements:
		array.erase(element)

static func remove_new(array, elements):
	var new_array = array.duplicate()
	for element in elements:
		new_array.erase(element)
	return new_array

static func pick_random(array, random := RandomNumberGenerator.new()):
	return array[random.randi() % array.size()]

static func slice_random(array, elements : int, random := RandomNumberGenerator.new()):
	# returns a random selection of elements from the array
	var sliced = ArrayUtility.shuffle_new(array, random)
	sliced.resize(elements)
	return sliced

static func shuffle(array, random := RandomNumberGenerator.new()):
# https://godotengine.org/qa/66735/how-to-randomly-select-more-then-one-items-from-a-list
	var shuffled = []
	while array.size():
		var index = random.randi() % array.size()
		shuffled.append(array[index])
		array.remove_at(index)
	array.append_array(shuffled)

static func shuffle_new(array, random := RandomNumberGenerator.new()):
	var shuffled = array.duplicate()
	ArrayUtility.shuffle(shuffled, random)
	return shuffled
