extends Node2D
class_name Board

signal solved(number_of_movements) # => game.gd

@export var piece_scene : PackedScene

var size : int
var pieces_range : int
var texture : Texture2D
var number_of_movements : int = 0
var total_pieces : int
var points : int = 0
var free_position : Vector2


func _ready():
	_set_margins()
	_generate_pieces()

#region private methods
func _generate_segments() -> Array[SegmentShape2D]:
	var segments: Array[SegmentShape2D] = []
	for i in range(4):
		var vector_b: Vector2 = Vector2.RIGHT
		vector_b = vector_b.rotated(i*(PI/2)) * size
		var segment_shape2d: SegmentShape2D = SegmentShape2D.new()
		segment_shape2d.b = vector_b
		if i > 1:
			segment_shape2d.a += Vector2.ONE * size
			segment_shape2d.b += Vector2.ONE * size

		segments.append(segment_shape2d)
	return segments

func _set_margins() -> void:
	var segments: Array = _generate_segments()

	for i in range(4):
		var area2d = Area2D.new()
		var collision_shape2d = CollisionShape2D.new()
		collision_shape2d.shape = segments[i]
		area2d.monitoring = false

		area2d.add_child(collision_shape2d)
		area2d.add_to_group('border')
		add_child(area2d)

func _generate_pieces() -> void:
	total_pieces = (pieces_range ** 2) - 1
	var occupied_position: Array[Vector2] = []
	@warning_ignore("integer_division")
	var piece_size = size / pieces_range
	@warning_ignore("integer_division")
	var offset_pivot: Vector2 = Vector2.ONE * (piece_size/2)
	var texture_scale: float = size / texture.get_size().x
	print_debug(texture_scale)
	for j in range(pieces_range):
		for i in range(pieces_range):
			if i == 0 and j == 0:
				continue
			var piece: Piece = _create_piece(piece_size, Vector2(i, j))
			piece.set_texture(texture, pieces_range, texture_scale)
			var random_position: Vector2 = _get_unique_vector(occupied_position)
			piece.current_position = random_position
			points += int(piece.is_in_correct())
			piece.position = piece_size * random_position + offset_pivot

			add_child(piece)

	free_position = _get_unique_vector(occupied_position) # establece la última posición dentro del rango como libre

func _get_unique_vector(array: Array) -> Vector2:
	var random_position: Vector2 = Utils.random_vector2(pieces_range, pieces_range)
	while random_position in array:
		random_position = Utils.random_vector2(pieces_range, pieces_range)
	array.append(random_position)

	return random_position

func _create_piece(piece_size: float, correct_position: Vector2) -> Piece:
	var piece: Piece = piece_scene.instantiate()
	piece.size = piece_size
	piece.correct_position = correct_position
	piece.moved.connect(_on_piece_moved)
	piece.tried_move.connect(_on_piece_tried_move)

	return piece
#endregion


#region signals handlers
func _on_piece_moved(correct_moved: int, preview_position: Vector2) -> void:
	"""
	Emit by a Piece object
	Handles the event when a piece moved and verify if the board has been solved
	
	Increased the number of movements and set points and emit a signal if the
	the board has been solved
	
	Parameters
	----------
	
	"""
	
	number_of_movements += 1
	points += correct_moved
	free_position = preview_position
	print_debug("Pieces in correct position: %d" % points)
	
	# 
	if points == total_pieces - 5:
		solved.emit(number_of_movements)
		print_debug("Solved emit")

func _on_piece_tried_move(piece: Piece) -> void:
	"""
	Emit by a Piece object
	Handles the event when a piece attempts to move.

	This function checks if the piece that tried to move is in the same
	row or column as the free position on the board. If so, it calculates
	the direction of movement and pushes the piece in that direction.

	Parameters
	----------
	piece : Piece
		The piece that attempted to move.
	"""
	
	var piece_position = piece.current_position
	var in_column = piece_position.x == free_position.x
	var in_row = piece_position.y == free_position.y
	if in_row or in_column:
		var direction_move = (free_position - piece_position).normalized()
		piece.push_to(direction_move)
#endregion
