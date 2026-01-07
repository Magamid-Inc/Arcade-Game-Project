extends Node

@onready var time_label: Label = $fone/LabelTime

func press_reset_button():
	await ScreenFader.transition_to_scene("res://scenes/level1.tscn", 1.0)


func press_exit_button():
	await ScreenFader.transition_to_scene("res://scenes/lobby.tscn", 1.0)
