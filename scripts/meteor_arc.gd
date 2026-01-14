extends Node2D

var velocity: Vector2 = Vector2.ZERO

@export var max_lifetime: float = 6.0
@export var despawn_margin: float = 300.0

@export var curve_strength: float = 2.0
@export var curve_direction: int = 1  # 1 или -1

var _age: float = 0.0

func _ready() -> void:
	curve_direction = [1, -1].pick_random()
	curve_strength = randf_range(1.2, 3.0)

func _physics_process(delta: float) -> void:
	_age += delta
	if _age >= max_lifetime:
		queue_free()
		return

	# дуга
	velocity = velocity.rotated(curve_strength * curve_direction * delta)
	position += velocity * delta

	if _is_far_from_camera():
		queue_free()


func _is_far_from_camera() -> bool:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return false

	var rect: Rect2 = get_viewport().get_visible_rect()
	var half: Vector2 = rect.size * 0.5
	var p: Vector2 = global_position
	var c: Vector2 = cam.global_position

	return abs(p.x - c.x) > (half.x + despawn_margin) or abs(p.y - c.y) > (half.y + despawn_margin)
