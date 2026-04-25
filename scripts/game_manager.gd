extends CanvasLayer

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("popup"):
		node.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		$ConfirmPopup.show()
		get_tree().paused = true

func _go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Config.MENU_SCENE_PATH)
