extends Node
class_name Utils

static func vector_product(vector1: Vector2, vector2: Vector2):
	return Vector2(vector1.x * vector2.x, vector1.y * vector2.y)

static func random_vector2(max_x: int, max_y: int) -> Vector2:
	var x = randi_range(0, max_x - 1)
	var y = randi_range(0, max_y - 1)
	return Vector2(x, y)
