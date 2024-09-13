extends Area2D

signal moved(correct_moved)

var size : Vector2
var current_position : Vector2
var correct_position : Vector2
var image_path : String
var raycast : RayCast2D
var orientations : Array = 'Down,Left,Up,Right'.split(',')

func _ready():
	_set_dimensions()
	_add_raycast()

func _process(delta):
	pass

func _set_dimensions() -> void:
	$CollisionShape2D.shape.size = size
	var texture_resource = load(image_path)
	var sprite = $Sprite2D
	sprite.texture = texture_resource
	var region_position = Utils.vector_product(correct_position, size)
	sprite.region_rect = Rect2(region_position, size)

func _add_raycast() -> void:
	var raycast2d = RayCast2D.new()
	raycast2d.collide_with_areas = true
	raycast2d.target_position.y = (size.x / 2) + 10
	add_child(raycast2d)
	raycast = raycast2d

func _tour_values():
	for orientation in orientations:
		var raycast2d = get_node(orientation)
		var collider = raycast2d.get_collider()
		while not collider.is_in_group('border'):
			pass

func _get_free_direction():
	var angle = PI/2
	for i in range(4):
		var new_direction = raycast.target_position.rotated(angle)
		raycast.target_position = Vector2(int(new_direction.x), int(new_direction.y))
		raycast.force_raycast_update()

		if not raycast.is_colliding():
			return raycast.target_position.normalized()

	return Vector2.ZERO

func _try_move() -> void:
	var direction = _get_free_direction()
	if direction:
		var correct_move = 0
		if is_in_correct():
			correct_move = -1
		current_position += direction
		if is_in_correct():
			correct_move = 1
		moved.emit(correct_move)
		position += Utils.vector_product(direction, size)

func is_in_correct():
	return correct_position == current_position

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_try_move()
