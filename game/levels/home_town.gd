
extends Node2D

var map_size = Vector2(1280,800) setget ,get_size

func get_size():
	return map_size

func _ready():
	map_size = Vector2(1280, 800)
	make_walls()

func make_walls():
	var wall_width = 20
	var vertical_wall_shape = RectangleShape2D.new()
	var horizontal_wall_shape = RectangleShape2D.new()

	vertical_wall_shape.set_extents(Vector2(wall_width / 2, map_size.y / 2))
	horizontal_wall_shape.set_extents(Vector2(map_size.x / 2, wall_width / 2))

	var left_wall = StaticBody2D.new()
	left_wall.set_pos(Vector2(0 - (wall_width / 2), map_size.y / 2))
	left_wall.add_shape(vertical_wall_shape)

	var right_wall = StaticBody2D.new()
	right_wall.set_pos(Vector2(map_size.x + (wall_width / 2), map_size.y / 2))
	right_wall.add_shape(vertical_wall_shape)

	var top_wall = StaticBody2D.new()
	top_wall.set_pos(Vector2(map_size.x / 2, 0 - (wall_width / 2)))
	top_wall.add_shape(horizontal_wall_shape)

	var bottom_wall = StaticBody2D.new()
	bottom_wall.set_pos(Vector2(map_size.x / 2, map_size.y + (wall_width / 2)))
	bottom_wall.add_shape(horizontal_wall_shape)

	add_child(left_wall)
	add_child(right_wall)
	add_child(top_wall)
	add_child(bottom_wall)
