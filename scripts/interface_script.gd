extends Node

@onready var menu_inspector: Node = $MenuInspector

var check_visible_fast_menu: bool = false

func _ready():
	var fast_menu = menu_inspector.fast_menu
	fast_menu.process_mode = Node.PROCESS_MODE_ALWAYS

func visible_game_over(is_show: bool, time: String):
	GlobalSoundPlayer.game_over.play()
	menu_inspector.filter.visible = is_show
	menu_inspector.game_over_menu.visible = is_show
	menu_inspector.game_over_menu.time_label.text = time


func visible_lvl_compl_menu(is_show: bool):
	get_tree().paused = true
	get_tree().current_scene.get_node("Player").set_physics_process(false)
	GlobalSoundPlayer.lvl_complete.play()
	menu_inspector.filter.visible = is_show
	menu_inspector.lvl_complete_menu.visible = is_show


func visible_fast_menu(is_show: bool):
	get_tree().paused = true
	get_tree().current_scene.get_node("MeteoriteSpawner").set_schedule_next(false)
	menu_inspector.filter.visible = is_show
	menu_inspector.fast_menu.visible = is_show
	check_visible_fast_menu = is_show
