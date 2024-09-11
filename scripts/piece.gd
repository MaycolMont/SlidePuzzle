extends Area2D
class_name Piece

signal in_correct_position

var size : Vector2
var current_position : Vector2i
var correct_position : Vector2i
var image_path : String

func _ready():
	_set_dimensions()
	_set_raycasts()

func _process(delta):
	pass

func _set_dimensions() -> void:
	$CollisionShape2D.shape.size = size
	var texture_resource = load(image_path)
	var sprite = $Sprite2D
	sprite.texture = texture_resource
	var region_position = Vector2(correct_position.x * size.x, correct_position.y * size.y)
	sprite.region_rect = Rect2(region_position, size)

func _set_raycasts() -> void:
	for i in range(4):
		var raycast2d = RayCast2D.new()
		raycast2d.collide_with_areas = true
		raycast2d.target_position.y = (size.x / 2) + 10
		raycast2d.target_position = raycast2d.target_position.rotated(i * (PI/2))
		raycast2d.add_to_group('raycast')
		add_child(raycast2d)

func _get_free_direction() -> Vector2:
	var array_raycasts = []
	for child in get_children():
		if child is RayCast2D:
			array_raycasts.append(child)

	for raycast2d in array_raycasts:
		if not raycast2d.is_colliding:
			return raycast2d.target_position.normalized()

	return Vector2.ZERO

func _try_move() -> void:
	var direction = _get_free_direction()
	current_position += Vector2i(direction)
	if current_position == correct_position:
		in_correct_position.emit()
	position += direction * size

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_try_move()
