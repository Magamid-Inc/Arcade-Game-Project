extends Node

@onready var continue_button: TextureButton = $fone/TextureButton
@onready var text_win: Label = $fone/Label
const lobby_scene: String = "res://scenes/lobby.tscn"

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func pressed_continue_button():
	get_tree().paused = false
	if FileAccess.file_exists("res://scenes/level"+str(GameSettingsState.selected_lvl+1)+".tscn"):
		GameSettingsState.selected_lvl += 1
	else:
		GameSettingsState.selected_lvl = 1 
	
	get_tree().current_scene.get_node("Player").set_physics_process(true)
	await ScreenFader.transition_to_scene(lobby_scene, 1.0)
