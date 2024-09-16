extends Area2D
class_name Piece

signal moved(correct_moved, free_position)
signal tried_move(current_position)

var size : Vector2
var current_position : Vector2
var correct_position : Vector2
var texture : Texture2D
var raycast : RayCast2D

func _ready():
	_set_dimensions()
	_add_raycast()

func _set_dimensions() -> void:
	$CollisionShape2D.shape.size = size
	var sprite = $Sprite2D
	sprite.texture = texture
	var region_position = Utils.vector_product(correct_position, size)
	sprite.region_rect = Rect2(region_position, size)

func _add_raycast() -> void:
	var raycast2d = RayCast2D.new()
	raycast2d.collide_with_areas = true
	raycast2d.target_position.y = (size.x / 2) + 10
	add_child(raycast2d)
	raycast = raycast2d

func _get_free_direction():
	var angle = PI/2
	for i in range(4):
		var new_direction = raycast.target_position.rotated(angle)
		raycast.target_position = Vector2(int(new_direction.x), int(new_direction.y))
		raycast.force_raycast_update()

		if not raycast.is_colliding():
			return raycast.target_position.normalized()

	return Vector2.ZERO

func _move(direction) -> void:
	var correct_move = 0
	if is_in_correct():
		correct_move = -1
	current_position += direction
	if is_in_correct():
		correct_move = 1
	moved.emit(correct_move, current_position - direction)
	position += Utils.vector_product(direction, size)

func is_in_correct():
	return correct_position == current_position

func push_to(direction: Vector2) -> void:
	var raycast_lenght = raycast.target_position.length()
	var new_target_position = direction * raycast_lenght
	raycast.target_position = new_target_position
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var piece_neighbor = raycast.get_collider()
		piece_neighbor.push_to(direction)
	_move(direction)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var direction = _get_free_direction()
			if direction:
				_move(direction)
			else:
				tried_move.emit(self)
