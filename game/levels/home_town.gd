
extends "res://levels/level.gd"

func _ready():
	map_size = Vector2(1280, 800)
	make_walls()
	set_process(true)		
	var follow = get_node("npc_path/follow")
	var npc = get_node("Npc")

	npc.set_pos(follow.get_pos())

func _process(delta):
	get_node("Npc").follow_path(get_node("npc_path/follow"), delta)
