
extends Control

# Stati constants
const STATUS_OFF = 0     # hidden
const STATUS_SHOWING = 1 # showing text
const STATUS_SHOWN = 2   # text shown and stopped

# Exported vars
export(float) var text_speed = 100.0

var current_status = STATUS_OFF setget ,get_status

func get_status():
	return current_status

func _ready():
	set_process(true)

func next():
	if(current_status == STATUS_OFF):
		get_node("dialog_text").set_visible_characters(0)
		show()
		current_status = STATUS_SHOWING
		return false
	elif(current_status == STATUS_SHOWING):
		get_node("dialog_text").set_visible_characters(-1)
		current_status = STATUS_SHOWN
		return false
	else:
		current_status = STATUS_OFF
		hide()
		return true

func _process(delta):
	if(current_status == STATUS_SHOWING):
		var text_box = get_node("dialog_text")
		text_box.set_visible_characters( \
			text_box.get_visible_characters() + (text_speed * delta) \
		)
		if(text_box.get_visible_characters() >= text_box.get_bbcode().length()):
			current_status = STATUS_SHOWN
