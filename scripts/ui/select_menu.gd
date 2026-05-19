extends MarginContainer
## Menu for selecting an image and grid size before starting a game.
## Loads images from [member IMAGE_FILES] and displays them as TextureButtons.

@onready var images_container: GridContainer = %ImagesSelector

@export var size_group: ButtonGroup
@export var image_group: ButtonGroup

## Known image filenames in [code]assets/sprites/images/[/code].
## Must match the number of TextureButton children in the ImagesSelector GridContainer.
const IMAGE_FILES: Array[String] = [
	"linda_noche.jpg",
	"weird_bird.jpg",
	"weird_bird1.jpg",
	"snowman.png",
	"snowman1.png",
	"icon1.svg",
]

func _ready() -> void:
	_set_options(images_container)

## Loads textures from [member IMAGE_FILES] and assigns them to the image buttons.
func _set_options(options_container: Container) -> void:
	var textures_resources: Array[Texture2D] = _generate_texture_resources(IMAGE_FILES)
	_generate_buttons(options_container, textures_resources)

## Assigns each loaded texture to the pre-placed TextureButton children.
func _generate_buttons(buttons_container: Container, texture_resources: Array[Texture2D]) -> void:
	var image_buttons: Array[Node] = images_container.get_children()
	var i: int = 0
	for texture_resource: Texture2D in texture_resources:
		var image_button: TextureButton = image_buttons[i] as TextureButton
		image_button.texture_normal = texture_resource
		i += 1

## Loads each filename as a [Texture2D] from the images path.
func _generate_texture_resources(list_file_name: Array[String]) -> Array[Texture2D]:
	var texture_resources: Array[Texture2D] = []
	for file_name: String in list_file_name:
		var file_path: String = Config.IMAGES_PATH + file_name
		var texture_resource: Texture2D = load(file_path)
		texture_resources.append(texture_resource)
	return texture_resources

## Stores the selected image and grid size in [Global], then transitions to
## the game scene.
func _on_play_button_pressed() -> void:
	var button_image_pressed: TextureButton = image_group.get_pressed_button()
	var button_size_pressed: Button = size_group.get_pressed_button()

	Global.texture_resource = button_image_pressed.texture_normal
	Global.grid_size = int(button_size_pressed.text[0])

	print_debug("Texture selected: %s" % Global.texture_resource)

	get_tree().change_scene_to_file(Config.GAME_SCENE_PATH)

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/init.tscn")
