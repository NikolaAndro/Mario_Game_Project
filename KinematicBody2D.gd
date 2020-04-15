extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const ENEMYATTACK = preload("res://enemyAttack.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
var attack = 0
var falling = 0

func _ready():
	set_position(Vector2(400,150))

func _physics_process(delta):
	attack += 1
	velocity.x = SPEED*direction
	$AnimatedSprite.play("run")
	velocity.y += GRAVITY
	if falling >= 60:
		if !is_on_floor():
			if direction == 1:
				$AnimatedSprite.flip_h = false
				position.x -= 1
			else:
				$AnimatedSprite.flip_h = true
				position.x += 1
				direction *= -1
		else:
			falling += 1 
			
	if attack == 80:
		var enemyAttack = ENEMYATTACK.instance()
		if direction == 1:
			enemyAttack.set_enemyAttack_direction(1)
		else:
			enemyAttack.set_enemyAttack_direction(-1)
		get_parent().add_child(enemyAttack)
		enemyAttack.position = $Position2D.global_position
		attack = 0
	 

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
		
	velocity = move_and_slide(velocity, FLOOR)
	
	#Collision with blocks
	var tile_id
	var collision
	var tile_name
	var new_id
	var item
	var item_tile_pos
	var item_collision

	for i in range(get_slide_count()):
		collision = get_slide_collision(i)
					
		if collision.collider is TileMap:
			get_node("/root/Globals").enemy4_tile_pos = collision.collider.world_to_map(position)
			get_node("/root/Globals").enemy4_tile_pos -= collision.normal
			get_node("/root/Globals").enemy4_tile_pos.y += 1
			get_node("/root/Globals").enemy4_tile_pos.x += 1
			
	if get_node("/root/Globals").enemy4_tile_pos == get_node("/root/Globals").tile_pos and get_node("/root/Globals").damage == 0:
		queue_free()


func _on_StompDetector_body_entered(body):
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("BodyCol").disabled = true
	queue_free()
	
func _on_KillDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if direction == -1:
			$AnimatedSprite.flip_h = true
			direction = 1
		else:
			$AnimatedSprite.flip_h = false
			direction = -1
	else:
		if "DeathDetector" in area.name:
			queue_free()


func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = true
		direction = 1
	else:
		$AnimatedSprite.flip_h = false
		direction = -1


func _on_Body_area_entered(area):
	if "enemyAttack" in area.name:
		direction = direction
	elif "Body" in area.name:
		direction = direction
	else:
		queue_free()
