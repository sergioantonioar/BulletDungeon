extends CharacterBody2D

var speed = 25
var health = 3
@onready var player = get_node("/root/Level1/Player")
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("Walk")
	anim.connect("animation_finished", self._on_animation_finished)

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity=direction*speed
	move_and_slide()

	if velocity.x < 0:
		$Sprite2D.flip_h=true
	elif velocity.x > 0:
		$Sprite2D.flip_h=false

func take_damage():
	anim.stop()
	anim.play("Hurt")
	health-=1
	if(health<=0):
		queue_free()

func _on_animation_finished(anim_name):
	if anim_name=="Hurt":
		anim.play("Fly")
