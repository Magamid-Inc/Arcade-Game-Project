extends Node


var last_scene_path: String = ""

func _ready() -> void:
	
	pass


func move_to_scene(path: String):
	last_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(path)


func add_subscene(path: String):
	var packed_scene = load(path)
	if packed_scene:
		last_scene_path = get_tree().current_scene.scene_file_path
		var canvas_layer = CanvasLayer.new()
		canvas_layer.name = "subCanvas"
		canvas_layer.layer = 5
		get_tree().current_scene.add_child(canvas_layer)
		canvas_layer.add_child(packed_scene.instantiate())
		return canvas_layer
	return null


func move_to_last_scene(scene_name: String = "subCanvas"):
	if get_tree().root.get_node_or_null(scene_name):
		print(last_scene_path)
		if get_tree().root.get_node(scene_name).scene_file_path != last_scene_path:
			get_tree().change_scene_to_file(last_scene_path)

	elif get_tree().current_scene.get_node("subCanvas"):
		var scene = get_tree().current_scene.get_node("subCanvas")
		print(scene.scene_file_path)
		scene.queue_free()
	last_scene_path = ""
