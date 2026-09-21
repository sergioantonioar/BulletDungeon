extends Node2D

var opened = false
@export var is_level_exit: bool = false
@export var tilemap: TileMapLayer
@export var wall_cells: Array[Vector2i] = []

func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$StaticBody2D2/CollisionShape2D.disabled=true
	$StaticBody2D2/CollisionShape2D2.disabled=true
	if is_level_exit:
		visible = false
		$Area2D.set_deferred("monitoring", false)
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)


func appear() -> void:
	visible = true
	$Area2D.set_deferred("monitoring", true)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)


func _on_area_2d_body_entered(body):
	print("Body entered: ", body.name, " grupos: ", body.get_groups())
	if body.is_in_group("Player") and not opened:
		opened=true
		$AnimatedSprite2D.play("Open")

func _on_animation_finished():
	if $AnimatedSprite2D.animation=="Open":
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		$StaticBody2D2/CollisionShape2D.disabled=false
		$StaticBody2D2/CollisionShape2D2.disabled=false
		open_wall()
		if is_level_exit:
			load_next_level()
			
func open_wall() -> void:
	if tilemap:
		for cell in wall_cells:
			tilemap.erase_cell(cell)
			
func load_next_level() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	var regex = RegEx.new()
	regex.compile("Level(\\d+)\\.tscn")
	var result = regex.search(current_scene_file)
	if result:
		var current_level_number = int(result.get_string(1))
		var next_level_path = "res://Scenes/Level%d.tscn" % (current_level_number + 1)
		if ResourceLoader.exists(next_level_path):
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("¡No hay más niveles, terminaste el juego!")
