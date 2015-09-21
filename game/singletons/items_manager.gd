# Item Manager

# This singleton is responsible for managing the creation and 
# destruction of items. It's intended to keep everything lightweight
# even when there's a lot of items.

extends Node

# The pool of flyweight items
var item_list = {}

# The list of possible items to instantiate
var existing_items = []

func _ready():
	var dir = Directory.new()
	dir.open("res://entities/inventory/items")
	dir.list_dir_begin()
	var cur_file = true

	while cur_file:
		cur_file = dir.get_next()
		if cur_file == "." or cur_file == ".." or cur_file.extension() != "xscn":
			continue
		existing_items.append(cur_file)
		print(cur_file)

	dir.list_dir_end()
