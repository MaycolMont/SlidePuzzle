extends Control

func _on_ranking_button_pressed() -> void:
	$RankingPopup.show()
	get_tree().paused = true

func _on_config_button_pressed() -> void:
	$ConfigurePopup.show()
	get_tree().paused = true

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/select_menu.tscn")
