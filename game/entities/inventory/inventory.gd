
extends PopupPanel

func _ready():
	popup()
	var list = get_node("ItemList")
	list.set_icon_mode(list.ICON_MODE_TOP)
	list.set_max_columns(0)
	list.set_fixed_column_width(60)
	list.set_min_icon_size(Vector2(40, 60))
	list.set_max_text_lines(3)
	for i in range(50):
		var item = get_node("/root/items_manager").instance("health_potion")
		list.add_item( item.name, item.texture )
	


