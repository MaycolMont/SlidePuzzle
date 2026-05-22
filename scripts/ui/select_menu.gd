extends MarginContainer
## Menu for selecting an image and grid size before starting a game.
## Loads images from [member IMAGE_FILES] and displays them as TextureButtons.

@export var size_group: ButtonGroup
@export var image_group: ButtonGroup

## Stores the selected image and grid size in [Global], then transitions to
## the game scene.
func _on_play_button_pressed() -> void:
	var button_image_pressed: TextureButton = image_group.get_pressed_button()
	var button_size_pressed: Button = size_group.get_pressed_button()

	Global.texture_resource = button_image_pressed.texture_normal
	Global.grid_size = int(button_size_pressed.text[0])

	get_tree().change_scene_to_file(Config.GAME_SCENE_PATH)

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/init.tscn")
