# Item

extends Control

# The name of the item
export (String) var name
# Whether or not this item can stack
export (bool) var stackable = true
# The max amount of stacked items (-1 is to use the game global default)
export (int) var max_stack = -1
# The item texture
export (Texture) var texture = null

func _ready():
	var sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_name("image")
	add_child(sprite)

func effect(player):
	pass
