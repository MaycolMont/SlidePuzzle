extends Node
class_name Utils
## Static helper methods used across the project.

## Component-wise multiplication of two vectors.
static func vector_product(vector1: Vector2, vector2: Vector2) -> Vector2:
	return Vector2(vector1.x * vector2.x, vector1.y * vector2.y)

## Returns a random [Vector2] with integer components in [0, [param max_x]) and
## [0, [param max_y]).
static func random_vector2(max_x: int, max_y: int) -> Vector2:
	var x: int = randi_range(0, max_x - 1)
	var y: int = randi_range(0, max_y - 1)
	return Vector2(x, y)

## Formats a time in seconds as [code]MM:SS[/code].
static func get_format_time(time: float) -> String:
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	return '%02d:%02d' % [minutes, seconds]
