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
	var piece_size = Vector2(size.x/pieces_range.x, size.y/pieces_range.y)
	var offset_pivot = piece_size/2
	for j in range(pieces_range.y):
		for i in range(pieces_range.x):
			if i == 0 and j == 0:
				continue
			var piece = piece_scene.instantiate()
			piece.image_path = image_path
			piece.size = piece_size
			piece.correct_position = Vector2i(i, j)
			piece.position = Vector2(i * piece_size.x, j * piece_size.y) + offset_pivot
			piece.moved.connect(_on_piece_moved)
			add_child(piece)

func _create_piece(size, current_position, correct_position):
	pass

func _mix_pieces():
	pass

func _on_piece_moved(current_position, correct_position):
	movements += 1
	if current_position == correct_position:
		points += 1
	else:
		points -= 1
