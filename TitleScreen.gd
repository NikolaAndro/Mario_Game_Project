extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()
	$MarginContainer/VBoxContainer/Quit.grab_focus()

#If user hovers over the play or Quit button, the pointer will indicate that
#on the screen	
func _physics_process(delta):
	if $MarginContainer/VBoxContainer/Play.is_hovered() == true:
		$MarginContainer/VBoxContainer/Play.grab_focus()
	if $MarginContainer/VBoxContainer/Quit.is_hovered() == true:
		$MarginContainer/VBoxContainer/Quit.grab_focus()
	
#When Play pressed, the scene will change and game will start
func _on_Play_pressed():
	get_node("/root/Globals").current_scene = "1-1"
	get_node("/root/Globals").counter = 300
	get_tree().change_scene("res://StageOne.tscn")

#Exiting the game if quit pressed
func _on_Quit_pressed():
	get_tree().quit()
