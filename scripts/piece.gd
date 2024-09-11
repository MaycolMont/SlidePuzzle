extends Area2D

signal moved(current_position, correct_position)

var size : Vector2
var current_position : Vector2
var correct_position : Vector2
var image_path : String
var in_correct_position : bool

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
	var region_position = Utils.vector_product(correct_position, size)
	sprite.region_rect = Rect2(region_position, size)

func _set_raycasts() -> void:
	for i in range(4):
		var raycast2d = RayCast2D.new()
		raycast2d.collide_with_areas = true
		raycast2d.target_position.y = (size.x / 2) + 10
		raycast2d.target_position = raycast2d.target_position.rotated(i * (PI/2))
		add_child(raycast2d)

func _get_free_direction() -> Vector2:
	var array_raycasts = []
	for child in get_children():
		if child is RayCast2D:
			if not child.is_colliding():
				return child.target_position.normalized()

	return Vector2.ZERO

func _try_move() -> void:
	var direction = _get_free_direction()
	if direction:
		var was_correct_position = correct_position == current_position
		current_position += direction
		var current_correct = correct_position == current_position
		moved.emit(current_correct, was_correct_position)
		position += Utils.vector_product(direction, size)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_try_move()
