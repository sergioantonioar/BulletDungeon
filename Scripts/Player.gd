extends CharacterBody2D

var speed=125
var health=100
@onready var  anim=$AnimationPlayer

var is_hurt = false

func _ready():
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta):
	update_health_bar()
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity=direction*speed
	move_and_slide()
	if(is_hurt==false):	
		if direction.length()>0:
			anim.play("Walk")
		else:
			anim.play("Idle")
		
	var mouse_pos=get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		$Sprite2D.flip_h=true
	else:
		$Sprite2D.flip_h=false
	
	var overlapping_enemies=$HurtZone.get_overlapping_bodies()
	for enemy in overlapping_enemies:
		if enemy.is_in_group("Enemies"):
			take_damage(1)
			break
			
func take_damage(amount):
	if is_hurt:
		return
	health-=amount
	print("Jugador recibe daño, salud ahora:", health)
	is_hurt=true
	anim.play("Hurt")
	if(health<=0):
			die()
			
func die():
	print("Jugador muerto, reiniciamos el nivel")
	get_tree().reload_current_scene()
	
func _on_animation_finished(anim_name):
	if anim_name=="Hurt":
		is_hurt=false
	
func update_health_bar():
	$ProgressBar.value=health
	var fill_style=$ProgressBar.get("theme_override_styles/fill") as StyleBoxFlat
	
	if health < 20:
		fill_style.bg_color=Color.RED
	elif health < 50:
		fill_style.bg_color=Color.YELLOW
	else:
		fill_style.bg_color=Color.GREEN
