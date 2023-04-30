extends Resource

class_name RandomProperties

# random seed, public
@export var randomize_ : bool = true
@export var seed_ : String = "34715993697983876"

static func static_create_random_number_generator(_randomize : bool, _seed : String = "34715993697983876") -> RandomNumberGenerator:
	var random := RandomNumberGenerator.new()
	
	if not _randomize:
#		if seed_.is_empty():
#			seed_ = str(random.seed)
		if _seed.is_valid_int():
			random.seed = _seed.to_int()
		elif _seed.is_valid_float():
			random.seed = int(_seed.to_float())
		elif _seed.is_valid_hex_number():
			random.seed = _seed.hex_to_int()
		else: # is_string
			random.seed = hash(_seed)
#	else:
#		seed_ = str(random.seed)
	
	return random

func create_random_number_generator() -> RandomNumberGenerator:
	return RandomProperties.static_create_random_number_generator(randomize_, seed_)
