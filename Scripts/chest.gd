extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $Marker2D
@onready var area: Area2D = $Area2D

var opened = false

@export var item_scene: PackedScene = preload("res://Scenes/ItemBow.tscn")

func _ready() -> void:
	visible = true
	#area.set_deferred("monitoring", false)
	#$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)

#func appear() -> void:
	#visible = true
	#area.set_deferred("monitoring", true)
	#$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not opened:
		opened = true
		anim_sprite.play("Open")
		await anim_sprite.animation_finished
		spawn_item()
		#show_doors()

func spawn_item() -> void:
	var item_instance = item_scene.instantiate()
	item_instance.global_position = spawn_point.global_position
	get_parent().add_child(item_instance)


#func show_doors() -> void:
	#var doors = get_tree().get_nodes_in_group("Doors")
	#print("Cantidad de puertas encontradas: ", doors.size())
	#for door in doors:
		#print("Puerta encontrada: ", door.name, " - es exit: ", door.is_level_exit)
		#door.appear()
