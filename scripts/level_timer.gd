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
	$"../Interface".visible_lvl_compl_menu(true)


func show_gameover_menu():
	finished = true
	await get_tree().create_timer(3.0).timeout
	var minutes: int = floor(level_time-time_left) / 60
	var seconds: int = int(level_time-time_left) % 60
	$"../Interface".visible_game_over(true, "%02d:%02d" % [minutes, seconds])
