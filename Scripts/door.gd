extends Node2D

var opened = false

func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$StaticBody2D2/CollisionShape2D.disabled=true
	$StaticBody2D2/CollisionShape2D2.disabled=true

func _on_area_2d_body_entered(body):
	print("Body entered: ", body.name, " grupos: ", body.get_groups())
	if body.is_in_group("Player") and not opened:
		opened=true
		$AnimatedSprite2D.play("Open")

func _on_animation_finished():
	if $AnimatedSprite2D.animation=="Open":
		$StaticBody2D/CollisionShape2D.disabled=true
		$StaticBody2D2/CollisionShape2D.disabled=false
		$StaticBody2D2/CollisionShape2D2.disabled=false
