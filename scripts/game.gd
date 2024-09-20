extends Control

@export var texture_preview : TextureRect
@export var board_scene : PackedScene
@export var time_label : Label
@export var board_container : PanelContainer

func _ready():
	_verify_data()
	_set_board()
	_set_image_preview()
	time_label.start()

func _set_image_preview():
	texture_preview.texture = Global.texture_resource

func _set_board():
	var board = board_scene.instantiate()
	board.size = 220
	board.texture = Global.texture_resource
	board.pieces_range = Global.grid_size
	board.solved.connect(_on_board_solved)
	board_container.add_child(board)
	
func _verify_data():
	if not Global.texture_resource:
		Global._simulate_test_data()

func _on_board_solved(number_of_movements):
	time_label.stop()
	print_debug($VBoxContainer/HBoxContainer/TimeLabel.time_text)
