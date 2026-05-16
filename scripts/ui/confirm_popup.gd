extends CenterContainer
## Pause confirmation popup. Shown when the player presses Escape during gameplay.

## Hides the popup and resumes the game.
func _on_cancel_pressed() -> void:
	hide()
	get_tree().paused = false
