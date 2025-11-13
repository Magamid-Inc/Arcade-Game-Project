extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	velocity = direction.normalized() * SPEED
	move_and_slide()
	
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Animations
	if direction.x == 0 and direction.y == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
