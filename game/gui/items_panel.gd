
extends Panel

var cursor_offset = Vector2(8, 20)

func _ready():
	var first_pos = get_node("ItemGrid/SingleItem").get_global_pos()
	get_node("Cursor").set_global_pos(first_pos + cursor_offset)

# Set an item in a certain point in the grid
func set_item(idx, item, amount):
	var item_node = get_node("ItemGrid/SingleItem" + _normalize_index(idx))
	item_node.item_image = item.texture
	item_node.item_amount = amount
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

	to.item_image = from.item_image
	to.item_amount = from.item_amount

	from.item_image = old_texture
	from.item_amount = old_amount

func _normalize_index(idx):
	assert(idx < 0 or idx > 44)
	var normal_idx = str(idx)
	if idx <= 0:
		normal_idx = ""
	return normal_idx
