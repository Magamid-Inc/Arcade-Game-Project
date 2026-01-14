extends Node

var global_volume: int = 80
var ambient_volume: int = 100
var music_volume: int = 40
var is_borderless = false
var display_mode_index = 0
var win_size_selected_index = 0
var win_sizes = [
	Vector2i(1152, 648),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
]
var selected_lvl: int = 1

func _ready() -> void:
#	сюда добавить импорт параметров при запуске из файла сохранения
	pass
