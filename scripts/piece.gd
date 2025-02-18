extends Area2D
class_name Piece

signal moved(correct_moved, free_position) # => board
signal tried_move(current_position) # => board

var size : float
var current_position : Vector2
var correct_position : Vector2
var raycast : RayCast2D

func _ready():
	_set_dimensions()
	_add_raycast()

#region private methods
func _set_dimensions() -> void:
	var vector_size: Vector2 = Vector2.ONE * size
	$CollisionShape2D.shape.size = vector_size

func _add_raycast() -> void:
	var raycast2d: RayCast2D = RayCast2D.new()
	raycast2d.collide_with_areas = true
	raycast2d.target_position.y = (size / 2) + 10
	add_child(raycast2d)
	raycast = raycast2d

func _get_free_direction() -> Vector2:
	var angle: float = PI/2
	for i in range(4):
		var new_direction = raycast.target_position.rotated(angle)
		raycast.target_position = Vector2(int(new_direction.x), int(new_direction.y))
		raycast.force_raycast_update()

		if not raycast.is_colliding():
			return raycast.target_position.normalized()

	return Vector2.ZERO

func _move(direction: Vector2) -> void:
	var correct_move: int = 0
	if is_in_correct():
		correct_move = -1
	current_position += direction
	if is_in_correct():
		correct_move = 1
	moved.emit(correct_move, current_position - direction)
	position += direction * size
#endregion

#region public methods
func set_texture(texture: Texture2D, grid_size: int, factor_scale: float) -> void:
	var sprite = $Sprite2D
	sprite.texture = texture
	sprite.hframes = grid_size
	sprite.vframes = grid_size
	sprite.frame_coords = correct_position
	sprite.scale *= factor_scale

func is_in_correct() -> bool:
	return correct_position == current_position

func push_to(direction: Vector2) -> void:
	"""
	Pushes all pieces in one direction until that a piece
	doesn't have a piece neighboor
	"""
	
	var raycast_lenght: float = raycast.target_position.length()
	var new_target_position: Vector2 = direction * raycast_lenght
	raycast.target_position = new_target_position
	raycast.force_raycast_update()

	if raycast.get_collider() is Piece:
		var piece_neighbor: Piece = raycast.get_collider()
		piece_neighbor.push_to(direction)
	_move(direction)
#endregion

#region signals handlers
func _on_input_event(_viewport, event, _shape_idx):
	"""
	Handles the event when a piece has been clicked
		
	Moved the piece if it has a empty space next to it or emit a signal if
	it couldn't move
	"""
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var direction: Vector2 = _get_free_direction()
			if direction:
				_move(direction)
			else:
				tried_move.emit(self)
#endregion
