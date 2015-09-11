
extends Node2D

func _ready():
	set_camera_limits(get_node("home_town").map_size)

func set_camera_limits(level_size):
	var camera = get_node("Player/camera")
	var view_rect = Vector2(1280, 720)

	camera.make_current()
	camera.set_limit(MARGIN_TOP, 0)
	camera.set_limit(MARGIN_LEFT, 0)
	camera.set_limit(MARGIN_RIGHT, max(level_size.x, view_rect.x ))
	camera.set_limit(MARGIN_BOTTOM, max(level_size.y, view_rect.y ))
