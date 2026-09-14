extends Area2D

@export var enemy_scenes: Array[PackedScene]=[]
@export var spawn_interval: float= 2.0
@export var max_total_spawned : int = 10


var total_spawned = 0
var polygon : PackedVector2Array
var triangles : PackedInt32Array
var enemies_alive = 0

func _ready():
	polygon= $CollisionPolygon2D.polygon
	triangles = Geometry2D.triangulate_polygon(polygon)
	var existing_enemies = get_tree().get_nodes_in_group("Enemies")
	for e in existing_enemies:
		e.connect("enemy_died", Callable(self, "_on_enemy_died"))
		enemies_alive+=1
	spawn_loop()
	
func spawn_loop():
	await get_tree().create_timer(spawn_interval).timeout
	
	if total_spawned < max_total_spawned:
		spawn_enemy()
		total_spawned+=1
		enemies_alive+=1
		spawn_loop()
		

func spawn_enemy():
	var enemy_scene= enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()
	enemy.position = get_random_point_in_polygon()
	enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
	get_parent().add_child(enemy)
	
func get_random_point_in_polygon() -> Vector2:
	@warning_ignore("integer_division")
	var tri_index= (randi() % (triangles.size() / 3)) * 3
	
	var i1 = triangles[tri_index]
	var i2 = triangles[tri_index+1]
	var i3 = triangles[tri_index+2]
	
	var p1 = polygon[i1]
	var p2 = polygon[i2]
	var p3 = polygon[i3]
	
	var r1 = sqrt(randf())
	var r2 = randf()
	var point= (1 - r1) * p1 + (r1 * (1 - r2)) * p2 + (r1 * r2) * p3
	return $CollisionPolygon2D.to_global(point)
	
	
func _on_enemy_died():
	enemies_alive -= 1
	print(enemies_alive)
	if(enemies_alive <= 0 and total_spawned >= max_total_spawned):
		load_next_level()
			
func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() +1
	var next_level_path = "res://Scenes/Level" + str(next_level_number)+".tscn"
	if ResourceLoader.exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("!No hay más niveles, terminaste el juego!")
	
