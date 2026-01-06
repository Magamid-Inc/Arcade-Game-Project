extends Node

var fade_instance: CanvasLayer = null
const LOBBY_SCENE := "res://scenes/lobby.tscn"


func _ensure_fade_instance() -> void:
	if fade_instance == null:
		var fade_scene = preload("res://scenes/screen_fade.tscn")
		fade_instance = fade_scene.instantiate()
		fade_instance.layer = 100
		fade_instance.get_node("ColorRect").mouse_filter = Control.MOUSE_FILTER_IGNORE
		get_tree().root.add_child(fade_instance)


func fade_in(duration: float = 0.3) -> void:
	_ensure_fade_instance()
	var color_rect = fade_instance.get_node("ColorRect")
	var tween = color_rect.create_tween()
	tween.tween_property(color_rect, "modulate:a", 254, duration)
	await tween.finished


func fade_out(duration: float = 0.3) -> void:
	if not fade_instance:
		return
	GameState.player_health = GameState.max_health
	var color_rect = fade_instance.get_node("ColorRect")
	var tween = color_rect.create_tween()
	tween.tween_property(color_rect, "modulate:a", 1, duration)
	await tween.finished


func transition_to_scene(scene_path: String, fade_duration: float = 0.3) -> void:
	GameState.is_transitioning = true
	
	await fade_in(fade_duration)
	get_tree().change_scene_to_file(scene_path)
	_ensure_fade_instance()
	await fade_out(fade_duration)

	# ⛔ НЕ показываем таймер, если это лобби
	if scene_path == LOBBY_SCENE:
		fade_instance = null
		return

	# ▶ Таймер только для уровней
	var timer: Label = fade_instance.get_node("Label")
	timer.visible = true

	for t in range(3, 0, -1):
		timer.text = str(t)
		await get_tree().create_timer(1).timeout

	timer.visible = false
	GameState.is_transitioning = false
	fade_instance = null
