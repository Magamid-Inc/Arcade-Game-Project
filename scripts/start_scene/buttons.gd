extends Node

func start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func settings_button_pressed():
	print("Открытие будущих настроек")
	pass
	
func exit_button_pressed():
	get_tree().quit()
