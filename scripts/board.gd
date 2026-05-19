extends Node2D
class_name Board
## Generates and manages puzzle pieces on a grid.
## Tracks the free slot, detects when the puzzle is solved, and emits
## [signal solved].

## Emitted when all pieces are in their correct positions.
signal solved(number_of_movements: int)

## Preloaded [Piece] scene to instantiate for each grid cell.
@export var piece_scene: PackedScene

## Side length of the board area in pixels (shared with margin borders).
var size: int
## Number of divisions per row/column (e.g. 3 for a 3x3 grid).
var pieces_range: int
## The puzzle image assigned to all pieces (each piece shows one segment).
var texture: Texture2D
## Total moves made by the player.
var number_of_movements: int = 0
## Total number of pieces (pieces_range^2 - 1, excluding the free slot).
var total_pieces: int
## How many pieces are currently in their correct position.
var points: int = 0
## Grid coordinates of the empty (free) slot.
var free_position: Vector2

func _ready() -> void:
	_set_margins()
	_generate_pieces()

#region private methods
## Generates four [SegmentShape2D] borders around the board perimeter.
func _generate_segments() -> Array[SegmentShape2D]:
	var segments: Array[SegmentShape2D] = []
	for i: int in range(4):
		var vector_b: Vector2 = Vector2.RIGHT
		vector_b = vector_b.rotated(i * (PI / 2)) * size
		var segment_shape2d: SegmentShape2D = SegmentShape2D.new()
		segment_shape2d.b = vector_b
		if i > 1:
			segment_shape2d.a += Vector2.ONE * size
			segment_shape2d.b += Vector2.ONE * size
		segments.append(segment_shape2d)
	return segments

## Creates four invisible collision borders around the board.
func _set_margins() -> void:
	var segments: Array[SegmentShape2D] = _generate_segments()
	for i: int in range(4):
		var area2d: Area2D = Area2D.new()
		var collision_shape2d: CollisionShape2D = CollisionShape2D.new()
		collision_shape2d.shape = segments[i]
		area2d.monitoring = false
		area2d.add_child(collision_shape2d)
		area2d.add_to_group('border')
		add_child(area2d)

## Creates all puzzle pieces, shuffles their positions, and adds them as children.
func _generate_pieces() -> void:
	total_pieces = (pieces_range ** 2) - 1
	var occupied_position: Array[Vector2] = []
	@warning_ignore("integer_division")
	var piece_size: int = size / pieces_range
	@warning_ignore("integer_division")
	var offset_pivot: Vector2 = Vector2.ONE * (piece_size / 2)
	var texture_scale: float = size / texture.get_size().x

	for j: int in range(pieces_range):
		for i: int in range(pieces_range):
			if i == 0 and j == 0:
				continue
			var piece: Piece = _create_piece(piece_size, Vector2(i, j))
			piece.set_texture(texture, pieces_range, texture_scale)
			var random_position: Vector2 = _get_unique_vector(occupied_position)
			piece.current_position = random_position
			points += int(piece.is_in_correct())
			piece.position = piece_size * random_position + offset_pivot
			add_child(piece)

	free_position = _get_unique_vector(occupied_position)

## Returns a random [Vector2] within the grid that is not in [array].
## Used to shuffle pieces into unique starting positions.
func _get_unique_vector(array: Array) -> Vector2:
	var random_position: Vector2 = Utils.random_vector2(pieces_range, pieces_range)
	while random_position in array:
		random_position = Utils.random_vector2(pieces_range, pieces_range)
	array.append(random_position)
	return random_position

## Instantiates a [Piece], sets its size and correct position, and connects signals.
func _create_piece(piece_size: float, correct_position: Vector2) -> Piece:
	var piece: Piece = piece_scene.instantiate()
	piece.size = piece_size
	piece.correct_position = correct_position
	piece.moved.connect(_on_piece_moved)
	piece.tried_move.connect(_on_piece_tried_move)
	return piece
#endregion

#region signal handlers
## Handles a piece move. Tracks points, updates free_position, and checks win.
func _on_piece_moved(correct_moved: int, preview_position: Vector2) -> void:
	number_of_movements += 1
	points += correct_moved
	free_position = preview_position
	print_debug("Pieces in correct position: %d" % points)

	if points == 4: #debug
	#if points == total_pieces:
		solved.emit(number_of_movements)
		print_debug("Solved emit")

## Handles a click on a piece with no adjacent free slot.
## If the piece is aligned with the free slot (same row or column), pushes
## the entire chain in that direction.
func _on_piece_tried_move(piece: Piece) -> void:
	var piece_position: Vector2 = piece.current_position
	var in_column: bool = piece_position.x == free_position.x
	var in_row: bool = piece_position.y == free_position.y
	if in_row or in_column:
		var direction_move: Vector2 = (free_position - piece_position).normalized()
		piece.push_to(direction_move)
#endregion
