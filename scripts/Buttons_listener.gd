extends Node

var is_terminal_open := false


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent):
	if !get_tree():
		return
	
	if event.is_action_pressed("ui_cancel"):
		var terminal = get_tree().current_scene.get_node_or_null("Terminal")
		var interface = get_tree().current_scene.get_node_or_null("Interface")
		
		if terminal != null:
			is_terminal_open = terminal.visible
		
		if terminal != null && is_terminal_open:
			GlobalSoundPlayer.open_store.play()
			terminal.visible = false
			is_terminal_open = false
			
		elif interface != null:
			if not interface.check_visible_fast_menu:
				interface.visible_fast_menu(true)
			else:
				interface.visible_fast_menu(false)
				get_tree().paused = false
		
		get_viewport().set_input_as_handled()
