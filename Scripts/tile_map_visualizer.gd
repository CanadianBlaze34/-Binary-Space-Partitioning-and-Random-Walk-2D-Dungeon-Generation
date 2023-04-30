extends TileMap

class_name TileMapVisualizer

## floor requirements
@export var _floor_tile : TileBase = preload("res://Resources/TileBase/floor.tres")
@export var _wall_tile : TileBase = preload("res://Resources/TileBase/wall.tres")

func paint_floor_tiles(floor_positions: Array[Vector2i]) -> void:
	# floor_positions are expected to be relative to the map, cell/map/tile coords
	_paint_tiles(floor_positions, self, _floor_tile)

func paint_wall_tiles(wall_positions: Array[Vector2i]) -> void:
	# floor_positions are expected to be relative to the map, cell/map/tile coords
	_paint_tiles(wall_positions, self, _wall_tile)

func _paint_tiles(tile_positions: Array[Vector2i], tile_map: TileMap, tile: TileBase) -> void:
	# positions are expected to be relative to the map, cell/map/tile coords
	for tile_position in tile_positions:
#		print("global positions: %v." % [tile_position])
		_paint_single_tile(tile_map, tile, tile_position)

func _paint_single_tile(tile_map: TileMap, tile: TileBase, tile_position : Vector2i) -> void:
	# position is expected to be relative to the map, cell/map/tile coords
#	print("tile positions: %v." % [tile_position])
	tile.set_cell(tile_map, tile_position)
