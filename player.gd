extends KinematicBody2D
const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
var lives = 3
var score = 0
var coins = 0
var counter = 300
export var stomp_impulse = 1000.0

func _ready():
	$HBoxContainer/Time/Current_Time.text = str(counter)
	$HBoxContainer/World/Current_World.text = "1-1"
	$HBoxContainer/Lives/Current_Lives.text = str(lives)
	$HBoxContainer/Score/Current_Score.text = str(score)
	$HBoxContainer/Coins/Current_Coins.text = str(coins)
	
func _on_Timer_timeout():
	counter -= 1
	$HBoxContainer/Time/Current_Time.text = str(counter)

var timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.25
	timer.connect("timeout", self, "_timeout")
	
func _timeout():
	if Input.is_action_pressed("ui_up"):
		velocity.y = JUMP_POWER
		timer.stop()
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		velocity.x = SPEED * 2
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED * 2
	
func _physics_process(delta):
	
	
	if Input.is_action_pressed("ui_right"):
		direction = 1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = SPEED
		$AnimatedSprite.play("run")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):	
		direction = -1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		$AnimatedSprite.play("run")
	else:
		velocity.x = 0
		if on_ground:
			$AnimatedSprite.play("idle")
	#jumping 
	if Input.is_action_just_pressed("ui_up") and on_ground:
		velocity.y = JUMP_POWER
		on_ground = false
		timer.start()
	
	#fireball
	if Input.is_action_just_pressed("ui_down"):
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
		timer.start()
	velocity.y += GRAVITY 

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
			
	velocity = move_and_slide(velocity, FLOOR)
	
	#code to deal with block-player interactions
	var tile_id
	var tile_pos
	var collision
	var tile_name
	var new_id
	var item
	var item_tile_pos
	var item_collision
	for i in range(get_slide_count()):
		collision = get_slide_collision(i)
		if collision.collider is TileMap:
			tile_pos = collision.collider.world_to_map(position)
			tile_pos -= collision.normal
			tile_id = collision.collider.get_cellv(tile_pos)
			tile_name = collision.collider.tile_set.tile_get_name(tile_id)
			
			if(tile_name == "Sprite" and Input.is_action_pressed("ui_up")): #? block
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite12"): # coin
				coins += 1
				score += 200
				if(coins == 100):
					coins = 0
					lives += 1
				$HBoxContainer/Score/Current_Score.text = str(score)
				$HBoxContainer/Coins/Current_Coins.text = str(coins)
				$HBoxContainer/Lives/Current_Lives.text = str(lives)
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				
			if(tile_name == "Sprite15"): #1up
				lives += 1
				score += 1000
				$HBoxContainer/Lives/Current_Lives.text = str(lives)
				$HBoxContainer/Score/Current_Score.text = str(score)
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				
			if(tile_name == "Sprite14"): # PowerUp
				score += 1000
				$HBoxContainer/Score/Current_Score.text = str(score)
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				
				#TODO: setup functionality for power-up
				
			if(tile_name == "Sprite18"): #star
				score += 1000
				$HBoxContainer/Score/Current_Score.text = str(score)
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				
				#TODO: setup functionality for star
				
			if(tile_name == "Sprite6" and Input.is_action_pressed("ui_up")): #brick
				score += 50
				$HBoxContainer/Score/Current_Score.text = str(score)
				new_id = collision.collider.tile_set.find_tile_by_name("blank_tile") #block is set to empty
				collision.collider.set_cellv(tile_pos, new_id)
				
				
			if(tile_name == "Sprite23" and Input.is_action_pressed("ui_up")): #? block - PowerUp
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite24" and Input.is_action_pressed("ui_up")): #? block - star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite25" and Input.is_action_pressed("ui_up")): #? block - 1up 
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up")):  #multi-coin box
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
				#TODO: Add multi-coin box functionality
				
			if(tile_name == "Sprite27" and Input.is_action_pressed("ui_up")):  #brick - power-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite28" and Input.is_action_pressed("ui_up")):  #brick - 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite29" and Input.is_action_pressed("ui_up")):  # brick -star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite30" and Input.is_action_pressed("ui_up")): #hidden power up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
				#TODO: setup functionality for power-up
				
			if(tile_name == "Sprite31" and Input.is_action_pressed("ui_up")):  #hidden 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				
			if(tile_name == "Sprite32" and Input.is_action_pressed("ui_up")):  #hidden star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(tile_pos.x, tile_pos.y -1)
				collision.collider.set_cellv(tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
					
				#TODO: setup functionality for star

func _on_StepDetector_area_entered(area):
	if "fireball" in area.name:
		on_ground = on_ground
	else:
		velocity.y = JUMP_POWER


func _on_DeathDetector_area_entered(area):
	if "fireball" in area.name:
		on_ground = on_ground
	else:
		if area.global_position.y > get_node("DeathDetector").global_position.y:
			return
		get_node("BodyCol").disabled = true
		queue_free()
