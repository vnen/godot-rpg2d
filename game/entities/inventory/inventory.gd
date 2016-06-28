# Player inventory. A central place to manage the items that
# the player has. This is used as a reference to any GUI
# that needs the inventory data. For that the signals can be
# used to detect updates.
#
# The "item" here must be a Dictionary with an item object with
# index "item" and the amount of stacked items in the "amount"
# index.

extends Node

# Maximum amount of items in the inventory
const MAX_INVENTORY_SIZE = 45
# Maximum stack size
const MAX_STACK_AMOUNT = 99

signal item_added (item, index)
signal item_removed (item, index)
signal item_changed (new_item, index)

var inventory = []
var size = 0

func _init():
	# Initialize with null items to have a full array
	for i in range(MAX_INVENTORY_SIZE):
		inventory.push_back(null)

# Push an item to the inventory and return its index
# Or -1 if full
func push_item(item):
	if size == MAX_INVENTORY_SIZE:
		return -1

	inventory[size] = item
	size += 1
	emit_signal("item_added", item, size - 1)
	return size - 1

# Remove an item from the inventory and readjust the positions
func remove_item(index):
	assert (index >= 0 and index < size)
	var item = _get_item(index)
	for i in range(index, size - 1):
		inventory[i] = inventory[i + 1]
	inventory[size - 1] = null
	size -= 1
	emit_signal("item_removed", item, index)

# Replace an item with another.
func update_item(index, new_item):
	assert(index >= 0 and index < size)
	_set_item(index, new_item)
	emit_signal("item_changed", new_item, index)

# Merge (stack) two items together. If not possible due to overflow,
# the remaining will stay on the old item. If the items can't stack,
# then replace one for the other.
func merge_items(index_from, index_to):
	var to = _get_item(index_to)
	var from = _get_item(index_from)
	if to.item.stackable and to.item.name == from.item.name:
		var max_stack = max(to.item.max_stack, MAX_STACK_AMOUNT)
		to.amount += from.amount
		if to.amount > max_stack:
			from.amount = to.amount - max_stack
			to.amount = max_stack
			update_item(index_from, from)
			update_item(index_to, to)
		else:
			update_item(index_to, to)
			remove_item(index_from)
	else:
		var temp = to
		to = from
		from = temp
		update_item(index_from, from)
		update_item(index_to, to)

func _get_item(index):
	assert(index >= 0 and index < MAX_INVENTORY_SIZE)
	return inventory[index]

func _set_item(index, item):
	assert(index >= 0 and index < MAX_INVENTORY_SIZE)
	inventory[index] = item
	return self
