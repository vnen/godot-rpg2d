
extends PopupPanel

var inventory_item = preload("res://entities/inventory/item_control.xscn")

func _ready():
	popup()
	
	for i in range(32):
		var item = get_node("/root/items_manager").instance("health_potion")
		var control = inventory_item.instance()
		control.get_node("Icon").set_texture(item.texture)
		control.get_node("Name").set_text(item.name)
		
		get_node("ItemGrid").add_child(control)
	


