extends Node2D

@onready var level_timer := $LevelTimer

func _ready() -> void:
	start_timer_with_delay()


func start_timer_with_delay() -> void:
	await get_tree().create_timer(5.0).timeout
	level_timer.start()
