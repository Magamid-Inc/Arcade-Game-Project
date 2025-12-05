class_name MoneyUI
extends Node
var item : Item
var quantity : int = 0
@onready var icon : TextureRect = get_node("%Icon")
@onready var quantity_text : Label = get_node("%Count")

func _process(_delta: float) -> void:
	quantity = GameState.money
	update_quantity_text()
	
func update_quantity_text ():
	if quantity <= 1:
		quantity_text.text = ""
	else:
		quantity_text.text = str(quantity)
