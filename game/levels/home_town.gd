
extends Node2D

var map_size = Vector2(1280,800) setget ,get_size

func get_size():
	return map_size

func _ready():
	map_size = Vector2(1280, 800)
	make_walls()
	set_process(true)
	var follow = get_node("npc_path/follow")
	var npc = get_node("Npc")
	
	npc.set_pos(follow.get_pos())

func make_walls():
	var wall_half_width = 10
	var vertical_wall_shape = RectangleShape2D.new()
	var horizontal_wall_shape = RectangleShape2D.new()

	vertical_wall_shape.set_extents(Vector2(wall_half_width, map_size.y / 2))
	horizontal_wall_shape.set_extents(Vector2(map_size.x / 2, wall_half_width))

	var left_wall = StaticBody2D.new()
	left_wall.set_pos(Vector2(0 - (wall_half_width), map_size.y / 2))
	left_wall.add_shape(vertical_wall_shape)

	var right_wall = StaticBody2D.new()
	right_wall.set_pos(Vector2(map_size.x + (wall_half_width), map_size.y / 2))
	right_wall.add_shape(vertical_wall_shape)

	var top_wall = StaticBody2D.new()
	top_wall.set_pos(Vector2(map_size.x / 2, 0 - (wall_half_width)))
	top_wall.add_shape(horizontal_wall_shape)

	var bottom_wall = StaticBody2D.new()
	bottom_wall.set_pos(Vector2(map_size.x / 2, map_size.y + (wall_half_width)))
	bottom_wall.add_shape(horizontal_wall_shape)

	add_child(left_wall)
	add_child(right_wall)
	add_child(top_wall)
	add_child(bottom_wall)

func _process(delta):
	var follow = get_node("npc_path/follow")
	var npc = get_node("Npc")
	var old_offset = follow.get_offset()

	follow.set_offset(follow.get_offset() + (npc.walk_speed * delta))
	npc.move_to(follow.get_pos())

	var travel = npc.get_travel()
	if(travel.length() < 0.5):
		follow.set_offset(old_offset)
		npc.set_pos(follow.get_pos())
		travel = Vector2(0,0)

	npc.update_travel(travel)
