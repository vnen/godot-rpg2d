
extends KinematicBody2D

# Direction constants
const NORTH=0
const WEST=1
const SOUTH=2
const EAST=3

# Movement status constants
const IDLE=0
const WALK=1

# Configuration variables
export(float) var walk_speed = 120.0
export(float) var walk_animation_scale = 1.2
export(float) var movement_threshold = 0.8 # Percentage of standard walk travel

# State keeping
var current_animation=IDLE
var current_direction=SOUTH


func _ready():
	var treeplayer = get_node("treeplayer")
	treeplayer.transition_node_set_current("movement_transition", current_animation)
	treeplayer.transition_node_set_current("idle_transition", current_direction)
	treeplayer.timescale_node_set_scale("walk_scale", walk_animation_scale)
	treeplayer.set_active(true)
	set_process(true)

func update_animation():
	var tree_player = get_node("treeplayer")
	tree_player.transition_node_set_current("movement_transition", current_animation)
	if (current_animation == IDLE):
		tree_player.transition_node_set_current("idle_transition", current_direction)
	else:
		tree_player.transition_node_set_current("walk_transition", current_direction)

func update_travel(travel):
	if(travel.length() > 0):
		var angle = travel.angle_to(Vector2(1,0))
		current_direction = get_direction_from_angle(angle)
		current_animation = WALK
	else:
		current_animation = IDLE
	update_animation()

func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return NORTH
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return EAST
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return SOUTH
	return WEST

# follow is a PathFollow2D node
func follow_path(follow, delta):
	var old_offset = follow.get_offset()

	var standard_travel = walk_speed * delta

	follow.set_offset(follow.get_offset() + (walk_speed * delta))
	move_to(follow.get_pos())

	var travel = get_travel()
	if(travel.length() < movement_threshold * standard_travel):
		follow.set_offset(old_offset)
		set_pos(follow.get_pos())
		travel = Vector2(0,0)

	update_travel(travel)

func interact(body):
	var interaction = get_node("/root/interaction")
	interaction.say("Hello " + body.get_name(), get_name())