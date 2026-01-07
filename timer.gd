extends Label

var level_timer: Node = null


func _ready() -> void:
	level_timer = get_tree().current_scene.get_node_or_null("LevelTimer")

	# если таймера нет (лобби) — скрываемся
	visible = level_timer != null


func _process(_delta: float) -> void:
	if level_timer == null:
		return

	text = format_time(level_timer.time_left)


func format_time(time: float) -> String:
	var total := int(time)
	@warning_ignore("integer_division")
	var minutes := total / 60
	var seconds := total % 60
	return "%02d:%02d" % [minutes, seconds]
