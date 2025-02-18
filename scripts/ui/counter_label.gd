extends Label
class_name BaseLabel

@export var string_text_label: String
@export var value_label: Label
@export var text_label: Label

func _ready():
	text_label.text = string_text_label

func set_value(value: String) -> void:
	value_label.text = value
	
func get_value() -> String:
	return value_label.text
