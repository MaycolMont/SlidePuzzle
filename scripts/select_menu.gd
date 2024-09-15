extends VBoxContainer

@onready var image_button = $VBoxContainer/ImagesSelector/Button
@onready var size_button = $VBoxContainer2/SizeSelector/Button

func _on_play_button_pressed():
	print(image_button.button_group.get_pressed_button())
