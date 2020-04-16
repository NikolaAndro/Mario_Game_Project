extends Node2D

#Playing the Mario Background Music
func _ready():
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")

#Stop the music when the level ends
func _on_StageOne_tree_exited():
	MusicController.stop()
