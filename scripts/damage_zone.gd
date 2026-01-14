extends Area2D

@export var damage: int = 10

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			if GameState.player_health > 0 && not GameState.shield_active:
				GlobalSoundPlayer.meteor_hit.play()
		# Удаляем родителя (метеорит)
		get_parent().queue_free()
