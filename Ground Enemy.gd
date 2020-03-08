extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1

func _on_StompDetector_body_entered(body:KinematicBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
	
func _physics_process(delta):
	
	velocity.x = SPEED*direction
	$AnimatedSprite.play("run")
	
	velocity.y += GRAVITY 

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
		
	velocity = move_and_slide(velocity, FLOOR)

	if velocity.x == 0:
		if direction == -1:
			$AnimatedSprite.flip_h = false
			direction = 1
		else:
			$AnimatedSprite.flip_h = true
			direction = -1

