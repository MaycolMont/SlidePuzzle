extends Control

@export var timer : Timer
@export var texture_preview : TextureRect
@export var board_scene : PackedScene

func _ready():
	_set_board()
	_set_image_preview()
	timer.start()

func _set_image_preview():
	texture_preview.texture = Global.texture_resource
	texture_preview.scale = Vector2.ONE * 0.5

func _set_board():
	var board = board_scene.instantiate()
	board.size = Vector2.ONE * 128
	board.texture = Global.texture_resource
	board.pieces_range = Vector2i.ONE * Global.grid_size
	$VBoxContainer/PanelContainer.add_child(board)

func _on_board_solved(number_of_movements):
	timer.stop()
