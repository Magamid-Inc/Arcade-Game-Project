extends Node2D

@export var item_scenes: Array[PackedScene]
@export var min_items: int = 2
@export var max_items: int = 5

@onready var tilemap: TileMapLayer = get_node("../TileMapLayer")


func _ready() -> void:
	spawn_items()


func spawn_items() -> void:
	var cells: Array[Vector2i] = tilemap.get_used_cells()
	cells.shuffle()

	var count: int = randi_range(min_items, max_items)

	for i in count:
		var spawned: bool = false

		while not cells.is_empty() and not spawned:
			var cell: Vector2i = cells.pop_back()

			if not is_cell_walkable(cell):
				continue

			var scene: PackedScene = item_scenes.pick_random()
			var item: Area2D = scene.instantiate() as Area2D
			item.global_position = tilemap.map_to_local(cell)
			get_tree().current_scene.add_child.call_deferred(item)
			
			GameState.occupied_cells.append(cell)
			spawned = true


func is_cell_walkable(cell: Vector2i) -> bool:
	var source_id: int = tilemap.get_cell_source_id(cell)

	# -1 = пустая клетка
	if source_id == -1:
		return false

	# 2 = стены
	return source_id != 2
