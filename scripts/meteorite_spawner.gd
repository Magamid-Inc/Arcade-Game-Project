extends Node2D

const METEOR_SCENE: PackedScene = preload("res://scenes/meteorite.tscn")

@export var min_delay: float = 0.2
@export var max_delay: float = 0.4

@export var min_speed: float = 250.0
@export var max_speed: float = 450.0

@export var spawn_offset: float = 64.0

@onready var player: Node2D = %Player

func _ready() -> void:
	randomize()
	_schedule_next()


func _schedule_next() -> void:
	var delay: float = randf_range(min_delay, max_delay)
	get_tree().create_timer(delay).timeout.connect(_spawn_meteor)


func _spawn_meteor() -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera == null:
		_schedule_next()
		return

	var meteor: Node2D = METEOR_SCENE.instantiate() as Node2D
	get_tree().current_scene.add_child(meteor)

	# ---- Границы видимой области камеры ----
	var viewport_rect: Rect2 = get_viewport().get_visible_rect()
	var half_size: Vector2 = viewport_rect.size * 0.5
	var cam_pos: Vector2 = camera.global_position

	# ---- Случайная сторона экрана ----
	var side: int = randi() % 4
	var spawn_pos: Vector2 = cam_pos

	match side:
		0: # сверху
			spawn_pos.x = randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x)
			spawn_pos.y = cam_pos.y - half_size.y - spawn_offset
		1: # снизу
			spawn_pos.x = randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x)
			spawn_pos.y = cam_pos.y + half_size.y + spawn_offset
		2: # слева
			spawn_pos.x = cam_pos.x - half_size.x - spawn_offset
			spawn_pos.y = randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)
		3: # справа
			spawn_pos.x = cam_pos.x + half_size.x + spawn_offset
			spawn_pos.y = randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)

	meteor.global_position = spawn_pos

	# ---- Направление "то рандомно, то нет" ----
	var dir: Vector2
	var pattern_choice: float = randf()

	var target_point: Vector2 = cam_pos
	if player != null:
		target_point = player.global_position

	if pattern_choice < 0.35:
		# 35% — прицельно в игрока
		dir = (target_point - spawn_pos).normalized()
	elif pattern_choice < 0.75:
		# 40% — полурандомно: между игроком и случайной точкой в экране
		var random_point: Vector2 = Vector2(
			randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x),
			randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)
		)
		var mixed_target: Vector2 = lerp(random_point, target_point, 0.4)
		dir = (mixed_target - spawn_pos).normalized()
	else:
		# 25% — просто летят к центру камеры
		var center_target: Vector2 = cam_pos
		dir = (center_target - spawn_pos).normalized()

	var speed: float = randf_range(min_speed, max_speed)
	meteor.velocity = dir * speed

	_schedule_next()
