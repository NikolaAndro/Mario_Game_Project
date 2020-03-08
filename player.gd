extends KinematicBody2D
const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()

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
		if !Input.is_action_pressed("ui_down"):
			velocity.x = SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):	
		if !Input.is_action_pressed("ui_down"):
			velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
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
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
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

	
	
	
	
