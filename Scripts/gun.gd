extends Node2D

enum WeaponType { GUN, BOW }

@export var weapon_type: WeaponType = WeaponType.GUN
@export var projectile_scene: PackedScene


func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = $Sprite2D/ShootPoint.global_position
	projectile.global_rotation = $Sprite2D/ShootPoint.global_rotation
	get_tree().current_scene.add_child(projectile)


func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).angle()
	rotation = direction

	if Input.is_action_just_pressed("shoot"):

		# Reproducir sonido según el arma
		match weapon_type:
			WeaponType.GUN:
				AudioManager.play_shoot_sound()

			WeaponType.BOW:
				AudioManager.play_shoot_bow_sound()

		$AnimationPlayer.play("Shoot")
		shoot()
