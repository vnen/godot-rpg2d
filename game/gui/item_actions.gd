
extends Panel

const NOTIFICATION_ACTION_SELECTED = 500

signal action_selected(action, item)

# Color for disabled labels
export (Color) var disabled_color = Color("393939")
export (Color) var enabled_color  = Color("FFFFFF")

var actions = {}
var action_keys = []
# Current item for actions
var item = null
# Cursor object
export (Object) var cursor = null
# Cursor position in list
var cursor_index = 0
# Offset between cursor and node position
var cursor_offset = Vector2(0, 8)

func set_item(item):
	self.item = item
	if(item.can_use):
		enable_action("Use")
	if(item.can_equip):
		if(item.is_equipped):
			enable_action("Unequip")
		else:
			enable_action("Equip")
	if(item.can_drop):
		enable_action("Drop")
	enable_action("Details")
	cursor_index = 0
	for i in range(action_keys.size()):
		if actions[action_keys[i]]:
			cursor_index = i
			break

func _ready():
	for node in get_node("ActionList").get_children():
		node.add_color_override("font_color", disabled_color)
		var name = node.get_name()
		actions[name] = false
		action_keys.append(name)
	connect("visibility_changed", self, "_on_visibility_change")

func _on_visibility_change():
	if(is_visible()):
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
		_skip_cursor(1)
	if(event.is_action("menu_up") and event.is_pressed()):
		_skip_cursor(-1)
	if(event.is_action("menu_select") and event.is_pressed() and !event.is_echo()):
		select()
	pass

func select():
	emit_signal("action_selected", action_keys[cursor_index], item)
	print(action_keys[cursor_index], ": ",item.name)
	hide()

func update_cursor():
	cursor.set_global_pos(\
		_get_pointed_node().get_global_pos() + cursor_offset)

func _get_pointed_node():
	return get_node("ActionList").get_child(cursor_index)

func _skip_cursor(var dir):
	var old_index = cursor_index
	cursor_index += dir
	while cursor_index >= 0 and cursor_index < action_keys.size():
		if(actions[action_keys[cursor_index]]):
			update_cursor()
			return
		cursor_index += dir

	cursor_index = int(clamp(cursor_index, 0, action_keys.size() - 1))
	if(!actions[action_keys[cursor_index]]):
		cursor_index = old_index
	else:
		update_cursor()