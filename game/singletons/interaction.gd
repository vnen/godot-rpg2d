
extends Node

func say(what, who = null):
	for box in get_tree().get_nodes_in_group("dialogue"):
		var text_box = box.get_node("dialog_text")
		var text = ""
		if(who):
			text = "[bold]" + str(who) + "[/bold]: "
		text += str(what)
		text_box.set_bbcode(text)
		box.show()