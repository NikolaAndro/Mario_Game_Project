extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
var stunned = 1

	
func _on_Ground_Enemy_3_ready():
	$AnimatedSprite.play("run")
	
	
var timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.connect("timeout", self, "_timeout")
	
func _timeout():
	stunned = 1
	$AnimatedSprite.play("run")
		
		
func _physics_process(delta):
	
	velocity.x = SPEED*direction*stunned
	
	velocity.y += GRAVITY 

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
		
	velocity = move_and_slide(velocity, FLOOR)

func _on_StompDetector_body_entered(body):
	if "player" in body.name:
		if stunned == 1:
			stunned = 0
			$AnimatedSprite.play("stunned")
			timer.start()

func _on_KillDetector_area_entered(area):
	if "enemyAttack" or "fireball" in area.name:
		direction = direction
	else:
		if direction == -1:
			$AnimatedSprite.flip_h = true
			direction = 1
		else:
			$AnimatedSprite.flip_h = false
			direction = -1

func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = true
		direction = 1
	else:
		$AnimatedSprite.flip_h = false
		direction = -1
		
