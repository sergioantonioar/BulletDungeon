extends CanvasLayer

@onready var label = $Label

var contador = 0

func _ready() -> void:
	label.text = "Score: %d" % contador

func _add_one():
	contador += 1
	label.text = "Score: %d" % contador
