extends MarginContainer

@onready var images_container = %ImagesSelector
var images_path : String = 'res://assets/sprites/images/'
var image_group : ButtonGroup = load('res://UI/images_group.tres')

@export var button_size : Button

func _ready():
	_set_options(images_container, images_path, image_group)

func _set_options(options_container, path, button_group):
	var file_names = DirAccess.get_files_at(path)
	file_names = _filter_files(file_names)
	var textures_resources = _get_texture_resources(file_names)
	_generate_buttons(options_container, textures_resources)

func _generate_buttons(buttons_container, texture_resources : Array):
	var image_buttons = images_container.get_children()
	var i = 0
	for texture_resource in texture_resources:
		var image_button = image_buttons[i] as TextureButton
		image_button.texture_normal = texture_resource
		i += 1

func _create_button(button_group, texture_resource):
	var button = Button.new()
	button.button_group = button_group
	button.icon = texture_resource
	button.toggle_mode = true
	button.expand_icon
	return button

func _get_texture_resources(list_file_name: Array):
	var texture_resources = []
	for file_name in list_file_name:
		var file_path = images_path + file_name
		var texture_resource = load(file_path)
		texture_resources.append(texture_resource)

	return texture_resources

func _filter_files(list_files: Array):
	var files_path = []
	var extensions = 'jpg,svg,png'.split(',')
	for file_name in list_files:
		if file_name.get_extension() in extensions:
			files_path.append(file_name)

	return files_path

func _on_play_button_pressed():
	var button_image_pressed = image_group.get_pressed_button() as Button
	Global.texture_resource = button_image_pressed.texture_normal
	
	var button_size_pressed = button_size.button_group.get_pressed_button() as Button
	Global.grid_size = int(button_size_pressed.text[0])
	
	get_tree().change_scene_to_file('res://scenes/game.tscn')
