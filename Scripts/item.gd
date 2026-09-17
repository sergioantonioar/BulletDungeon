extends Area2D


@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("Spawn")
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: StringName):
	if anim_name=="Spawn":
		anim_player.play("Fly")



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var weapon_manager= area.get_parent().get_node("WeaponManager")
		if weapon_manager:
			weapon_manager.pickup_weapon_by_name("Bow")
		queue_free()
