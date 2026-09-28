extends Node2D

#@onready var chest = $Chest
@export var chest_room_spawner: Area2D
@export var exit_door: Node2D

#var spawners_cleared = 0
#var total_spawners = 0

func _ready() -> void:
	#var spawners = get_tree().get_nodes_in_group("spawners")
	#total_spawners = spawners.size()
	#for spawner in spawners:
	if chest_room_spawner:
		chest_room_spawner.spawner_cleared.connect(_on_chest_room_cleared)
		#spawner.spawner_cleared.connect(_on_spawner_cleared)

func _on_chest_room_cleared() -> void:
	print("Cuarto del cofre completado")
	exit_door.appear()
	#spawners_cleared += 1
	#if spawners_cleared >= total_spawners:
		#chest.appear()
