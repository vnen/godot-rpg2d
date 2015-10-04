
extends Panel

var cursor_offset = Vector2(15, 20)

# Cursor object
var cursor = null setget set_cursor

var grid_size = {}

func set_cursor(cur):
	cursor = cur
	get_node("ItemActionsPanel").cursor = cursor
	update_cursor()
	
# Current cursor position
var cursor_position = Vector2(0, 0)

func _ready():
	set_process_input(false) # It'll receive input from parent control
	get_node("ItemActionsPanel").connect("action_selected", self, "action_selected")
	grid_size["x"] = get_node("ItemGrid").get_columns()
	grid_size["y"] = 5
	
	# This is for testing, can be slow
	for i in range(20):
		var idx = randi() % 45
		while(!_get_item_node(idx).is_enabled()):
			idx = randi() % 45
		_get_item_node(idx).disable();

func _input(event):
	var actionsPanel = get_node("ItemActionsPanel")
	# Pass the event down the chain
	if(actionsPanel.is_visible()):
		actionsPanel._input(event)
		return
	if(event.is_action("menu_right") and event.is_pressed()):
		_move_cursor("x", 1)
	if(event.is_action("menu_left") and event.is_pressed()):
		_move_cursor("x", -1)
	if(event.is_action("menu_down") and event.is_pressed()):
		_move_cursor("y", 1)
	if(event.is_action("menu_up") and event.is_pressed()):
		_move_cursor("y", -1)
	if(event.is_action("menu_select") and event.is_pressed() and !event.is_echo()):
		select()

func action_selected(action, item):
	print("Doing ", action, " with ", item.name)
	update_cursor()

# Set an item in a certain point in the grid
func set_item(idx, item, amount):
	var item_node = _get_item_node(idx)
	item_node.item_amount = amount
	item_node.item = item
	return true

# Remove an item from the panel
func remove_item(idx):
	var item_node = _get_item_node(idx)
	item_node.disable()

# Set an item amount
func set_item_amount(idx, amount):
	var item_node = _get_item_node(idx)
	item_node.item_amount = amount
	return true

# Get an item amount
func get_item_amount(idx):
	return _get_item_node(idx).item_amount

# Increase the amount by one
func increment_amount(idx):
	set_item_amount(idx, get_item_amount(idx) + 1)

# Decrease the amount by one
func decrement_amount(idx):
	set_item_amount(idx, get_item_amount(idx) - 1)

# Move an item with replace
func move_item(idx_from, idx_to):
	var from = _get_item_node(idx_from)
	var to = _get_item_node_normalize_index(idx_to)

	var old_amount = to.item_amount
	var old_item = to.item

	to.item_amount = from.item_amount
	to.item = from.item

	from.item_amount = old_amount
	from.item = old_item

# Move the cursor in direction (x or y) by jump slots
func _move_cursor(dir, jump):
	var old_pos = cursor_position
	cursor_position[dir] = cursor_position[dir] + jump
	
	while cursor_position[dir] >= 0 and cursor_position[dir] < grid_size[dir] :
		var item_node = _get_item_node(_idx_from_position(cursor_position))
		if item_node.is_enabled():
			update_cursor()
			return
		cursor_position[dir] = cursor_position[dir] + jump
	
	cursor_position[dir] = int(clamp(cursor_position[dir], 0, grid_size[dir] - 1))
	var item_node = _get_item_node(_idx_from_position(cursor_position))
	if !item_node.is_enabled():
		cursor_position = old_pos
	else:
		update_cursor()

# Update cursor position
func update_cursor():
	var cur_pos = _get_pointed_node().get_global_pos()
	cursor.set_global_pos(cur_pos + cursor_offset)

# Select the item under cursor
func select():
	var item = _get_pointed_node().item
	var actionsPanel = get_node("ItemActionsPanel")
	actionsPanel.set_item(item)
	actionsPanel.show()

func _normalize_index(idx):
	assert(idx >= 0 and idx < 45)
	var normal_idx = str(idx)
	if idx <= 0:
		normal_idx = ""
	return normal_idx

func _idx_from_position(pos):
	return ( 9 * int(pos.y) ) + (int(pos.x) % 9)

func _get_pointed_node():
	return _get_item_node(_idx_from_position(cursor_position))

func _get_item_node(idx):
	return get_node("ItemGrid/SingleItem" + _normalize_index(idx))
