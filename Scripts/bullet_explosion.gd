extends AnimatedSprite2D

func _ready() -> void:
	connect("animation_finished", _on_animation_finished)
	
func _on_animation_finished():
	queue_free()
