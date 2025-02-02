extends MarginContainer

@onready var images_container = %ImagesSelector

@export var button_size : ButtonGroup
@export var image_group : ButtonGroup

var images_path : String = Config.IMAGES_PATH

func _ready():
	_set_options(images_container, images_path)

func _set_options(options_container, path: String) -> void:
	var file_names = _filter_files(DirAccess.get_files_at(path))
	var textures_resources = _generate_texture_resources(file_names)
	_generate_buttons(options_container, textures_resources)

func _generate_buttons(buttons_container, texture_resources : Array) -> void:
	var image_buttons = images_container.get_children()
	var i = 0
	for texture_resource in texture_resources:
		var image_button = image_buttons[i] as TextureButton
		image_button.texture_normal = texture_resource
		i += 1

func _create_button(button_group, texture_resource : Texture2D) -> Button:
	var button = Button.new()
	button.button_group = button_group
	button.icon = texture_resource
	button.toggle_mode = true
	return button

func _generate_texture_resources(list_file_name: Array) -> Array:
	var texture_resources = []
	for file_name in list_file_name:
		var file_path = images_path + file_name
		var texture_resource = load(file_path)
		texture_resources.append(texture_resource)

	return texture_resources

func _filter_files(list_files: Array) -> Array:
	var files_path = []
	var extensions = 'jpg,svg,png'.split(',')
	for file_name in list_files:
		if file_name.get_extension() in extensions:
			files_path.append(file_name)

	return files_path

func _on_play_button_pressed():
	var button_image_pressed = image_group.get_pressed_button() as TextureButton
	var button_size_pressed = button_size.get_pressed_button() as Button

	Global.texture_resource = button_image_pressed.texture_normal
	Global.grid_size = int(button_size_pressed.text[0])
	
	get_tree().change_scene_to_file(Config.GAME_SCENE_PATH)
