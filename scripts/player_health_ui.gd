extends CanvasGroup

@onready var label = get_node("Label")
@onready var health_bar = get_node("HealthProgressBar")
@onready var health_bar_second = get_node("HealthProgressBarBack")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = str(GameState.player_health)
	var last_health = health_bar.value
	health_bar.value = GameState.player_health
	if GameState.player_health < last_health:
		damage_over_time(GameState.player_health, 30.0)
	elif GameState.player_health > last_health:
		health_bar_second.value = GameState.player_health

func damage_over_time(target_health: int, step_count: float = 5.0):
	var start_health = health_bar_second.value
	await get_tree().create_timer(0.75).timeout
	while health_bar_second.value > target_health:
		if abs(target_health - GameState.player_health) >= 0.5:
			break
		var health_step = float(start_health - target_health) / step_count
		health_bar_second.value -= health_step
		await get_tree().create_timer(0.25 / step_count).timeout
		
	
