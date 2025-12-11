extends Node2D

@export var meteor_scenes: Array[PackedScene]

@export var min_delay: float = 0.2
@export var max_delay: float = 0.4

@export var min_speed: float = 250.0
@export var max_speed: float = 450.0

@export var spawn_offset: float = 64.0

@onready var player: Node2D = get_node("../Player")


func _ready() -> void:
	while ScreenFader.fade_instance != null:
		await get_tree().create_timer(0.1).timeout
	randomize()
	_schedule_next()


func _schedule_next() -> void:
	var delay: float = randf_range(min_delay, max_delay)
	get_tree().create_timer(delay).timeout.connect(_spawn_meteor)


func _spawn_meteor() -> void:
	if meteor_scenes.is_empty():
		push_error("В инспекторе не добавлены сцены метеоритов!")
		return

	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera == null:
		push_error("Не найдена активная Camera2D!")
		return

	# ---- 1. Выбираем случайный метеорит ----
	var scene: PackedScene = meteor_scenes[randi() % meteor_scenes.size()]
	var meteor: Node2D = scene.instantiate() as Node2D
	get_tree().current_scene.add_child(meteor)

	# ---- 2. Позиция спавна ----
	var viewport: Rect2 = get_viewport().get_visible_rect()
	var half_size: Vector2 = viewport.size * 0.5
	var cam_pos: Vector2 = camera.global_position
	var spawn_pos: Vector2 = cam_pos

	var side: int = randi() % 4
	match side:
		0:
			spawn_pos = Vector2(
				randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x),
				cam_pos.y - half_size.y - spawn_offset
			)
		1:
			spawn_pos = Vector2(
				randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x),
				cam_pos.y + half_size.y + spawn_offset
			)
		2:
			spawn_pos = Vector2(
				cam_pos.x - half_size.x - spawn_offset,
				randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)
			)
		3:
			spawn_pos = Vector2(
				cam_pos.x + half_size.x + spawn_offset,
				randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)
			)

	meteor.global_position = spawn_pos

	# ---- 3. Выбор направления ----
	var pattern: float = randf()
	var dir: Vector2
	var target: Vector2 = (player.global_position if player != null else cam_pos)

	if pattern < 0.35:
		dir = (target - spawn_pos).normalized()

	elif pattern < 0.75:
		var random_point: Vector2 = Vector2(
			randf_range(cam_pos.x - half_size.x, cam_pos.x + half_size.x),
			randf_range(cam_pos.y - half_size.y, cam_pos.y + half_size.y)
		)
		var mixed: Vector2 = lerp(random_point, target, 0.4)
		dir = (mixed - spawn_pos).normalized()

	else:
		dir = (cam_pos - spawn_pos).normalized()

	var speed: float = randf_range(min_speed, max_speed)
	meteor.set("velocity", dir * speed)

	# ---- 4. Урон из metadata ----
	if meteor.has_meta("Damage"):
		var dmg: int = int(meteor.get_meta("Damage"))
		var dmg_zone: Area2D = meteor.get_node("DamageZone") as Area2D
		dmg_zone.set("damage", dmg)
	else:
		push_warning("У метеорита нет metadata 'Damage'!")

	_schedule_next()
