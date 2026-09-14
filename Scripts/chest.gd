extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D=$Marker2D

var opened = false
var item_scene: PackedScene = preload("res://Scenes/item.tscn")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and not opened:
		opened = true
		anim_sprite.play("open")
		await anim_sprite.animation_finished
		spawn_item()
		
func spawn_item():
	var item_instance = item_scene.instantiate()
	item_instance.global_position=spawn_point.global_position
	get_parent().add_child(item_instance)
