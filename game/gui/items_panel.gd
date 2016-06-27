
extends Panel

var cursor_offset = Vector2(15, 20)

# Cursor object
var cursor = null setget set_cursor

var grid_size = Vector2()
var last_index = -1

func set_cursor(cur):
	cursor = cur
	get_node("ItemActionsPanel").cursor = cursor
	update_cursor()

# Current cursor position
var cursor_position = Vector2(0, 0)

func _ready():
	set_process_input(false) # It'll receive input from parent control
	get_node("ItemActionsPanel").connect("action_selected", self, "action_selected")
	grid_size.x = get_node("ItemGrid").get_columns()
	grid_size.y = 5

	var item = items_manager.instance("small_potion")
	randomize()
	for i in range(16):
		add_item(item, randi() % 10 + 1)

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

# Add a new item to the inventory
# Returns the item index
func add_item(item, amount=1):
	last_index += 1
	set_item(last_index, item, amount)

# Remove an item from the panel
func remove_item(idx):
	assert(idx >= 0 and idx <= last_index)
	for i in range(idx, last_index):
		var next = _get_item_node(i + 1)
		set_item(i, next.item, next.item_amount)
	_get_item_node(last_index).disable()
	last_index -= 1
	if _idx_from_position(cursor_position) >= idx:
		cursor_position = _position_from_idx(_idx_from_position(cursor_position) - 1)
		update_cursor()

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
	return ( grid_size.x * int(pos.y) ) + (int(pos.x) % int(grid_size.x))

func _position_from_idx(idx):
	return Vector2( int(idx) % int(grid_size.x), int(idx / grid_size.x) )

func _get_pointed_node():
	return _get_item_node(_idx_from_position(cursor_position))

func _get_item_node(idx):
	return get_node("ItemGrid/SingleItem" + _normalize_index(idx))
