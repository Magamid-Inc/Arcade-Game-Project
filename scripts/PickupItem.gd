extends Area2D

@export var item_key: StringName

func get_item_data() -> Item:
	match item_key:
		"potion": return GameState.potion
		"shield": return GameState.shield
		"medkit": return GameState.medkit
		"heart": return GameState.heart
		"boost": return GameState.boost
		_: return null
