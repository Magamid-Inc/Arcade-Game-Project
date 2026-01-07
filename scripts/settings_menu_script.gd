extends Node
@onready var button_win_size: OptionButton = $OptionButtonWinSize
@onready var button_display_mode: OptionButton = $OptionButtonDisplayMode

@onready var volume_sliders: Array[HSlider] = [
	$HSliderGlobalVolume,
	$HSliderAmbientVolume,
	$HSliderMusicVolume
]
@onready var volume_labels: Array[Label] = [
	$LabelGlobalVolumeValue,
	$LabelAmbientVolumeValue,
	$LabelMusicVolumeValue
]

const win_mods = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN
]
var last_volumes = []


func _ready() -> void:
	last_volumes = [
		GameSettingsState.global_volume,
		GameSettingsState.ambient_volume,
		GameSettingsState.music_volume
	]
	
	for i in range(len(last_volumes)):
		volume_sliders[i].value = last_volumes[i]
		volume_labels[i].text = str(last_volumes[i]) + "%"
	
	button_display_mode.select(GameSettingsState.display_mode_index)
	
	var currnet_window_size = DisplayServer.window_get_size()
	if currnet_window_size not in GameSettingsState.win_sizes:
		GameSettingsState.win_sizes.append(currnet_window_size)
	
	GameSettingsState.win_sizes.sort_custom(func(a,b): return a.length() < b.length())
		
	if GameSettingsState.win_sizes[GameSettingsState.win_size_selected_index] != currnet_window_size:
		GameSettingsState.win_size_selected_index = GameSettingsState.win_sizes.find(currnet_window_size)
		
	button_win_size.clear()
	for item in GameSettingsState.win_sizes:
		button_win_size.add_item(str((item.x))+" x "+str((item.y)))
	button_win_size.select(GameSettingsState.win_size_selected_index)


func _process(_delta: float) -> void:
	for i in range(len(last_volumes)):
		if last_volumes[i] != volume_sliders[i].value:
			last_volumes[i] = int(volume_sliders[i].value)
			volume_labels[i].text = str(last_volumes[i]) + "%"


func save_volume():
	GameSettingsState.global_volume = last_volumes[0]
	GameSettingsState.ambient_volume = last_volumes[1]
	GameSettingsState.music_volume = last_volumes[2]

func set_window_mode():
	var selected_index: int = button_display_mode.selected
	
	#GameSettingsState.display_mode = win_mods[selected_index]
	GameSettingsState.display_mode_index = selected_index
	GameSettingsState.is_borderless = true if selected_index == 1 else false
	
	var display_size = DisplayServer.screen_get_size()
	if selected_index == 2 && GameSettingsState.win_sizes[GameSettingsState.win_size_selected_index] != display_size:
		DisplayServer.window_set_size(display_size)
	
	DisplayServer.window_set_mode(win_mods[selected_index])
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, GameSettingsState.is_borderless)
	
	

func set_win_size():
	var size_index = button_win_size.selected
	var display_size = DisplayServer.screen_get_size()
	
	if GameSettingsState.win_sizes[size_index].length() <= display_size.length():
		GameSettingsState.win_size_selected_index = size_index
		DisplayServer.window_set_size(GameSettingsState.win_sizes[button_win_size.selected])
		
		var position = (display_size - GameSettingsState.win_sizes[size_index]) / 2
		DisplayServer.window_set_position(position)
	else:
		print("Can't set size window bigger than display size!")


func get_items_optionbutton(btn :OptionButton) -> Array[int]:
	var all_ids: Array[int] = []
	for i in range(btn.item_count):
		all_ids.append(btn.get_item_id(i))
	return all_ids



func press_save_button():
	set_win_size()
	set_window_mode()
	save_volume()


func press_exit_button():
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
