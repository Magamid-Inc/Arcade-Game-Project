extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
	
#var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Player_move_Right"):
		velocity.x += SPEED
	if Input.is_action_pressed("Player_move_Left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("Player_move_Down"):
		velocity.y += SPEED
	if Input.is_action_pressed("Player_move_Up"):
		velocity.y -= SPEED
	velocity = velocity.normalized() * SPEED * delta
	move_and_slide()

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
