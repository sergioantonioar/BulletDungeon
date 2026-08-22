extends CharacterBody2D

var speed=125

@onready var anim= $AnimationPlayer

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity=direction*speed
	move_and_slide()
	
	if direction.length() > 0:
		anim.play("Walk")
	else:
		anim.play("Idle")
