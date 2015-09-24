
extends Control

export (int, 0, 99) var item_amount = 1 setget set_amount,get_amount
export (Texture) var item_image = null

var item = null setget set_item,get_item

func set_item(v):
	item = v
func get_item():
	return item

func set_amount(value):
	item_amount = clamp( float(value), 0, 99 )
	if !is_inside_tree():
		return
	value = int(value)
	if value > 1:
		get_node("ItemCount").set_text(str(item_amount))
		get_node("ItemImage").show()
	elif value == 1:
		get_node("ItemCount").set_text("")
		get_node("ItemImage").show()
	else:
		get_node("ItemCount").set_text("")
		get_node("ItemImage").hide()

func get_amount():
	return item_amount

func _ready():
	set_amount(item_amount)
	get_node("ItemImage").set_texture(item_image)