extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(GameState.player_health) + "/" + str(GameState.max_health)
