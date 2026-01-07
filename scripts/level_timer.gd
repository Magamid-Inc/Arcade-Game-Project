extends Node

@export var level_time: float = 60.0
@export var lobby_scene: String = "res://scenes/lobby.tscn"

var time_left: float
var running := false
var finished := false


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	if not running or finished:
		return

	time_left -= delta
	if %Player.check_die:
		show_gameover_menu()
	elif time_left <= 0.0:
		time_left = 0.0
		end_level()
	


func start() -> void:
	if finished:
		return
	running = true


func reset() -> void:
	time_left = level_time
	running = false
	finished = false


func end_level() -> void:
	if finished:
		return

	finished = true
	running = false
	#	show level complete menu with button for go to lobbby
	await ScreenFader.transition_to_scene(lobby_scene, 1.0)


func show_gameover_menu():
#	show game over menu with button for go to lobbby or reset lvl
	finished = true
