extends Area2D
class_name Piece
## A single puzzle piece. Displays one segment of the image, detects clicks,
## and moves via [RayCast2D] to find the free slot or chain-push neighbours.

## Emitted when the piece moves. [param correct_moved] is -1, 0, or +1
## indicating whether the piece left/entered its correct position.
## [param free_position] is the grid position vacated by this move.
signal moved(correct_moved: int, free_position: Vector2)
## Emitted when the piece is clicked but has no adjacent free slot.
## [param piece] is the piece that tried to move; the board checks alignment
## with the free slot and triggers a multi-push if applicable.
signal tried_move(piece: Piece)

## Visual/logical size of the piece in pixels.
var size: float
## Current grid position of the piece (may differ from [member correct_position]).
var current_position: Vector2
## The grid position this piece must occupy to be "correct".
var correct_position: Vector2
## Internal [RayCast2D] used for collision detection.
var raycast: RayCast2D

## Duration of the movement animation in seconds.
var move_duration: float = 0.15

func _ready() -> void:
	_set_dimensions()
	_add_raycast()

#region private methods
## Sets the [CollisionShape2D] size to match the piece dimensions.
func _set_dimensions() -> void:
	var vector_size: Vector2 = Vector2.ONE * size
	$CollisionShape2D.shape.size = vector_size

## Creates and configures the [RayCast2D] for detecting neighbours and the free slot.
func _add_raycast() -> void:
	var raycast2d: RayCast2D = RayCast2D.new()
	raycast2d.collide_with_areas = true
	raycast2d.target_position.y = (size / 2) + 10
	add_child(raycast2d)
	raycast = raycast2d

## Rotates the raycast in 90-degree increments and returns the first direction
## that does not collide (i.e. points toward the free slot).
func _get_free_direction() -> Vector2:
	var angle: float = PI / 2
	for i: int in range(4):
		var new_direction: Vector2 = raycast.target_position.rotated(angle)
		raycast.target_position = Vector2(int(new_direction.x), int(new_direction.y))
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			return raycast.target_position.normalized()
	return Vector2.ZERO

## Moves the piece by [direction] and emits [signal moved].
## Tracks whether the piece enters or leaves its correct position.
## Uses a Tween for smooth, quick animation.
func _move(direction: Vector2) -> void:
	var correct_move: int = 0
	if is_in_correct():
		correct_move = -1
	current_position += direction
	var target_position: Vector2 = current_position - direction
	if is_in_correct():
		correct_move = 1

	var target_visual: Vector2 = position + direction * size
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", target_visual, move_duration)
	tween.tween_callback(moved.emit.bind(correct_move, target_position))
	$SlideAudio.play()
#endregion

#region public methods
## Configures the [Sprite2D] to show the correct segment of the puzzle image.
func set_texture(texture: Texture2D, grid_size: int, factor_scale: float) -> void:
	var sprite: Sprite2D = $Sprite2D
	sprite.texture = texture
	sprite.hframes = grid_size
	sprite.vframes = grid_size
	sprite.frame_coords = correct_position
	sprite.scale *= factor_scale

## Whether the piece is at its correct grid position.
func is_in_correct() -> bool:
	return correct_position == current_position

## Recursively pushes a chain of pieces in [direction].
## Stops when the leading piece finds no neighbour.
func push_to(direction: Vector2) -> void:
	var raycast_lenght: float = raycast.target_position.length()
	var new_target_position: Vector2 = direction * raycast_lenght
	raycast.target_position = new_target_position
	raycast.force_raycast_update()

	if raycast.get_collider() is Piece:
		var piece_neighbor: Piece = raycast.get_collider()
		piece_neighbor.push_to(direction)
	_move(direction)
#endregion

#region signal handlers
## Handles left-click on the piece. Moves toward the free slot if adjacent,
## otherwise emits [signal tried_move] so the board can attempt a multi-push.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var direction: Vector2 = _get_free_direction()
			if direction:
				_move(direction)
			else:
				tried_move.emit(self)
#endregion
