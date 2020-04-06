extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()
	$MarginContainer/VBoxContainer/Quit.grab_focus()

	
func _physics_process(delta):
	if $MarginContainer/VBoxContainer/Play.is_hovered() == true:
		$MarginContainer/VBoxContainer/Play.grab_focus()
	if $MarginContainer/VBoxContainer/Quit.is_hovered() == true:
		$MarginContainer/VBoxContainer/Quit.grab_focus()
	
