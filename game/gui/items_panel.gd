
extends Panel

signal hovered_item(item)
signal update_hint(hint)

export var cursor_offset = Vector2(15, 20)
export var hold_offset = Vector2(10,10)
export var default_message = "Select item"
export var hold_message = "Move to where?"
export var action_message = "Do what?"

var grid_size = Vector2()
# Current cursor position
var cursor_position = Vector2(0, 0)
var selected_index = 0
var last_index = -1
var holding = null

# Cursor object
var cursor = null setget set_cursor
func set_cursor(cur):
	cursor = cur
	get_node("ItemActionsPanel").cursor = cursor
	update_cursor()
	var pointed = _get_pointed_node()
	if pointed.is_enabled():
		emit_signal("hovered_item", pointed.item)
	emit_signal("update_hint", default_message)


func _ready():
	set_process_input(false) # It'll receive input from parent control
	get_node("ItemActionsPanel").connect("action_selected", self, "action_selected")
	grid_size.x = get_node("ItemGrid").get_columns()
	grid_size.y = 5

	inventory.connect("item_added", self, "_on_item_added")
	inventory.connect("item_removed", self, "_on_item_removed")
	inventory.connect("item_changed", self, "_on_item_changed")

	emit_signal("update_hint", default_message)

	var items = [items_manager.instance("small_potion"), items_manager.instance("small_elixir")]
	randomize()
	for i in range(16):
		inventory.push_item({"item": items[randi() % items.size()], "amount": randi() % 20 + 1})

func _input(event):
	var actionsPanel = get_node("ItemActionsPanel")
	# Pass the event down the chain
	if(actionsPanel.is_visible()):
		actionsPanel._input(event)
		return
	elif(event.is_action("menu_right") and event.is_pressed()):
		_move_cursor("x", 1)
	elif(event.is_action("menu_left") and event.is_pressed()):
		_move_cursor("x", -1)
	elif(event.is_action("menu_down") and event.is_pressed()):
		_move_cursor("y", 1)
	elif(event.is_action("menu_up") and event.is_pressed()):
		_move_cursor("y", -1)
	elif(event.is_action("menu_select") and event.is_pressed() and !event.is_echo()):
		select()
	elif(event.is_action("menu_move") and event.is_pressed() and !event.is_echo()):
		if holding != null:
			move_drop()
		else:
			move_hold()
	elif(event.is_action("menu_cancel") and event.is_pressed() and !event.is_echo()):
		move_cancel()

func _on_item_added(item, index):
	last_index += 1
	set_item(index, item.item, item.amount)

func _on_item_removed(item, index):
	for i in range(index, last_index):
		var next = _get_item_node(i + 1)
		set_item(i, next.item, next.item_amount)
	_get_item_node(last_index).disable()
	last_index -= 1
	if selected_index >= index:
		selected_index -= 1
		update_cursor()

func _on_item_changed(new_item, index):
	set_item(index, new_item.item, new_item.amount)

# Set an item in a certain point in the grid
func set_item(idx, item, amount):
	var item_node = _get_item_node(idx)
	item_node.item_amount = amount
	item_node.item = item
	return true

func action_selected(action, item):
	emit_signal("update_hint", default_message)
	print("Doing ", action, " with ", item.name)
	if action == "Drop":
		inventory.remove_item(selected_index)
		return
	elif action == "Details":
		var idx = selected_index
	update_cursor()

# Move the cursor in direction (x or y) by jump slots
func _move_cursor(dir, jump):
	var old_index = selected_index
	if dir == "x":
		var old_column = int(selected_index) % int(grid_size.x)
		selected_index += sign(jump)
		var new_column = int(selected_index) % int(grid_size.x)
		if sign(new_column - old_column) != sign(jump):
			# moved to a new row, revert
			selected_index -= sign(jump)
	elif dir == "y":
		selected_index += sign(jump) * grid_size.x
		var new_line = int(selected_index / grid_size.x)
		if selected_index < 0 or new_line > int(last_index / grid_size.x):
			# Passed the limit, revert
			selected_index -= sign(jump) * grid_size.x
	selected_index = int(clamp(selected_index,0,last_index))
	if selected_index != old_index:
		emit_signal("hovered_item", inventory.get_item(selected_index).item)
	update_cursor()

# Update cursor position
func update_cursor():
	cursor_position = Vector2( int(selected_index) % int(grid_size.x), int(selected_index / grid_size.x) )
	var cur_pos = _get_pointed_node().get_global_pos()
	cursor.set_global_pos(cur_pos + cursor_offset)

# Select the item under cursor
func select():
	emit_signal("update_hint", action_message)
	var item = inventory.get_item(selected_index)
	var actionsPanel = get_node("ItemActionsPanel")
	actionsPanel.set_item(item.item)
	actionsPanel.show()

# Hold an item to move
func move_hold():
	emit_signal("update_hint", hold_message)
	var pointed = _get_pointed_node()
	holding = {"node": pointed.duplicate(), "index": selected_index}
	cursor.add_child(holding.node)
	holding.node.set_pos(hold_offset)

# Drop the moved item
func move_drop():
	var target_index = selected_index
	if holding.index != target_index:
		print("merging from %s to %s" % [holding.index, target_index])
		inventory.merge_items(holding.index, target_index)
	move_cancel()

# Cancel the move
func move_cancel():
	emit_signal("update_hint", default_message)
	if holding == null:
		return
	holding.node.free()
	holding = null

func _normalize_index(idx):
	assert(idx >= 0 and idx < 45)
	var normal_idx = str(idx)
	if idx <= 0:
		normal_idx = ""
	return normal_idx

func _get_pointed_node():
	return _get_item_node(selected_index)

func _get_item_node(idx):
	return get_node("ItemGrid/SingleItem" + _normalize_index(idx))
