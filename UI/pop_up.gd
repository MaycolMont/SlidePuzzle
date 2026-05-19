extends Control
##

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	hide()
