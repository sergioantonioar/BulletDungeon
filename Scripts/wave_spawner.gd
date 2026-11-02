extends Area2D
## Encuentro por oleadas. Se activa UNA sola vez cuando el jugador entra en el area.
##
## Estructura (ver Scenes/Level2Waves.tscn):
##   WaveSpawner (Area2D + este script)
##   |- CollisionPolygon2D       -> zona que activa el encuentro
##   |- Wave1 (Node2D)           -> cada hijo cuyo nombre empieza con "Wave" es una oleada
##   |   |- SpawnPoint (Marker2D + spawn_point.gd) -> posicion + enemy_scene
##   |- Wave2 ...
##
## La oleada siguiente sale cuando mueren todos los enemigos de la anterior.
## Emite spawner_cleared (mismo nombre que spawner.gd) al terminar la ultima.

signal spawner_cleared
signal wave_started(index: int)

enum Phase { WAITING, COUNTDOWN, ACTIVE, DONE }

@export var delay_first_wave: float = 1.5
@export var delay_between_waves: float = 2.0

var phase: Phase = Phase.WAITING
var cleared: bool = false

var _waves: Array = []
var _wave_index: int = -1
var _alive: int = 0
var _timer: float = 0.0


func _ready() -> void:
	for child in get_children():
		if child is Node2D and String(child.name).begins_with("Wave"):
			_waves.append(child)
	body_entered.connect(_on_body_entered)
	set_process(false)


func _on_body_entered(body: Node2D) -> void:
	if phase != Phase.WAITING or not body.is_in_group("Player"):
		return
	if _waves.is_empty():
		return
	phase = Phase.COUNTDOWN
	_timer = delay_first_wave
	set_process(true)


func _process(delta: float) -> void:
	match phase:
		Phase.COUNTDOWN:
			_timer -= delta
			if _timer <= 0.0:
				_spawn_next_wave()
		Phase.ACTIVE:
			if _alive <= 0:
				if _wave_index + 1 < _waves.size():
					phase = Phase.COUNTDOWN
					_timer = delay_between_waves
				else:
					phase = Phase.DONE
					cleared = true
					set_process(false)
					spawner_cleared.emit()


func _spawn_next_wave() -> void:
	_wave_index += 1
	var wave: Node2D = _waves[_wave_index]
	var level := get_tree().current_scene
	for point in wave.get_children():
		var scene: PackedScene = point.get("enemy_scene")
		if scene == null:
			continue
		var enemy := scene.instantiate() as Node2D
		# Hijo del nivel (no del spawner) para que el y-sort funcione igual que con el jugador
		level.add_child(enemy)
		enemy.global_position = (point as Node2D).global_position
		if not enemy.is_in_group("Enemies"):
			enemy.add_to_group("Enemies")
		if enemy.has_signal("enemy_died"):
			enemy.connect("enemy_died", _on_enemy_died)
		_alive += 1
		# Aparicion suave
		enemy.modulate.a = 0.0
		create_tween().tween_property(enemy, "modulate:a", 1.0, 0.4)
	phase = Phase.ACTIVE
	wave_started.emit(_wave_index)


func _on_enemy_died() -> void:
	_alive = maxi(_alive - 1, 0)
