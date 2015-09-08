
extends Control

var dialogue_on = false

func _ready():
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process_input(true)

func _input(event):
	if(dialogue_on):
		if(event.is_action("interact") and event.is_pressed() and !event.is_echo()):
			for box in get_tree().get_nodes_in_group("dialogue"):
				dialogue_on = !box.next()
			var tree = get_tree()
			tree.set_pause(dialogue_on)
			tree.set_input_as_handled()

func say(what, who = null):
	for box in get_tree().get_nodes_in_group("dialogue"):
		var text_box = box.get_node("dialog_text")
		var text = ""
		if(who):
			text = "[bold]" + str(who) + "[/bold]: "
		text += str(what)
		text_box.set_bbcode(text)
		box.next()
	get_tree().set_pause(true)
	dialogue_on = true
