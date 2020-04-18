extends Popup

var selected_menu

func change_menu_color(selected_menu):
	$Resume.color = Color.gray
	$Restart.color = Color.gray
	$Quit.color = Color.gray
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$Restart.color = Color.greenyellow
		2:
			$Quit.color = Color.greenyellow


func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			get_tree().paused = true
			selected_menu = 0
			change_menu_color(selected_menu)
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color(selected_menu)
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color(selected_menu)
		elif Input.is_action_just_pressed("enter"):
			match selected_menu:
				0:
					get_tree().paused = false
					hide()
				1:
					#Save game
					get_tree().paused = false
				2:
					# Quit game
					get_tree().paused = false
					get_tree().change_scene("res://TitleScreen.tscn")
	
