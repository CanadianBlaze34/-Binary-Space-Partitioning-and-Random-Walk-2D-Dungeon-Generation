extends Node

class_name Zoom

@export_category("Camera Zooming")
@export var _camera : Node
@export var _speed : float = 0.05
@export var _clamp := Vector2(0.25, 8.0)

func _unhandled_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		_camera.zoom = Zoom._zoom(1, _clamp, _speed, _camera.zoom)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_camera.zoom = Zoom._zoom(-1, _clamp, _speed, _camera.zoom)

static func _zoom(direction : int, clamp_ : Vector2, speed : float, old_zoom : Vector2) -> Vector2:
	var new_zoom : float = old_zoom.x + direction * speed
	new_zoom = clamp(new_zoom, clamp_.x, clamp_.y)
	return new_zoom * Vector2.ONE
