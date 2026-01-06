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
	if time_left <= 0.0:
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
	await ScreenFader.transition_to_scene(lobby_scene, 1.0)
