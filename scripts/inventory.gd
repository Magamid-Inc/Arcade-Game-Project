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
			for i in range(item.timeHeal):
				GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
				await get_tree().create_timer(1.0).timeout
		GameState.medkit:
			GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
		GameState.heart:
			GameState.player_health = clamp(GameState.player_health+item.healSize, 0, GameState.max_health)
		GameState.boost:
			pass
		GameState.shield:
			pass
