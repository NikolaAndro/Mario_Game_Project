extends Area2D

const GRAVITY = 1
const SPEED = 300
var velocity = Vector2()
var direction = 1

func _ready():
	velocity.y = -7

func set_enemyAttack_direction(dir):
	direction = dir
	if (dir == -1):
		$AnimatedSprite.flip_h = true
		

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")
	velocity.y += GRAVITY


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_enemyAttack_body_entered(body):
	if "Enemy" in body.name:
		direction = direction
	else:
		queue_free()
	
