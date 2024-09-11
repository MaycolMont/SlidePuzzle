extends Node2D

var size : Vector2 = Vector2.ONE * 128
var pieces_range : Vector2i = Vector2i.ONE * 3
var image_path : String = 'res://icon.svg'
var movements : int
var points : int

@export var piece_scene : PackedScene

func _ready():
	_generate_pieces()

func _process(delta):
	pass

func _set_margins():
	for i in range(2):
		var area2d = Area2D.new()
		var collision_shape2d = CollisionShape2D.new()
		collision_shape2d.shape = SegmentShape2D.new()
		collision_shape2d.shape
		area2d.monitoring = false
		# area2d.add_child(collision_shape2d)

func _generate_pieces() -> void:
	var piece_size = Vector2(size.x/pieces_range.x, size.y/pieces_range.y)
	for j in range(pieces_range.y):
		for i in range(pieces_range.x):
			if i == 0 and j == 0:
				continue
			var piece = piece_scene.instantiate()
			piece.image_path = image_path
			piece.size = piece_size
			piece.correct_position = Vector2i(i, j)
			piece.position = Vector2(i * piece_size.x, j * piece_size.y)
			piece.moved.connect(_on_piece_moved)
			add_child(piece)

func _on_piece_moved(current_position, correct_position):
	movements += 1
	if current_position == correct_position:
		points += 1
	else:
		points -= 1
