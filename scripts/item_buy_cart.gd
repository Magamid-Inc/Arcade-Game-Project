extends Control

@onready var label = $CostLabel
@onready var image = $ItemTextureRect
@onready var button_buy = $BuyTextureButton
var item_used


func set_item(item):
	if item is not Item:
		return Error.ERR_INVALID_DATA
	label.text = str(item.price)
	image.texture = item.icon
	item_used = item

func _press_buy():
	var help_l = get_node_or_null("../../Interface/HelpLabel")
	if item_used.max_stack_size > GameState.itemscounts[item_used.identity]:
		if GameState.money >= item_used.price:
			GameState.money -= item_used.price
			GameState.itemscounts[item_used.identity] += 1
			GlobalSoundPlayer.take_coin.play()
			if help_l != null:
				help_l.text = "Куплено!"
				await get_tree().create_timer(3).timeout
				if help_l.text == "Куплено!":
					help_l.text = ""
		else:
			if help_l != null:
				help_l.text = "Недостаточно монет"
				await get_tree().create_timer(3).timeout
				if help_l.text == "Недостаточно монет":
					help_l.text = ""
	elif help_l != null:
		help_l.text = "Недостаточно места в инветаре!"
		await get_tree().create_timer(3).timeout
		if help_l.text == "Недостаточно места в инветаре!":
			help_l.text = ""
