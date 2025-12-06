extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var check_die: bool = false
@onready var loot_tilemaplayer = get_node("%TileMapLayer2")
@onready var inventory: Inventory = $"../Interface/Inventory"

const SPEED = 300

#@warning_ignore("unused_parameter")
func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if not check_die:
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1

	velocity = direction.normalized() * SPEED
	#move_and_slide()
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var collision_pos = collision.get_position()
			var cell = loot_tilemaplayer.local_to_map(collision_pos - collision.get_normal())
			var tile_id = loot_tilemaplayer.get_cell_source_id(cell)
			var atlas_coords: Vector2i = loot_tilemaplayer.get_cell_atlas_coords(cell)
			
			if tile_id == 0 and !check_die:
				var check_adding = true
				match atlas_coords:
					Vector2i(0, 0):
						check_adding = inventory.add_item(inventory.potion)
					Vector2i(1, 0):
						check_adding = inventory.add_item(inventory.shield)
					Vector2i(2, 0):
						check_adding = inventory.add_item(inventory.heart)
					Vector2i(3, 0):
						check_adding = inventory.add_item(inventory.heal_kit)
					Vector2i(4, 0):
						GameState.money += 1
					Vector2i(5, 0):
						check_adding = inventory.add_item(inventory.boost)
				if check_adding:
					loot_tilemaplayer.erase_cell(cell)

	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Animations
	if direction.x == 0 and direction.y == 0 and !check_die:
		animated_sprite.play("idle")
	elif !check_die:
		animated_sprite.play("run")
	if check_die and !collision_shape.disabled:
		collision_shape.disabled = true
		animated_sprite.play("die")

func take_damage(amount: int):
	GameState.player_health -= amount
	GameState.player_health = clamp(GameState.player_health, 0, GameState.max_health)
	
	#print("Health: ", GameState.player_health)
	
	if GameState.player_health <= 0 and !check_die:
		check_die = true
		die()
		
func die():
	print("Player died")
	#$"../GameOverScreen".visible = true
