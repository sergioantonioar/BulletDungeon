extends Node2D

var weapons = []
var owned_weapons = []
var current_weapon_index = 0

@onready var ui_weapon = $CanvasLayer


func _ready():
	weapons = [$Gun, $Bow]

	# Restaurar armas obtenidas previamente desde GameState
	owned_weapons.clear()
	for weapon in weapons:
		if weapon.name in GameState.owned_weapon_names:
			owned_weapons.append(weapon)

	if owned_weapons.is_empty():
		owned_weapons.append(weapons[0])

	current_weapon_index = clamp(GameState.current_weapon_index, 0, owned_weapons.size() - 1)

	for weapon in weapons:
		set_weapon_enabled(weapon, weapon == owned_weapons[current_weapon_index])

	update_weapon_ui()


func set_weapon_enabled(weapon, enabled):
	weapon.visible = enabled
	weapon.set_process(enabled)
	weapon.set_physics_process(enabled)


func update_weapon_ui():
	var current_name = owned_weapons[current_weapon_index].name
	
	ui_weapon.change_weapon(current_name)


func equip_weapon(delta):
	if owned_weapons.size() <= 1:
		return

	set_weapon_enabled(
		owned_weapons[current_weapon_index],
		false
	)

	current_weapon_index = (
		current_weapon_index + delta + owned_weapons.size()
	) % owned_weapons.size()

	set_weapon_enabled(
		owned_weapons[current_weapon_index],
		true
	)

	GameState.current_weapon_index = current_weapon_index

	update_weapon_ui()


func pickup_weapon_by_name(_weapon_name):
	for weapon in get_children():
		if weapon.name == _weapon_name:
			if weapon not in owned_weapons:
				owned_weapons.append(weapon)
				set_weapon_enabled(weapon, false)
				if not GameState.owned_weapon_names.has(weapon.name):
					GameState.owned_weapon_names.append(weapon.name)
			return


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			equip_weapon(-1)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			equip_weapon(1)
