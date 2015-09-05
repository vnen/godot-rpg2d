
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

func _process(delta):
	var move_north = Input.is_action_pressed("move_north")
	var move_west = Input.is_action_pressed("move_west")
	var move_south = Input.is_action_pressed("move_south")
	var move_east = Input.is_action_pressed("move_east")

	var direction = Vector2(0,0)
	var animation = IDLE
	var anim_direction = current_direction

	if(move_north):
		direction.y = -1
		anim_direction = NORTH
	elif(move_south):
		direction.y = 1
		anim_direction = SOUTH
	if(move_west):
		direction.x = -1
		anim_direction = WEST
	elif(move_east):
		direction.x = 1
		anim_direction = EAST

	set_pos(get_pos() + direction * walk_speed * delta);

	current_direction = anim_direction
	if(move_north or move_west or move_south or move_east):
		current_animation = WALK
	else:
		current_animation = IDLE

	update_animation()

func update_animation():
	var tree_player = get_node("treeplayer")
	tree_player.transition_node_set_current("movement_transition", current_animation)
	if (current_animation == IDLE):
		tree_player.transition_node_set_current("idle_transition", current_direction)
	else:
		tree_player.transition_node_set_current("walk_transition", current_direction)
