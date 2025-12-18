extends Node2D

@export var coin_scene: PackedScene
@export var min_coins: int = 5
@export var max_coins: int = 12

@onready var tilemap: TileMapLayer = get_node("../TileMapLayer")


func _ready() -> void:
	spawn_coins()


func spawn_coins() -> void:
	var cells: Array[Vector2i] = tilemap.get_used_cells()
	cells.shuffle()

	var count: int = randi_range(min_coins, max_coins)

	for i in count:
		var spawned: bool = false

		while not cells.is_empty() and not spawned:
			var cell: Vector2i = cells.pop_back()

			if not is_cell_walkable(cell):
				continue

			var coin: Area2D = coin_scene.instantiate() as Area2D
			coin.global_position = tilemap.map_to_local(cell)

			get_tree().current_scene.add_child.call_deferred(coin)
			spawned = true


func is_cell_walkable(cell: Vector2i) -> bool:
	var source_id: int = tilemap.get_cell_source_id(cell)

	# -1 = пустая клетка
	if source_id == -1:
		return false

	# 2 = стены
	return source_id != 2
