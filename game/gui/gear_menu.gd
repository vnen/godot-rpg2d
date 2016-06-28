
extends PopupPanel

var menu_actions = ["menu_up","menu_down","menu_left","menu_right","menu_select"]

func _ready():
	get_node("InventoryMenu/ItemsPanel").cursor = get_node("Cursor")
	set_process_input(true)
	call_deferred("popup")
	print(Vector2(3,4)["y"])

func _input(event):
	for action in menu_actions:
		if event.is_action(action):
			get_tree().set_input_as_handled()
			get_node("InventoryMenu/ItemsPanel")._input(event)
