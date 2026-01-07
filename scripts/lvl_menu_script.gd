extends Node

@onready var continue_button: TextureButton = $fone/TextureButton
const lobby_scene: String = "res://scenes/lobby.tscn"


func pressed_continue_button():
	await ScreenFader.transition_to_scene(lobby_scene, 1.0)
