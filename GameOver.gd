extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
	$MarginContainer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").coins)
	$MarginContainer/HBoxContainer/World/Current_World.text = get_node("/root/Globals").current_scene
	$MarginContainer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	var sfx = "game_over"
	$AudioStreamPlayer2D.playSound(sfx)
	yield(get_tree().create_timer(6.0), "timeout")
	get_tree().change_scene("res://TitleScreen.tscn")
