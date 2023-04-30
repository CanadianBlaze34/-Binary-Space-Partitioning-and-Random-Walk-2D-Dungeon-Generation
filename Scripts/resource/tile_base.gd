extends Resource

class_name TileBase

@export var source_id : int = -1
@export var atlas_coords : Vector2i = Vector2i(-1, -1)
@export var alternative_tile : int = -1
@export var layer : int = -1

func set_cell(tile_map : TileMap, coords: Vector2i) -> void:
	tile_map.set_cell(layer, coords, source_id, atlas_coords, alternative_tile)
