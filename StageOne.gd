extends Node2D

var path = "res://Flat_World.csv"
var counter = 300

func _ready():
	$player/VBoxContainer/Current_Time.text = str(counter)
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	
func _on_Timer_timeout():
	counter -= 1
	$player/VBoxContainer/Current_Time.text = str(counter)		

