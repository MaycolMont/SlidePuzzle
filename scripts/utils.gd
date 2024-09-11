extends Node
class_name Utils

static func vector_product(vector1: Vector2, vector2: Vector2):
	return Vector2(vector1.x * vector2.x, vector1.y * vector2.y)
