class_name Terminal
extends Node

@onready var terminal = $"."
@onready var help_label = $"../Interface/HelpLabel"
@onready var item_cart1 = $ItemBuyCart
@onready var item_cart2 = $ItemBuyCart2
@onready var item_cart3 = $ItemBuyCart3
@onready var item_cart4 = $ItemBuyCart4
@onready var item_cart5 = $ItemBuyCart5
var check_can_open = false


func _ready() -> void:
	item_cart1.set_item(GameState.shield)
	item_cart2.set_item(GameState.boost)
	item_cart3.set_item(GameState.potion)
	item_cart4.set_item(GameState.medkit)
	item_cart5.set_item(GameState.heart)


func _process(_delta: float) -> void:
	if check_can_open:
		if Input.is_action_just_pressed("open_menu") and !terminal.visible:
			GlobalSoundPlayer.open_store.play()
			terminal.visible = true
			help_label.text = ""


func _close_terminal():
	GlobalSoundPlayer.open_store.play()
	terminal.visible = false
	help_label.text = "Нажмите 'E' чтобы открыть"


func _open_terminal_permission(_delta):
	check_can_open = true
	help_label.text = "Нажмите 'E' чтобы открыть"


func _open_terminal_ban(_delta):
	check_can_open = false
	help_label.text = ""
	terminal.visible = false
