extends Panel
class_name MyPopup

func _ready() -> void:
	hide()

func _on_quit_button_pressed() -> void:
	hide()
	get_tree().paused = false
