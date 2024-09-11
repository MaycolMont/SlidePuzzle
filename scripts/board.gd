extends Node2D

var size : Vector2 = Vector2.ONE * 128
var pieces_range : Vector2i = Vector2i.ONE * 3
var image_path : String = 'res://icon.svg'
var movements : int = 0
var points : int = 0

@export var piece_scene : PackedScene

func _ready():
	_generate_pieces()
	_set_margins()

func _process(delta):
	pass

func _set_margins():
	for i in range(4):
		var area2d = Area2D.new()
		var vector_b = Vector2.RIGHT
		vector_b = vector_b.rotated(i*(PI/2))
		vector_b = Utils.vector_product(vector_b, size)
		var segment_shape2d = SegmentShape2D.new()
		segment_shape2d.b = vector_b
		if i > 1:
			segment_shape2d.a += size
			segment_shape2d.b += size
		
		var collision_shape2d = CollisionShape2D.new()
		collision_shape2d.shape = segment_shape2d
		area2d.monitoring = false
		
		area2d.add_child(collision_shape2d)
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
			var random_position = Utils.random_vector2(pieces_range.x, pieces_range.y)
			while random_position in occupied_position:
				random_position = Utils.random_vector2(pieces_range.x, pieces_range.y)
			occupied_position.append(random_position)
			piece.current_position = Vector2(random_position)
			piece.position = Utils.vector_product(random_position, piece_size) + offset_pivot

			add_child(piece)

func _create_piece(size, correct_position):
	pass
	var piece = piece_scene.instantiate()
	piece.image_path = image_path
	piece.size = size
	piece.correct_position = correct_position
	piece.moved.connect(_on_piece_moved)

	return piece

func _mix_pieces():
	pass

func _on_piece_moved(current_correct, was_correct_position):
	movements += 1
	if current_correct:
		points += 1
	elif was_correct_position:
		points -= 1
	print(points)
