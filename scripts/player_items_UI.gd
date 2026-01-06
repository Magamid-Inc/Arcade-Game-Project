class_name ItemsUI
extends Node
var quantitys : Dictionary = {}
@onready var potion_quantity_text : Label = get_node("PotionUI/Count")
@onready var shield_quantity_text : Label = get_node("ShieldUI/Count")
@onready var heal_kit_quantity_text : Label = get_node("HealKitUI/Count")
@onready var heart_quantity_text : Label = get_node("HeartUI/Count")
@onready var boost_quantity_text : Label = get_node("BoostUI/Count")

func _process(_delta) -> void:
	quantitys = GameState.itemscounts
	update_quantity_text()
	
func update_quantity_text ():
	potion_quantity_text.text = "x" + str(quantitys["potion"]) 
	shield_quantity_text.text = "x" + str(quantitys["shield"])
	heal_kit_quantity_text.text = "x" + str(quantitys["medkit"])
	heart_quantity_text.text = "x" + str(quantitys["heart"])
	boost_quantity_text.text = "x" + str(quantitys["boost"])
