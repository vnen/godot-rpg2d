# Item Manager

# This singleton is responsible for managing the creation and 
# destruction of items. It's intended to keep everything lightweight
# even when there's a lot of items.

extends Node

const ITEMS_PATH = "res://entities/inventory/items"

# The pool of flyweight items
var item_list = {}

# The list of possible items to instantiate
var possible_items = []

func _ready():
	var dir = Directory.new()
	dir.open(ITEMS_PATH)
	dir.list_dir_begin()
	var cur_file = true

	while cur_file:
		cur_file = dir.get_next()
		if cur_file == "." or cur_file == ".." or cur_file.extension() != "xscn":
			continue
		possible_items.append(cur_file)
		print(cur_file)

	dir.list_dir_end()

func instance(item_name):
	if item_list.has(item_name):
		return item_list[item_name]
	if possible_items.find(item_name):
		item_list[item_name] = ResourceLoader.load(ITEMS_PATH + "/" + item_name)
		return item_list[item_name]
	return null
