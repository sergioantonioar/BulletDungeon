extends Node

var health: int = 100
var score: int = 0
var owned_weapon_names: Array[String] = ["Gun"]
var current_weapon_index: int = 0

func reset() -> void:
	health = 100
	score = 0
	owned_weapon_names = ["Gun"]
	current_weapon_index = 0
