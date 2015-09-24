
extends Panel

# Color for disabled labels
export (Color) var disabled_color = Color("393939")
export (Color) var enabled_color  = Color("FFFFFF")

var actions = {}

func _ready():
	for node in get_node("ActionList").get_children():
		node.add_color_override("font_color", disabled_color)
		actions[node.get_name()] = false
	set_process_input(true)

func _input(event):
	var miaction = "Give"
	if(event.is_action("interact") and event.is_pressed() and !event.is_echo()):
		if actions[miaction]:
			disnable_action(miaction)
		else:
			enable_action(miaction)

func enable_action(action):
	assert(actions.has(action))
	actions[action] = true
	get_node("ActionList/" + action).add_color_override("font_color", enabled_color)

func disnable_action(action):
	assert(actions.has(action))
	actions[action] = false
	get_node("ActionList/" + action).add_color_override("font_color", disabled_color)
