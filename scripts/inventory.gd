class_name Inventory
extends Node

@export var starter_items : Array[Item]


func _ready ():
	for i in range(1):
		starter_items.append(GameState.potion)
		
	for item in starter_items:
		add_item(item)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press_num_1"):
		remove_item(GameState.potion)
	if Input.is_action_just_pressed("press_num_2"):
		remove_item(GameState.shield)
	if Input.is_action_just_pressed("press_num_3"):
		remove_item(GameState.medkit)
	if Input.is_action_just_pressed("press_num_4"):
		remove_item(GameState.heart)
	if Input.is_action_just_pressed("press_num_5"):
		remove_item(GameState.boost)


func add_item (item):
	if item is not Item:
		return Error.ERR_INVALID_DATA
		
	if item.identity == "":
		print("Undefined item")
		return
		
	if  GameState.itemscounts.get(item.identity) == null || item.max_stack_size <= GameState.itemscounts.get(item.identity):
		print("Can't take item")
		return
		
	GameState.itemscounts[item.identity] += 1
	return true


func remove_item (item : Item = null):
	if item == null || GameState.itemscounts.get(item.identity) <= 0:
		print("can't get item")
		return
	if GameState.player_health <= 0:
		print("Can't use item, player was died")
		return 
		
	GameState.itemscounts[item.identity] -= 1
	
	match item:
		GameState.potion:
			if not GameState.timeout_heal:
				GameState.timeout_heal = true
				for i in range(item.timeHeal):
					GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
					await get_tree().create_timer(1.0).timeout
				GameState.timeout_heal = false
			else:
				GameState.itemscounts[item.identity] += 1
		GameState.medkit:
			if not GameState.timeout_heal:
				GameState.timeout_heal = true
				GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
				await get_tree().create_timer(item.timeout).timeout
				GameState.timeout_heal = false
			else:
				GameState.itemscounts[item.identity] += 1
		GameState.heart:
			if not GameState.timeout_heal:
				GameState.timeout_heal = true
				GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
				await get_tree().create_timer(item.timeout).timeout
				GameState.timeout_heal = false
			else:
				GameState.itemscounts[item.identity] += 1
		GameState.boost:
			if not GameState.timeout_boost:
				GameState.timeout_boost = true
				GameState.SPEED = GameState.SPEED * (100 + item.boostPercent) / 100
				await get_tree().create_timer(item.time).timeout
				GameState.SPEED = GameState.SPEED / (100 + item.boostPercent) * 100
				GameState.timeout_boost = false
			else:
				GameState.itemscounts[item.identity] += 1
		GameState.shield:
			if not GameState.timeout_shield:
				GameState.timeout_shield = true
				%Player.shield_effect.visible = true
				#%Player.pickup_collision_shape.shape.radius = 40
				await get_tree().create_timer(item.time).timeout
				%Player.shield_effect.visible = false
				#%Player.pickup_collision_shape.shape.radius = 20.52
				GameState.timeout_shield = false
			else:
				GameState.itemscounts[item.identity] += 1
