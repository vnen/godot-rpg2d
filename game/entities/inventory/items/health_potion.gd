
extends "res://entities/inventory/item.gd"

export (int) var health_increase = 20

func effect(player):
	player.HP += health_increase