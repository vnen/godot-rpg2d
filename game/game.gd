
extends Node2D

func _ready():
	var camera = get_node("Player/camera")
	camera.make_current()
