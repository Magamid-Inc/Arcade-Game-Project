extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shield_effect: Polygon2D = $shield_effect
@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var inventory: Inventory = %Inventory


# -----------------------------
# СОСТОЯНИЕ
# -----------------------------
var check_die: bool = false

# -----------------------------
# ДВИЖЕНИЕ
# -----------------------------


# -----------------------------
# ЭФФЕКТ ПОЛУЧЕНИЯ УРОНА
# -----------------------------
@export var hit_flash_color: Color = Color(1, 0.3, 0.3, 1)
@export var hit_flash_duration: float = 0.15

var hit_flash_timer: float = 0.0
var is_flashing: bool = false


func _ready() -> void:
	pickup_area.area_entered.connect(_on_pickup_area_area_entered)
	animated_sprite.modulate = Color.WHITE


func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	

	# -----------------------------
	# ВВОД ДВИЖЕНИЯ
	# -----------------------------
	if not check_die and ScreenFader.fade_instance == null and not ButtonsListener.is_terminal_open:
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1

	velocity = direction.normalized() * GameState.SPEED
	move_and_slide()

	# -----------------------------
	# РАЗВОРОТ
	# -----------------------------
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0

	# -----------------------------
	# АНИМАЦИИ
	# -----------------------------
	if check_die:
		return

	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")


func _process(delta: float) -> void:
	# -----------------------------
	# ПЛАВНЫЙ ВОЗВРАТ ЦВЕТА
	# -----------------------------
	if is_flashing:
		hit_flash_timer -= delta
		if hit_flash_timer <= 0.0:
			is_flashing = false
			animated_sprite.modulate = Color.WHITE


# --------------------------------------------------
# ПОДБОР ПРЕДМЕТОВ
# --------------------------------------------------

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if check_die:
		return

	if area.is_in_group("coin"):
		GameState.money += 1
		area.queue_free()
		return

	if area.is_in_group("item"):
		if area.has_method("get_item_data"):
			var item = area.get_item_data()
			if inventory.add_item(item):
				area.queue_free()


# --------------------------------------------------
# УРОН И СМЕРТЬ
# --------------------------------------------------

func take_damage(amount: int) -> void:
	if check_die or GameState.timeout_shield or GameState.is_transitioning:
		return

	# 🔴 ВИЗУАЛЬНЫЙ ФИДБЕК
	flash_on_hit()

	GameState.player_health -= amount
	GameState.player_health = clamp(GameState.player_health, 0, GameState.max_health)

	if GameState.player_health <= 0:
		check_die = true
		die()


func flash_on_hit() -> void:
	is_flashing = true
	hit_flash_timer = hit_flash_duration
	animated_sprite.modulate = hit_flash_color


func die() -> void:
	# защита от повторного запуска
	if animated_sprite.animation == "die":
		return
#	#ошбику даёт
	#collision_shape.disabled = true
	animated_sprite.modulate = Color.WHITE
	animated_sprite.play("die")
	#$"../GameOverScreen".visible = true


# --------------------------------------------------
# ПЕРЕХОД ИЗ ЛОББИ
# --------------------------------------------------

func _body_entered_from_lobby_to_lvl(_body: Node2D) -> void:
	await ScreenFader.transition_to_scene("res://scenes/level1.tscn", 1.0)
