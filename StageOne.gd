extends Node2D

var path = "res://Flat_World.csv"
var counter = 300

func ready():
	$player/HBoxContainer/Time/Current_Time.text = str(counter)
	$player/HBoxContainer/World/Current_World.text = 1-1
	$player/HBoxContainer/Lives/Current_Lives.text = $player.lives
	$player/HBoxContainer/Score/Current_Score.text = $player.score
	$player/HBoxContainer/Coins/Current_Coins.text = $player.coins
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	
func _on_Timer_timeout():
	counter -= 1
	$player/HBoxContainer/Time/Current_Time.text = str(counter)		
