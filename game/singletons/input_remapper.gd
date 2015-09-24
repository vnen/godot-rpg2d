# Handles holding of key presses

extends Control

# Time to wait before considering it a another key press
var repress_threshold = .2

var input_times = {}

func _ready():
	set_process(true)
	set_process_input(true)
	input_times["ui_left"] = [false, repress_threshold]
	input_times["ui_right"] = [false, repress_threshold]
	input_times["ui_up"] = [false, repress_threshold]
	input_times["ui_down"] = [false, repress_threshold]

func _process(delta):
	for action in input_times.keys():
		if Input.is_action_pressed(action):
			input_times[action][0] = true
			input_times[action][1] = input_times[action][1] + delta
			if input_times[action][1] > repress_threshold:
				input_times[action][1] = input_times[action][1] - repress_threshold
				var new_event = InputEvent()
				new_event.type = InputEvent.ACTION
				new_event.set_as_action("menu_" + action.substr(3, action.length() - 3), true)
				get_tree().input_event(new_event)
		else:
			input_times[action][0] = false
			input_times[action][1] = repress_threshold

func _input(event):
	for action in input_times.keys():
		if(event.is_action(action)):
			get_tree().set_input_as_handled()
