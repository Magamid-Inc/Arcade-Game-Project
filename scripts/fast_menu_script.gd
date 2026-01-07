extends Node

func press_continue_button():
	self.visible = false


func press_settings_button():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func press_quit_game_button():
	get_tree().quit()
