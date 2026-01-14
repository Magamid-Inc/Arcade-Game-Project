extends  Node

@onready var master_bus_id: int = AudioServer.get_bus_index("Master")
@onready var music_bus_id: int = AudioServer.get_bus_index("Music")
@onready var SFX_bus_id: int = AudioServer.get_bus_index("SFX")
@onready var SFX_player_bus_id: int = AudioServer.get_bus_index("SFX_Player")
@onready var SFX_world_bus_id: int = AudioServer.get_bus_index("SFX_World")
@onready var SFX_item_use_bus_id: int = AudioServer.get_bus_index("SFX_Items_Use")

@onready var music_lobbly: AudioStreamPlayer = get_node("MusicLobby")
@onready var music_lvl: AudioStreamPlayer = get_node("MusicLVL")
@onready var game_over: AudioStreamPlayer = $game_over
@onready var fadeout: AudioStreamPlayer = $fadeout
@onready var lvl_complete: AudioStreamPlayer = $LvlComplete
@onready var open_store: AudioStreamPlayer = $OpenStore
@onready var start_lvl_timer: AudioStreamPlayer = $StartLvlTimer
@onready var take_coin: AudioStreamPlayer = $TakeCoin
@onready var take_item: AudioStreamPlayer = $TakeItem
@onready var boost: AudioStreamPlayer = $Boost
@onready var heal: AudioStreamPlayer = $Heal
@onready var potion_use: AudioStreamPlayer = $PotionUse
@onready var shield: AudioStreamPlayer = $Shield
@onready var step_3: AudioStreamPlayer = $Step3
#@onready var step_5: AudioStreamPlayer = $Step5
@onready var meteor_hit: AudioStreamPlayer = $MeteorHit
@onready var spikes_hit: AudioStreamPlayer = $SpikesHit
@onready var die: AudioStreamPlayer = $Die



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_all_volume()
	music_lobbly.play()


func set_volumes(bus_id: int, percent: float):
	AudioServer.set_bus_volume_linear(bus_id, clamp(percent/100, 0.0, 1.0))


func start_lvl(timeout: float):
	AudioServer.set_bus_volume_db(music_bus_id, -80.0)
	music_lobbly.stop()
	music_lvl.play()
	await get_tree().create_timer(timeout/2).timeout
	set_volumes(music_bus_id, GameSettingsState.music_volume)
	await get_tree().create_timer(timeout/2).timeout
	start_lvl_timer.play()
	


func end_lvl():
	#AudioServer.set_bus_volume_db(music_bus_id, -80.0)
	music_lvl.stop()
	music_lobbly.play()
	set_volumes(music_bus_id, GameSettingsState.music_volume)


func update_all_volume():
	set_volumes(master_bus_id, GameSettingsState.global_volume)
	set_volumes(SFX_bus_id, GameSettingsState.ambient_volume)
	set_volumes(music_bus_id, GameSettingsState.music_volume)


func play_walk():
	if not step_3.playing:
		step_3.play()
