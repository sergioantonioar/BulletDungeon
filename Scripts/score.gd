extends CanvasLayer

@onready var label = $Label

var contador = 0

func _ready() -> void:
	contador = GameState.score
	label.text = "Score: %d" % contador

func _add_one():
	contador += 1
	GameState.score = contador
	label.text = "Score: %d" % contador
