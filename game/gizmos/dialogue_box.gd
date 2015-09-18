
extends Control

# Stati constants
const STATUS_OFF = 0     # hidden
const STATUS_SHOWING = 1 # showing text
const STATUS_SHOWN = 2   # text shown and stopped

# Exported vars
export(float) var text_wait = 0.1 # Seconds between characters
export(float) var horizontal_ratio = 0.1 # Panel anchored position ratio

var current_status = STATUS_OFF setget ,get_status
var time_passed = 0
var dialogue_buffer = []

func get_status():
	return current_status

func append_dialogue(dialogue):
	dialogue_buffer.append(dialogue)

func _ready():
	set_process(true)
	set_anchor_and_margin( MARGIN_LEFT, ANCHOR_RATIO, horizontal_ratio)
	set_anchor_and_margin( MARGIN_RIGHT, ANCHOR_RATIO, 1.0 - horizontal_ratio)
	get_node("dialog_text").set_bbcode("")

func next():
	var dialog_text = get_node("dialog_text")
	if(current_status == STATUS_OFF):
		if (dialogue_buffer.size() == 0):
			return true
		dialog_text.set_bbcode(dialogue_buffer[0])
		dialogue_buffer.remove(0)
		dialog_text.set_visible_characters(0)
		show()
		current_status = STATUS_SHOWING
		time_passed = 0
		return false
	elif(current_status == STATUS_SHOWING):
		dialog_text.set_visible_characters(-1)
		current_status = STATUS_SHOWN
		return false
	else:
		if(dialogue_buffer.size() > 0):
			dialog_text.set_bbcode(dialogue_buffer[0])
			dialogue_buffer.remove(0)
			dialog_text.set_visible_characters(0)
			current_status = STATUS_SHOWING
			return false
		else:
			dialog_text
			current_status = STATUS_OFF
			hide()
			return true

func _process(delta):
	if(current_status == STATUS_SHOWING):
		time_passed += delta
		if(time_passed >= text_wait):
			time_passed -= text_wait
			var text_box = get_node("dialog_text")
			text_box.set_visible_characters( \
				text_box.get_visible_characters() + 1 \
			)
			if(text_box.get_visible_characters() >= text_box.get_bbcode().length()):
				current_status = STATUS_SHOWN
