extends CanvasLayer

@onready var weapon_icon = $Control/VBoxContainer/Control/TextureRect

var weapon_icons = {
	"Gun": preload("res://Assets/weapons/gun.png"),
	"Bow": preload("res://Assets/weapons/bow.png")
}

func change_weapon(weapon_name):
	if weapon_name in weapon_icons:
		weapon_icon.texture = weapon_icons[weapon_name]
