
extends Panel

const NOTIFICATION_ACTION_SELECTED = 500

# Color for disabled labels
export (Color) var disabled_color = Color("393939")
export (Color) var enabled_color  = Color("FFFFFF")

var actions = {}
# Current item for actions
var item = null
# Cursor position in list
var cursor_index = 0

func set_item(item):
	self.item = item

func _ready():
	for node in get_node("ActionList").get_children():
		node.add_color_override("font_color", disabled_color)
		actions[node.get_name()] = false
	connect("visibility_changed", self, "_on_visibility_change")

func _on_visibility_change():
	if(is_visible()):
		cursor_index = 0
		update_cursor()

func enable_action(action):
	assert(actions.has(action))
	actions[action] = true
	get_node("ActionList/" + action).add_color_override("font_color", enabled_color)

func disable_action(action):
	assert(actions.has(action))
	actions[action] = false
	get_node("ActionList/" + action).add_color_override("font_color", disabled_color)

func _input(event):
	if(event.is_action("menu_down") and event.is_pressed()):
		cursor_index = int(clamp(cursor_index + 1, 0, actions.size() - 1))
		update_cursor()
	if(event.is_action("menu_up") and event.is_pressed()):
		cursor_index = int(clamp(cursor_index - 1, 0, actions.size() - 1))
		update_cursor()
	if(event.is_action("menu_select") and event.is_pressed() and !event.is_echo()):
		select()
	pass

func select():
	get_tree().call_group(0, "receive_item_action", "action_selected", \
		_get_pointed_node().get_name(), item)
	hide()

func update_cursor():
	for cursor in get_tree().get_nodes_in_group("cursor"):
		cursor.set_global_pos(\
			_get_pointed_node().get_global_pos())

func _get_pointed_node():
	return get_node("ActionList").get_child(cursor_index)
