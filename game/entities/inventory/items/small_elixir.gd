
extends "res://entities/inventory/item.gd"

export (int) var mana_increase = 20

func _init():
	texture = preload("res://art/rpg-icons/small_elixir.png")
	name = "Small Elixir"
	description = "Restore 20MP to a character's mana."
	details = description
	can_use = true
	stackable = true

func effect(player):
	player.MP += mana_increase
