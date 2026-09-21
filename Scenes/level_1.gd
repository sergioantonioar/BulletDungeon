extends Node2D

@onready var chest = $Chest

var spawners_cleared = 0
var total_spawners = 0

func _ready() -> void:
	var spawners = get_tree().get_nodes_in_group("spawners")
	total_spawners = spawners.size()
	for spawner in spawners:
		spawner.spawner_cleared.connect(_on_spawner_cleared)

func _on_spawner_cleared() -> void:
	spawners_cleared += 1
	if spawners_cleared >= total_spawners:
		chest.appear()
