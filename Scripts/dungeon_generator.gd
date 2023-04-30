extends Node
# abstract class
class_name DungeonGenerator

# protected
@export_category("DungeonGenerator")
@export var _tile_map_visualizer : TileMapVisualizer
@export var _start_position := Vector2i.ZERO
@export_category("")

func _ready() -> void:
	generate_dungeon()

func generate_dungeon() -> void:
	_tile_map_visualizer.clear()
	_run_procedural_generation()

func _run_procedural_generation() -> void:
#	push_error("Method 'run_procedural_generation' is not overridden.")
	assert(false, "Method 'run_procedural_generation' is not overridden.")
