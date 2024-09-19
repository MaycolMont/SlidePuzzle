extends Node2D
class_name Board

"""
A piece

Parameter
---------
size
	size of the board
"""

signal solved(number_of_movements)

var size : Vector2
var pieces_range : Vector2i
var texture : Texture2D
var number_of_movements : int = 0
var total_pieces : int
var points : int = 0
var free_position : Vector2

@export var piece_scene : PackedScene

func _ready():
	_set_margins()
	_generate_pieces()

func _generate_segments():
	var segments = []
	for i in range(4):
		var vector_b = Vector2.RIGHT
		vector_b = vector_b.rotated(i*(PI/2))
		vector_b = Utils.vector_product(vector_b, size)
		var segment_shape2d = SegmentShape2D.new()
		segment_shape2d.b = vector_b
		if i > 1:
			segment_shape2d.a += size
			segment_shape2d.b += size

		segments.append(segment_shape2d)
	return segments

func _set_margins():
	var segments = _generate_segments()

	for i in range(4):
		var area2d = Area2D.new()
		var collision_shape2d = CollisionShape2D.new()
		collision_shape2d.shape = segments[i]
		area2d.monitoring = false

		area2d.add_child(collision_shape2d)
		area2d.add_to_group('border')
		add_child(area2d)

func _generate_pieces() -> void:
	var occupied_position = []
	var piece_size = Vector2(size.x/pieces_range.x, size.y/pieces_range.y)
	var offset_pivot = piece_size/2
	for j in range(pieces_range.y):
		for i in range(pieces_range.x):
			if i == 0 and j == 0:
				continue
			var piece = _create_piece(piece_size, Vector2(i, j))
			var random_position = _get_unique_vector(occupied_position)
			piece.current_position = Vector2(random_position)
			points += int(piece.is_in_correct())
			piece.position = Utils.vector_product(random_position, piece_size) + offset_pivot
			total_pieces += 1

			add_child(piece)

func _get_unique_vector(array: Array):
	var random_position = Utils.random_vector2(pieces_range.x, pieces_range.y)
	while random_position in array:
		random_position = Utils.random_vector2(pieces_range.x, pieces_range.y)
	array.append(random_position)

	return random_position

func _create_piece(size, correct_position):
	var piece = piece_scene.instantiate()
	piece.texture = texture
	piece.size = size
	piece.correct_position = correct_position
	piece.moved.connect(_on_piece_moved)
	piece.tried_move.connect(_on_piece_tried_move)

	return piece

func _mix_pieces():
	pass

func _on_piece_moved(correct_moved, preview_position):
	number_of_movements += 1
	points += correct_moved
	free_position = preview_position
	if points == total_pieces:
		solved.emit(number_of_movements)
		print_debug('board solved')

func _on_piece_tried_move(piece: Piece):
	var piece_position = piece.current_position
	var in_column = piece_position.x == free_position.x
	var in_row = piece_position.y == free_position.y
	if in_row or in_column:
		var direction_move = (free_position - piece_position).normalized()
		piece.push_to(direction_move)
