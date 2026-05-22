extends VBoxContainer
class_name LabeledSlider
## Controller for a slider with a label showing the percentage value.

## Initial value for the slider (0-100).
@export var initial_value: int = 75
@export var slider: HSlider
@export var percentage_label: Label

func _ready() -> void:
	slider.value_changed.connect(_on_slider_value_changed)
	slider.value = Config.master_volume
	_update_label()

## Updates the percentage label and sets the master audio volume when the slider
## value changes.
func _on_slider_value_changed(value: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))
	Config.master_volume = value
	Config.save_settings()
	_update_label()

## Updates the label text to show current percentage.
func _update_label() -> void:
	percentage_label.text = "%d%%" % slider.value
