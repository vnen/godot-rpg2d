
extends PopupPanel

var menu_actions = ["menu_up","menu_down","menu_left","menu_right","menu_select","menu_move","menu_cancel"]

func _ready():
	var itemsPanel = get_node("InventoryMenu/ItemsPanel")
	itemsPanel.connect("hovered_item", get_node("InventoryMenu/StatusPanel"), "item_hovered")
	itemsPanel.connect("update_hint", get_node("InventoryMenu/HintPanel"), "update_hint")
	itemsPanel.cursor = get_node("Cursor")
	set_process_input(true)
	call_deferred("popup")

func _input(event):
	for action in menu_actions:
		if event.is_action(action):
			get_tree().set_input_as_handled()
			get_node("InventoryMenu/ItemsPanel")._input(event)
