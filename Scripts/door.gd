extends Node2D

var opened = false

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$StaticBody2D2/CollisionShape2D2.disabled= true
	$StaticBody2D2/CollisionShape2D.disabled= true
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and not opened:
		opened= true
		$AnimatedSprite2D.play("open")
	
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "open":
			$StaticBody2D2/CollisionShape2D2.disabled= false
			$StaticBody2D2/CollisionShape2D.disabled= false
			$StaticBody2D/CollisionShape2D.disabled= true
