extends CharacterBody2D


var speed = 150
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("Player_move_Up"):
		direction.y -= 1
	if Input.is_action_pressed("Player_move_Down"):
		direction.y += 1
	if Input.is_action_pressed("Player_move_Left"):
		direction.x -= 1
		anim.flip_h = true
	if Input.is_action_pressed("Player_move_Right"):
		direction.x += 1
		anim.flip_h = false
		
	if direction:
		anim.play("Run")
	else:
		anim.play("Idle")

	velocity = direction.normalized() * speed
	move_and_slide()
