# Item

extends Node2D

# The name of the item
export (String) var name
# Whether or not this item can stack
export (bool) var stackable = true
# The max amount of stacked items (-1 is to use the game global default)
export (int) var max_stack = -1
# The item texture
export (Texture) var texture = null
# If it's possible to use this item
export (bool) var can_use = false
# If it's possible to equip this item
export (bool) var can_equip = false
# If it's possible to drop this item
export (bool) var can_drop = true
# It this item is currently equipped
export (bool) var is_equipped = false
# The oneliner about this item
export (String) var description = ""
# The details about this item
export (String) var details = ""

func _ready():
	var sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_name("image")
	add_child(sprite)

func effect(player):
	pass
