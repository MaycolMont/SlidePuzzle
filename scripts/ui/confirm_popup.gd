extends CenterContainer

func _on_cancel_pressed() -> void:
	hide()
	get_tree().paused = false
