
extends "res://entities/inventory/item.gd"

export (int) var health_increase = 20

func _init():
	texture = ResourceLoader.load("res://art/rpg-icons/small_potion.png")

func effect(player):
	player.HP += health_increase
