# Description: A script that makes the camera follow the player.

extends Camera2D

var player : Node2D

func _ready():
	player = get_node("%Player")
	_sync_position()

func _process(_delta):
	_sync_position()

func _sync_position():
	if (player):
		global_position = player.global_position
	else:
		print("Player not found")
	
	pass
