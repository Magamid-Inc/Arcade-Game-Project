extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300

@warning_ignore("unused_parameter")
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

func take_damage(amount: int):
	GameState.player_health -= amount
	GameState.player_health = clamp(GameState.player_health, 0, GameState.max_health)
	
	print("Health: ", GameState.player_health)
	
	if GameState.player_health <= 0:
		die()
		
func die():
	print("Player died")
	$"../GameOverScreen".visible = true
