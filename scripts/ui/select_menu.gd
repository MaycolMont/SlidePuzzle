extends MarginContainer

@onready var images_container = %ImagesSelector

@export var button_size : Button
var _reference_button_image : TextureButton

var images_path : String = Config.IMAGES_PATH
var image_group : ButtonGroup = load(Config.IMAGE_GROUP_PATH)


func _ready():
	_set_options(images_container, images_path, image_group)

func _set_options(options_container, path, button_group) -> void:
	var file_names = DirAccess.get_files_at(path)
	file_names = _filter_files(file_names)
	var textures_resources = _generate_texture_resources(file_names)
	_generate_buttons(options_container, textures_resources)

func _generate_buttons(buttons_container, texture_resources : Array) -> void:
	var image_buttons = images_container.get_children()
	var i = 0
	for texture_resource in texture_resources:
		var image_button = image_buttons[i] as TextureButton
		image_button.texture_normal = texture_resource
		i += 1
		if i == len(texture_resources):
			_reference_button_image = image_button

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
	var button_image_pressed = _reference_button_image.button_group.get_pressed_button() as Button
	print(button_image_pressed)

	var button_size_pressed = button_size.button_group.get_pressed_button() as Button
	Global.grid_size = int(button_size_pressed.text[0])
	print(button_size_pressed)
	
	get_tree().change_scene_to_file(Config.GAME_SCENE_PATH)
