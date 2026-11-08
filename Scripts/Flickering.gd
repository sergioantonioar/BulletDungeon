extends PointLight2D

@export var base_energy: float = 1.1
@export var variation: float = 0.4
@export var speed:float = 3
@export var color_bright:=Color(1.0,0.88,0.5)
@export var color_dim:=Color(1.0,0.5,0.2)

var noise:= FastNoiseLite.new()
var time:=0.0

func _ready() -> void:
	noise.frequency=1.0
	noise.seed=randi()
	time=randf()*1000.0

func _process(delta: float) -> void:
	time+=delta*speed
	var n:= clampf(noise.get_noise_1d(time)*2.0,-1.0,1.0)
	energy=base_energy+n*variation
	color=color_dim.lerp(color_bright,inverse_lerp(-1.0,1.0,n))
