extends Node2D

onready var map = get_node("mario_tiles")

func _ready():
	#Playing the Mario Background Music
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	#Represents the end of the level for camara purposes
	var right_limit =  calculate_x_bounds() -3 #calculates right bound plus 3 tiles of error
	get_node("player/Camera2D").limit_right = right_limit * 16 #adjusts camera window based on calculated bound
	#the bound is multiplied by 16 because of block width in pixels
	
#Stop the music when the level ends
func _on_StageOne_tree_exited():
	MusicController.stop()

#calculates how wide the level is
func calculate_x_bounds():
	var used_cells = map.get_used_cells()
	var max_x = 0
	var min_x = 0
	for position in used_cells:
		if position.x < min_x:
			min_x = int(position.x)
		elif position.x > max_x:
			max_x = int(position.x)
	return(max_x)
			
#calculates how tall the level is
func calculate_y_bounds():
	var used_cells = map.get_used_cells()
	var max_y = 0
	var min_y = 0
	for position in used_cells:
		if position.y < min_y:
			min_y = int(position.y)
		elif position.y > max_y: 
			max_y = int(position.y)
	return(max_y)
