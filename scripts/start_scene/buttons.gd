extends Node

func start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
	
func exit_button_pressed():
	get_tree().quit()
