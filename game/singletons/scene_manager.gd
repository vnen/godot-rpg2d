
extends Node

# Warps to another level
func warp(level, warp):
	if(is_game()):
		var current_level = get_tree().get_nodes_in_group("level")[0]
		call_deferred("do_warp", current_level, level, warp)

func is_game():
	return "game" == get_tree().get_current_scene().get_name()

func do_warp(current_level, level, warp):
	current_level.free()
	var new_level = ResourceLoader.load(level).instance()
	var game = get_tree().get_current_scene()

	new_level.add_to_group("level")
	game.add_child(new_level)
	game.set_camera_limits(new_level.map_size)
	
	var target = new_level.find_node(warp)
	if(target and target extends Position2D):
		for body in get_tree().get_nodes_in_group("player"):
			body.set_pos(target.get_pos())
			break
