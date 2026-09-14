extends Area2D

var speed = 200
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position+=direction*speed*delta


func _on_body_entered(body):
	if body.is_in_group("Walls"):
		_explosion()

func _explosion():
	var explosion = preload("res://Scenes/EnemyExplosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		_explosion()
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(1)
