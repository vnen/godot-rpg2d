
extends Node2D

func _ready():
	var camera = get_node("Player/camera")
	var level_size = get_node("home_town").map_size
	camera.make_current()
	camera.set_limit(MARGIN_TOP, 0)
	camera.set_limit(MARGIN_LEFT, 0)
	camera.set_limit(MARGIN_RIGHT, level_size.x)
	camera.set_limit(MARGIN_BOTTOM, level_size.y)
	get_global_transform()