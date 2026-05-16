extends Label
class_name BaseLabel
## A reusable label pair: a static text label and a dynamic value label.
## Used as a base for counters and score displays.

## Static text describing the value (e.g. "Score", "Moves").
@export var string_text_label: String
## Reference to the child [Label] that displays the current value.
@export var value_label: Label
## Reference to the child [Label] that displays the static text.
@export var text_label: Label

func _ready() -> void:
	text_label.text = string_text_label

## Updates the displayed value.
func set_value(value: String) -> void:
	value_label.text = value

## Returns the current displayed value as text.
func get_value() -> String:
	return value_label.text
