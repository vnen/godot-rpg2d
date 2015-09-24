
extends Panel

var cursor_offset = Vector2(15, 20)

# Current cursor position
var cursor_position = Vector2(0, 0)

func _ready():
	var first_pos = get_node("ItemGrid/SingleItem").get_global_pos()
	get_node("Cursor").set_global_pos(first_pos + cursor_offset)
	set_process_input(true)

func _input(event):
	if(event.is_action("menu_right") and event.is_pressed()):
		move_cursor_right()
		get_tree().set_input_as_handled()
	if(event.is_action("menu_left") and event.is_pressed()):
		move_cursor_left()
		get_tree().set_input_as_handled()
	if(event.is_action("menu_down") and event.is_pressed()):
		move_cursor_down()
		get_tree().set_input_as_handled()
	if(event.is_action("menu_up") and event.is_pressed()):
		move_cursor_up()
		get_tree().set_input_as_handled()
	if(event.is_action("menu_select") and event.is_pressed() and !event.is_echo()):
		select()
		get_tree().set_input_as_handled()

# Set an item in a certain point in the grid
func set_item(idx, item, amount):
	var item_node = get_node("ItemGrid/SingleItem" + _normalize_index(idx))
	item_node.item_image = item.texture
	item_node.item_amount = amount
	item_node.item = item
	return true

# Set an item amount
func set_item_amount(idx, amount):
	var item_node = get_node("ItemGrid/SingleItem" + _normalize_index(idx))
	item_node.item_amount = amount
	return true

# Get an item amount
func get_item_amount(idx):
	return get_node("ItemGrid/SingleItem" + _normalize_index(idx)).item_amount

# Increase the amount by one
func increment_amount(idx):
	set_item_amount(idx, get_item_amount(idx) + 1)

# Decrease the amount by one
func decrement_amount(idx):
	set_item_amount(idx, get_item_amount(idx) - 1)

# Move an item with replace
func move_item(idx_from, idx_to):
	var from = get_node("ItemGrid/SingleItem" + _normalize_index(idx_from))
	var to = get_node("ItemGrid/SingleItem" + _normalize_index(idx_to))

	var old_texture = to.item_image
	var old_amount = to.item_amount
	var old_item = to.item

	to.item_image = from.item_image
	to.item_amount = from.item_amount
	to.item = from.item

	from.item_image = old_texture
	from.item_amount = old_amount
	from.item = old_item

# Move the cursor to the right
func move_cursor_right():
	cursor_position.x = clamp(cursor_position.x + 1, 0, 8)
	update_cursor()
# Move the cursor to the left
func move_cursor_left():
	cursor_position.x = clamp(cursor_position.x - 1, 0, 8)
	update_cursor()
# Move the cursor down
func move_cursor_down():
	cursor_position.y = clamp(cursor_position.y + 1, 0, 4)
	update_cursor()
# Move the cursor up
func move_cursor_up():
	cursor_position.y = clamp(cursor_position.y - 1, 0, 4)
	update_cursor()
# Update cursor position
func update_cursor():
	var cur_pos = _get_pointed_node().get_global_pos()
	get_node("Cursor").set_global_pos(cur_pos + cursor_offset)

# Select the item under cursor
func select():
	OS.alert("Selected item " + _get_pointed_node().item.name)
	pass

func _normalize_index(idx):
	assert(idx >= 0 and idx < 45)
	var normal_idx = str(idx)
	if idx <= 0:
		normal_idx = ""
	return normal_idx

func _idx_from_position(pos):
	return ( 9 * int(pos.y) ) + (int(pos.x) % 9)

func _get_pointed_node():
	return get_node("ItemGrid/SingleItem" + \
			_normalize_index(_idx_from_position(cursor_position)) \
		)
