extends Control

@export var texture_preview : TextureRect
@export var board_scene : PackedScene
@export var time_label : Label

func _ready():
	_set_board()
	_set_image_preview()
	time_label.start()

func _set_image_preview():
	texture_preview.texture = Global.texture_resource

func _set_board():
	var board = board_scene.instantiate()
	board.size = Vector2.ONE * 128
	board.texture = Global.texture_resource
	board.pieces_range = Vector2i.ONE * Global.grid_size
	board.solved.connect(_on_board_solved)
	$VBoxContainer/PanelContainer.add_child(board)

func _on_board_solved(number_of_movements):
	time_label.stop()
	print_debug($VBoxContainer/HBoxContainer/TimeLabel.time_text)
