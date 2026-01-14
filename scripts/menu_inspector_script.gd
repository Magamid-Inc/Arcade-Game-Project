extends Node

@onready var filter : ColorRect = $blurFilter
@onready var lvl_complete_menu: Node = $LvlCompleteMenu
@onready var game_over_menu: Node = $GameOverMenu
@onready var fast_menu: Node = $FastMenu

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
