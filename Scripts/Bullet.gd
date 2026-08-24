extends Area2D

var speed=200

func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()
	
func _physics_process(delta):
	var direction=Vector2.RIGHT.rotated(rotation)
	position+=direction*speed*delta

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		_explosion()
		if body.has_method("take_damage"):
			body.take_damage()
			
	elif body.is_in_group("Walls"):
		_explosion()
		
func _explosion():
	var explosion=preload("res://Scenes/ExplosionBullet.tscn").instantiate()
	explosion.global_position=global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()
