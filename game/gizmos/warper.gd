
extends Area2D

### Exported properties

# The level to go when warped.
export (String, FILE) var target_level = null
# The name of the Position2D node to land on.
export (String) var target_warp = null

func _ready():
	connect("body_enter", self, "on_body_enter")
	
func on_body_enter(body):
	if(body.is_in_group("player")):
		get_node("/root/scene_manager").warp(target_level, target_warp)
