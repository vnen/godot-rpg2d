
extends Panel

func item_hovered(item):
	get_node("StatusLine").set_bbcode(item.description)
