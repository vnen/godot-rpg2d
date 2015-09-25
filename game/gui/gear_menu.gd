
extends PopupPanel

var menu_actions = ["menu_up","menu_down","menu_left","menu_right","menu_select"]

func _ready():
	popup()
	set_process_input(true)

func _input(event):
	for action in menu_actions:
		if event.is_action(action):
			get_tree().set_input_as_handled()
			get_node("InventoryMenu/ItemsPanel")._input(event)
