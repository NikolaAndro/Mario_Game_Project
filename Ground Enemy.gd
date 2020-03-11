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
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	
func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED*direction
		$AnimatedSprite.play("run")
		
		velocity.y += GRAVITY 
	
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
	if direction == -1:
		$AnimatedSprite.flip_h = false
		direction = 1
	else:
		$AnimatedSprite.flip_h = true
		direction = -1
		


func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = false
		direction = 1
	else:
		$AnimatedSprite.flip_h = true
		direction = -1

func _on_Body_area_entered(area):
	if area.global_position.y > get_node("Body").global_position.y:
		return
	get_node("BodyCol").disabled = true
	queue_free()
