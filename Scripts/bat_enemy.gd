extends CharacterBody2D

var speed = 25

var health = 3

@onready var player = get_node("/root/Node2D/Player")
@onready var anim = $AnimationPlayer

var shoot_interval = 1.5
var bullet_scene = preload("res://Scenes/enemy_bullet.tscn")

func _ready():
	anim.play("Walk")
	anim.connect("animation_finished", self._on_animation_finished)
	start_shoot_loop()
	

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*speed
	move_and_slide()
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

func take_damage():
	anim.stop()
	anim.play("Hurt")
	health-=1
	if(health<=0):
		queue_free()

func _on_animation_finished(anim_name):
	if anim_name == "Hurt":
		anim.play("Walk")
		

func start_shoot_loop():
	await get_tree().create_timer(shoot_interval).timeout
	spawn_bullet()
	start_shoot_loop()
	
func spawn_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	var dir = global_position.direction_to(player.global_position)
	bullet.direction = dir
	get_parent().add_child(bullet)
