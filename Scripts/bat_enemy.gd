extends CharacterBody2D

var speed = 25

@onready var player = get_node("/root/Node2D/Player")
@onready var anim = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*speed
	move_and_slide()
	anim.play("Walk")
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		
	
