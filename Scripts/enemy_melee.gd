extends CharacterBody2D

signal enemy_died

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }

@export_group("Stats")
@export var max_health: int = 3
@export var speed: float = 30.0
@export var attack_damage: int = 3
@export var attack_cooldown: float = 1.2
@export var knockback_force: float = 70.0
@export var hurt_stun: float = 0.2

@export_group("Comportamiento")
@export var detection_range: float = 200.0
@export var attack_range: float = 22.0
@export var attack_hit_frame: int = 6

var health: int
var state: State = State.IDLE
var player: Node2D

var _cooldown: float = 0.0
var _hit_done: bool = false
var _stun_left: float = 0.0
var _knockback: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_shape: CollisionShape2D = $CollisionShape2D

@onready var attack_sound: AudioStreamPlayer2D = get_node_or_null("AttackSound")

func _ready() -> void:
	health = max_health
	if not is_in_group("Enemies"):
		add_to_group("Enemies")
	player = get_tree().get_first_node_in_group("Player") as Node2D
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.frame_changed.connect(_on_frame_changed)
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_cooldown = maxf(_cooldown - delta, 0.0)

	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player") as Node2D
		if player == null:
			return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			if dist <= detection_range:
				state = State.CHASE
		State.CHASE:
			_face(to_player.x)
			if dist <= attack_range and _cooldown <= 0.0:
				_start_attack()
			elif dist > attack_range * 0.7:
				velocity = to_player.normalized() * speed
				_play("move")
			else:
				velocity = Vector2.ZERO
				_play("idle")
		State.ATTACK:
			velocity = Vector2.ZERO
		State.HURT:
			_stun_left -= delta
			velocity = _knockback
			_knockback = _knockback.move_toward(Vector2.ZERO, 600.0 * delta)
			if _stun_left <= 0.0:
				state = State.CHASE

	move_and_slide()


func take_damage(amount: int = 1) -> void:
	if state == State.DEAD:
		return
	health -= amount
	_flash()
	if health <= 0:
		_die()
		return
	if state == State.ATTACK:
		return
	if is_instance_valid(player):
		_knockback = player.global_position.direction_to(global_position) * knockback_force
	state = State.HURT
	_stun_left = hurt_stun
	sprite.play("hurt")


func _start_attack() -> void:
	state = State.ATTACK
	_hit_done = false
	velocity = Vector2.ZERO
	sprite.play("attack")
	
	if attack_sound:
		attack_sound.play()


func _die() -> void:
	state = State.DEAD
	velocity = Vector2.ZERO
	remove_from_group("Enemies")
	body_shape.set_deferred("disabled", true)

	var scene := get_tree().current_scene
	if scene:
		var score := scene.get_node_or_null("Score")
		if score and score.has_method("_add_one"):
			score._add_one()
	enemy_died.emit()
	sprite.play("death")


func _flash() -> void:
	sprite.modulate = Color(1.0, 0.45, 0.45)
	var tw := create_tween()
	tw.tween_property(sprite, "modulate", Color.WHITE, 0.15)


func _face(dir_x: float) -> void:
	if absf(dir_x) > 0.01:
		sprite.flip_h = dir_x < 0.0


func _play(anim: StringName) -> void:
	if sprite.animation != anim or not sprite.is_playing():
		sprite.play(anim)


func _on_frame_changed() -> void:
	if state != State.ATTACK or sprite.animation != &"attack" or _hit_done:
		return
	if sprite.frame >= attack_hit_frame:
		_hit_done = true
		if is_instance_valid(player) and global_position.distance_to(player.global_position) <= attack_range * 1.5:
			if player.has_method("take_damage"):
				player.take_damage(attack_damage)


func _on_animation_finished() -> void:
	match sprite.animation:
		&"attack":
			_cooldown = attack_cooldown
			state = State.CHASE
		&"death":
			queue_free()
