extends Node2D

@export var spike_scene: PackedScene
@export var min_spikes: int = 3
@export var max_spikes: int = 8

@onready var tilemap: TileMapLayer = get_node("../TileMapLayer")


func _ready() -> void:
	spawn_spikes()


func spawn_spikes() -> void:
	var cells: Array[Vector2i] = tilemap.get_used_cells()
	cells.shuffle()

	var count: int = randi_range(min_spikes, max_spikes)

	for i in count:
		var spawned := false

		while not cells.is_empty() and not spawned:
			var cell: Vector2i = cells.pop_back()

			if not is_cell_walkable(cell):
				continue

			if cell in GameState.occupied_cells:
				continue

			var spike: Area2D = spike_scene.instantiate() as Area2D
			spike.global_position = tilemap.map_to_local(cell)

			get_tree().current_scene.add_child.call_deferred(spike)

			GameState.occupied_cells.append(cell)
			spawned = true


func is_cell_walkable(cell: Vector2i) -> bool:
	var source_id: int = tilemap.get_cell_source_id(cell)

	if source_id == -1:
		return false

	# 2 = стены
	return source_id != 2
