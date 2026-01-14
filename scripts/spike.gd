extends Area2D

@export var damage: int = 10

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if GameState.player_health > 0:
			GlobalSoundPlayer.spikes_hit.play()
		body.take_damage(damage)
