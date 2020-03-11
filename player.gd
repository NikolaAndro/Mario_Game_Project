extends KinematicBody2D
const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()

export var stomp_impulse =1000.0

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
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):	
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


func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out



	
	velocity.y = calculate_stomp_velocity(velocity.y, stomp_impulse)




func _on_StepDetector_area_entered(area):
	velocity.y = JUMP_POWER


func _on_DeathDetector_area_entered(area):
	if area.global_position.y > get_node("DeathDetector").global_position.y:
		return
	get_node("BodyCol").disabled = true
	queue_free()
