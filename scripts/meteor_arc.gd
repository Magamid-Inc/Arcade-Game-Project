extends Node2D

var velocity: Vector2 = Vector2.ZERO

@export var curve_strength: float = 2.0   # сила дуги
@export var curve_direction: int = 1       # 1 или -1

func _ready() -> void:
	# случайная сторона закрутки
	curve_direction = [1, -1].pick_random()
	# небольшая рандомизация силы дуги
	curve_strength = randf_range(0.5, 3.5)


func _physics_process(delta: float) -> void:
	# вращаем вектор скорости → дуга
	velocity = velocity.rotated(curve_strength * curve_direction * delta)

	position += velocity * delta

	if global_position.length() > 5000:
		queue_free()
