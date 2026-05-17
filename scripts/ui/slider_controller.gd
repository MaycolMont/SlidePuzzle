extends VBoxContainer
## Controller for a slider with a label showing the percentage value.

## Initial value for the slider (0-100).
@export var initial_value: int = 75

@onready var slider: HSlider = $HBoxContainer/HSlider
@onready var percentage_label: Label = $HBoxContainer/Label

func _ready() -> void:
	slider.value_changed.connect(_on_slider_value_changed)
	slider.value = initial_value
	_update_label()

## Updates the percentage label when the slider value changes.
func _on_slider_value_changed(value: float) -> void:
	_update_label()

## Updates the label text to show current percentage.
func _update_label() -> void:
	percentage_label.text = "%d%%" % slider.value
