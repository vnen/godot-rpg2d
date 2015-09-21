# Item

extends Reference

# The name of the item
export (String) var name
# Whether or not this item can stack
export (bool) var stackable = true
# The max amount of stacked items (-1 is to use the game global default)
export (int) var max_stack = -1
