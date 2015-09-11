
extends Node

var levels = {}

func _ready():
	print(get_tree().get_current_scene().get_name())

	levels["home_town"] = "res://levels/home_town.xscn"
	levels["home"] = "res://levels/home.xscn"

# Warps to another level
func warp(to):
	if(!levels.has(to)):
		return ERR_INVALID_PARAMETER

	if(is_game()):
		var level = get_tree().get_nodes_in_group("level")[0]
		call_deferred("do_warp", level, to)

func is_game():
	return "game" == get_tree().get_current_scene().get_name()

func do_warp(current_level, to):
	current_level.free()
	var new_level = ResourceLoader.load(levels[to]).instance()
	var game = get_tree().get_current_scene()

	new_level.add_to_group("level")
	game.add_child(new_level)
