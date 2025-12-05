class_name Inventory
extends Node
var slots : Array[InventorySlot]
@onready var window : Panel = get_node("InventoryWindow")
@onready var potion: Item = preload("res://Items/potion.tres")
@onready var heal_kit: Item = preload("res://Items/heal_kit.tres")
@onready var heart: Item = preload("res://Items/heart.tres")
@onready var boost: Item = preload("res://Items/boost.tres")
@onready var shield: Item = preload("res://Items/shield.tres")
#@onready var info_text : Label = get_node("InventoryWindow/InfoText")
@export var starter_items : Array[Item]


func _ready ():
	for child in get_node("InventoryWindow/SlotContainer").get_children():
		
		slots.append(child)
		child.set_item(null)
		child.inventory = self
		
	#for i in range(6):
		#starter_items.append(potion)
		
	for item in starter_items:
		add_item(item)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press_num_1"):
		remove_item(0)
	if Input.is_action_just_pressed("press_num_2"):
		remove_item(1)
	if Input.is_action_just_pressed("press_num_3"):
		remove_item(2)
	if Input.is_action_just_pressed("press_num_4"):
		remove_item(3)


#func on_give_player_item (item : Item, amount : int):
	#pass


func add_item (item):
	if item is not Item:
		return Error.ERR_INVALID_DATA
	
	var slot = get_slot_to_add(item)
	
	if slot == null:
		return false
	
	if slot.item == null:
		slot.set_item(item)
	elif slot.item == item:
		slot.add_item()
	
	return true

#func get_item_from_num_slot(num: int) -> Item:
	#return slots[num-1].item

func remove_item (index: int = -1, item : Item = null):
	var slot : InventorySlot
	if index == -1:
		slot = get_slot_to_remove(item)
	else:
		slot = slots[index]
	
	if slot == null or slot.item == null:
		print("error")
		return
	
	match slot.item:
		potion:
			print(potion.timeHeal)
			GameState.player_health = clamp(GameState.player_health+potion.healSize, 0, GameState.max_health)
			#for i in range(potion.timeHeal):
				
		heal_kit:
			GameState.player_health = clamp(GameState.player_health+heal_kit.healSize, 0, GameState.max_health)
		heart:
			GameState.player_health = clamp(GameState.player_health+heart.healSize, 0, GameState.max_health)
		boost:
			pass
		shield:
			pass
	
	slot.remove_item()
		


func get_slot_to_add (item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack_size:
			return slot
  
	for slot in slots:
		if slot.item == null:
			return slot
  
	return null


func get_slot_to_remove (item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item:
			print(slot)
			return slot

	return null


func get_number_of_item (item : Item) -> int:
	var total = 0

	for slot in slots:
		if slot.item == item:
			total += slot.quantity

	return total
