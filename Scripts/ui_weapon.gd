extends CanvasLayer

@onready var texture_rect = $TextureRect

func set_weapon_icon(icon: Texture2D):
	texture_rect.texture = icon
