class_name Direction2D

const cardinal_directions : Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT
]

const orthogonal_directions : Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT, 
	Vector2i.ONE, 
	-Vector2i.ONE, 
	Vector2i( 1, -1), 
	Vector2i(-1,  1), 
]

static func random_cardinal_direction(random := RandomNumberGenerator.new()) -> Vector2i:
	return ArrayUtility.pick_random(cardinal_directions, random)

static func random_orthogonal_direction(random := RandomNumberGenerator.new()) -> Vector2i:
	return ArrayUtility.pick_random(orthogonal_directions, random)
