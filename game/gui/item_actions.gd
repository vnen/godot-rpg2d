
extends Panel

# Color for disabled labels
export (Color) var disabled_color = Color("393939")
export (Color) var enabled_color  = Color("FFFFFF")

var actions = {}
# Current item for actions
var item = null

func set_item(item):
	self.item = item
	print(self.item.name)

func _ready():
	for node in get_node("ActionList").get_children():
		node.add_color_override("font_color", disabled_color)
		actions[node.get_name()] = false

func enable_action(action):
	assert(actions.has(action))
	actions[action] = true
	get_node("ActionList/" + action).add_color_override("font_color", enabled_color)

func disable_action(action):
	assert(actions.has(action))
	actions[action] = false
	get_node("ActionList/" + action).add_color_override("font_color", disabled_color)
