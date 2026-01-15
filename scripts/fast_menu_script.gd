extends Node

func press_continue_button():
	get_tree().paused = false
	var meteor_spawner = get_tree().current_scene.get_node_or_null("MeteoriteSpawner")
	if meteor_spawner != null:
		meteor_spawner.set_schedule_next(true)
	self.visible = false
	var filter = get_node("../blurFilter")
	if filter:
		filter.visible = false
	var interface = get_tree().current_scene.get_node("Interface")
	if interface:
		interface.check_visible_fast_menu = false



func press_settings_button():
	var settings_menu = SceneManager.add_subscene("res://scenes/settings_menu.tscn")
	if settings_menu:
		settings_menu.process_mode = Node.PROCESS_MODE_ALWAYS


func press_quit_game_button():
	get_tree().quit()
