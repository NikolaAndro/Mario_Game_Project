extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = -1
var dropped = 0
var stunned = 1
var falling = 0

func _on_Flying_Enemy_2_ready():
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
	velocity = move_and_slide(velocity, FLOOR)
	velocity.y += GRAVITY*dropped
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
			



func _on_StompDetector_body_entered(body):
	if on_ground == true:
		if stunned == 0:
			if body.global_position.y > get_node("StompDetector").global_position.y:
				return
			get_node("BodyCol").disabled = true
			queue_free()
		else:
			stunned = 0
			$AnimatedSprite.play("stunned")
			timer.start()
	else:
		dropped = 1
		$KillDetector/BottomCol.disabled = true

func _on_KillDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if "enemyAttack" in area.name:
			direction = direction
		else:
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
