extends Node2D

func _ready() -> void:
	play_music()
	
func play_music():
	$Music.play()

func stop_music():
	$Music.stop()

func play_shoot_sound():
	$Shoot.play()

func play_shoot_bow_sound():
	$Bow.play()
