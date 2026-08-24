extends Node2D

func shoot():
	const Bullet=preload("res://Scenes/Bullet.tscn")
	var new_bullet=Bullet.instantiate()
	new_bullet.global_position=$Sprite2D/ShootPoint.global_position
	new_bullet.global_rotation=$Sprite2D/ShootPoint.global_rotation
	get_tree().current_scene.add_child(new_bullet)

func _physics_process(delta):
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos-global_position).angle()
		rotation=direction
			
		if Input.is_action_just_pressed("shoot"):
			$AnimationPlayer.play("shoot")
			shoot()
