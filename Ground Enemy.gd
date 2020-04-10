extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
var is_dead = false
var falling = 0

func _ready():
	set_position(Vector2(500,210))
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	
func _physics_process(delta):
	if is_dead == false:
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
	
		if is_on_floor():
			on_ground = true
		else:
			on_ground = false
				
		velocity = move_and_slide(velocity, FLOOR)


func _on_StompDetector_body_entered(body):
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("BodyCol").disabled = true
	queue_free()



func _on_KillDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if "enemyAttack" in area.name:
			direction = direction
		else:
			if direction == -1:
				$AnimatedSprite.flip_h = false
				direction = 1
			else:
				$AnimatedSprite.flip_h = true
				direction = -1
	else:
		if "DeathDetector" in area.name:
			if area.global_position.y > get_node("Body").global_position.y:
				return
			get_node("BodyCol").disabled = true
			queue_free()


func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = false
		direction = 1
	else:
		$AnimatedSprite.flip_h = true
		direction = -1

func _on_Body_area_entered(area):
	if "enemyAttack" in area.name:
		direction = direction
	elif "Body" in area.name:
		direction = direction
	else:
		if area.global_position.y > get_node("Body").global_position.y:
			return
		get_node("BodyCol").disabled = true
		queue_free()
