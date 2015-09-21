
extends PopupPanel

func _ready():
	popup()
	
	for i in range(40):
		var item = get_node("/root/items_manager").instance("health_potion")
		item.set_name(item.get_name() + str(i))
		get_node("ItemGrid").add_child(item)
	


