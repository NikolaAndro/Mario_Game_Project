extends KinematicBody2D
const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -225
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
export var stomp_impulse = 1000.0
var alive = 1
var jump_timer = 0
var sprint_timer = 0
var health_level = 1
var damage = 0  # Invincibility after getting hit

var timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10
	timer.connect("timeout", self, "_timeout")
	
func _timeout():
	get_node("/root/Globals").invincible = 0
	damage = 0
	timer.wait_time = 10
	timer.stop()
	
func _ready():
	#sets initial label values upon start of level
	$HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	$HBoxContainer/World/Current_World.text = get_node("/root/Globals").current_scene
	$HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").lives)
	$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
	$HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").coins)
	
	
	
	get_node("DeathDetector_level_up").set_collision_mask(0)
	get_node("DeathDetector_level_up").set_collision_layer(0)


func _physics_process(delta):
	#lives = get_node("/root/Globals").tile_pos
	#score = get_node("/root/Globals").enemy5_tile_pos
	#$HBoxContainer/Lives/Current_Lives.text = str(lives)
	#$HBoxContainer/Score/Current_Score.text = str(score)
	jump_timer += 1
	if Input.is_action_pressed("ui_right"):
		if 	direction == -1:
			sprint_timer = 0
		direction = 1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = SPEED
			sprint_timer = 0
		elif sprint_timer < 90:
			velocity.x = SPEED + (SPEED*sprint_timer)/90
			sprint_timer += 1
		if(health_level == 1):
			$AnimatedSprite.play("run")
			$LevelUpAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("RUN_level_up")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		$AnimatedSprite.flip_h = false
		$LevelUpAnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		if 	direction == 1:
			sprint_timer = 0
		direction = -1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = -SPEED
			sprint_timer = 0
		elif sprint_timer < 90:
			velocity.x = -SPEED - (SPEED*sprint_timer)/90
			sprint_timer += 1
		$AnimatedSprite.flip_h = true
		$LevelUpAnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		if(health_level == 1):
			$AnimatedSprite.play("run")
			$LevelUpAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("RUN_level_up")
	else:
		velocity.x = 0
		if on_ground:
			if(health_level == 1):
				$AnimatedSprite.play("idle")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("IDLE_level_up")
			
	#jumping 
	if Input.is_action_pressed("ui_up") and jump_timer < 90:
		if Input.is_action_pressed("ui_up") and on_ground:
			var sfx = "jumping_small"
			$AudioStreamPlayer2D.playSound(sfx)
		velocity.y = JUMP_POWER - (jump_timer*JUMP_POWER)/90
		on_ground = false
		jump_timer += 1
	elif on_ground == false:
		jump_timer = 90
	else:
		jump_timer = 0

	#fireball
	if Input.is_action_just_pressed("ui_down"):
		var sfx = "fireball"
		$AudioStreamPlayer2D.playSound(sfx)
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		if direction == 1:
			fireball.position = $Position2D.global_position
		else:
			fireball.position.x = $Position2D.global_position.x - 10
			fireball.position.y = $Position2D.global_position.y
	velocity.y += GRAVITY 

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			if(health_level == 1):
				$AnimatedSprite.play("jump")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("JUMP_level_up")
		else:
			if(health_level == 1):
				$AnimatedSprite.play("fall")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("FALL_level_up")
			
	if position.y > 240:
		get_node("BodyCol").disabled = true
		queue_free()
		if get_node("/root/Globals").lives > 0:
			get_node("/root/Globals").lives -=1
			get_tree().reload_current_scene()
		else:
			get_node("/root/Globals").lives = 3
			get_tree().change_scene("GameOver.tscn")
			
		
	velocity = move_and_slide(velocity, FLOOR)
	
	#code to deal with block-player interactions
	var tile_id # position of tile
	var collision #collision info
	var tile_name #the name of the tile within the tile set
	var new_id #block changes based on case
	var item #if there is an item associated with a case, item type is stored here
	var item_tile_pos #position of the item
	var item_collision 
	
	if on_ground == false:
		get_node("/root/Globals").tile_pos = Vector2(0,0)
	
	#iterate over list of collisions that happen at each frame
	for i in range(get_slide_count()):
		collision = get_slide_collision(i) #info about collision is stored in collision var
					
		#check to make sure player is colliding with a tile from tile map
		if collision.collider is TileMap:
			get_node("/root/Globals").tile_pos = collision.collider.world_to_map(position)
			get_node("/root/Globals").tile_pos -= collision.normal
			tile_id = collision.collider.get_cellv(get_node("/root/Globals").tile_pos)
			tile_name = collision.collider.tile_set.tile_get_name(tile_id)
			
			#if some enemy is colliding with the same block kill the enemy
			#for each case below, all applicable labels and counters must be updated
			#additionally, sound effects (sfx) will be played on a separate audio channel than the background music
			
			if(tile_name == "Sprite" and Input.is_action_pressed("ui_up")): #? block - coin
				get_node("/root/Globals").coins += 1
				get_node("/root/Globals").score += 200
				if(get_node("/root/Globals").coins == 100):
					get_node("/root/Globals").coins = 0
					get_node("/root/Globals").lives += 1
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").lives)
				$HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").coins)
				$HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").lives)
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "coin"
				$AudioStreamPlayer2D.playSound(sfx)
				yield(get_tree().create_timer(0.25), "timeout")
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item)
			
			
				
			if(tile_name == "Sprite12"): # coin
				get_node("/root/Globals").coins += 1
				get_node("/root/Globals").score += 200
				if(get_node("/root/Globals").coins== 100):
					get_node("/root/Globals").coins = 0
					get_node("/root/Globals").lives += 1
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				$HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").coins)
				$HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").lives)
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "coin"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite15"): #1up
				get_node("/root/Globals").lives += 1
				get_node("/root/Globals").score += 1000
				$HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").lives)
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "one_up"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite14"): # PowerUp
				get_node("/root/Globals").score += 1000
				if health_level == 1:
					get_node("BodyCol").scale.x = 1
					get_node("BodyCol").scale.y = 1
					health_level += 1
				get_node("DeathDetector").set_collision_mask(0)
				get_node("DeathDetector").set_collision_layer(0)
				get_node("DeathDetector_level_up").set_collision_mask(3)
				get_node("DeathDetector_level_up").set_collision_layer(3)
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("IDLE_level_up")
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "powerup"
				$AudioStreamPlayer2D.playSound(sfx)
				
				#TODO: setup functionality for power-up
				
			if(tile_name == "Sprite18"): #star
				get_node("/root/Globals").score += 1000
				get_node("/root/Globals").invincible = 1
				timer.start()
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				#star music is longer than sfx, so background music is paused 
				#current position of background music must be stored so it can be resumed
				#after star music is done playing
				var temp = MusicController.get_playback_position()
				MusicController.stop()
				MusicController.play("res://music/star.wav")
				#this timer is to ensure that all star music plays
				yield(get_tree().create_timer(12), "timeout") 
				MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
				MusicController.seek(temp)
				
				#TODO: setup functionality for star
				
			if(tile_name == "Sprite6" and Input.is_action_pressed("ui_up")): #brick
				get_node("/root/Globals").score += 50
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				new_id = collision.collider.tile_set.find_tile_by_name("blank_tile") #block is set to empty
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				var sfx = "break_block"
				$AudioStreamPlayer2D.playSound(sfx)

			if(tile_name == "Sprite20"): # flag middle
				var sfx = "flagpole"
				$AudioStreamPlayer2D.playSound(sfx)
				get_node("/root/Globals").score += 500
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				get_node("BodyCol").disabled = true
				#yield(get_tree().create_timer(5), "timeout")
				get_tree().change_scene("TitleScreen.tscn")

			if(tile_name == "Sprite22"): # flag top
				var sfx = "flagpole"
				$AudioStreamPlayer2D.playSound(sfx)
				get_node("/root/Globals").score += 1000
				$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
				get_node("BodyCol").disabled = true
				get_tree().change_scene("TitleScreen.tscn")

			if(tile_name == "Sprite23" and Input.is_action_pressed("ui_up")): #? block - PowerUp
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite24" and Input.is_action_pressed("ui_up")): #? block - star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite25" and Input.is_action_pressed("ui_up")): #? block - 1up 
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up")):  #multi-coin box
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite34")
				tile_name = "Sprite34"
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				var time_left = 10
				while(time_left > 0):
					if(tile_name == "Sprite34" and Input.is_action_pressed("ui_up")):
						get_node("/root/Globals").coins += 1
						get_node("/root/Globals").score += 200
						if(get_node("/root/Globals").coins == 100):
							get_node("/root/Globals").coins = 0
							get_node("/root/Globals").lives += 1
						$HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").score)
						$HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").coins)
						$HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").lives)
						item = collision.collider.tile_set.find_tile_by_name("Sprite12")
						item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
						collision.collider.set_cellv(item_tile_pos, item)
						var sfx = "coin"
						$AudioStreamPlayer2D.playSound(sfx)
						yield(get_tree().create_timer(0.25), "timeout")
						item = collision.collider.tile_set.find_tile_by_name("blank_tile")
						collision.collider.set_cellv(item_tile_pos, item)
					yield(get_tree().create_timer(1), "timeout")
					time_left -= 1
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				
			if(tile_name == "Sprite27" and Input.is_action_pressed("ui_up")):  #brick - power-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
#				
			if(tile_name == "Sprite28" and Input.is_action_pressed("ui_up")):  #brick - 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite29" and Input.is_action_pressed("ui_up")):  # brick -star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
				#TODO: setup functionality for star
				
			if(tile_name == "Sprite30" and Input.is_action_pressed("ui_up")): #hidden power up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
				#TODO: setup functionality for power-up
				
			if(tile_name == "Sprite31" and Input.is_action_pressed("ui_up")):  #hidden 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite32" and Input.is_action_pressed("ui_up")):  #hidden star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
				#TODO: setup functionality for star

func _on_StepDetector_area_entered(area):
	if "StompDetector" in area.name:
		velocity.y = JUMP_POWER


func _on_DeathDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if damage == 0:
			if health_level == 1:
				if "fireball" in area.name:
					on_ground = on_ground
				else:
					if area.global_position.y > get_node("DeathDetector").global_position.y:
						return
					health_level -=1
					get_node("BodyCol").disabled = true
					MusicController.stop()
					$AnimatedSprite.play("death")
					var sfx = "mario_dies"
					$AudioStreamPlayer2D.playSound(sfx)
					yield(get_tree().create_timer(3.0), "timeout")
					if get_node("/root/Globals").lives > 0:
						get_tree().reload_current_scene()
						get_node("/root/Globals").lives -=1 
					else:
						get_tree().change_scene("res://GameOver.tscn")
						get_node("/root/Globals").lives = 3
					
					
				
	
			
		
		
		#get_tree().reload_current_scene()



func _on_DeathDetector_level_up_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
			if health_level == 2:
				if "fireball" in area.name:
					on_ground = on_ground
				else:
					damage = 1
					timer.wait_time = 16
					timer.start()
					if area.global_position.y > get_node("DeathDetector").global_position.y:
						return
					get_node("BodyCol").scale.x = 0.863
					get_node("BodyCol").scale.y = 0.753
