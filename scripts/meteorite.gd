extends Node2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

	# Удаление, если сильно улетел
	if global_position.distance_to(Vector2.ZERO) > 5000:
		queue_free()
