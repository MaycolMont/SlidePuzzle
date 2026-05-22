extends TextureButton
class_name MyTextureButton
## Button that scales up smoothly when hovered, plays a tap animation on press,
## and shows a darker color when selected (toggled on).

@export_group("Animation")
## Scale factor when the mouse is hovering.
@export var hover_scale: float = 1.1
## Scale factor during the tap press.
@export var tap_scale: float = 0.95
## Duration of the scale animation in seconds.
@export var anim_duration: float = 0.12
## Duration of the tap animation in seconds.
@export var tap_duration: float = 0.08
## Color modulation when the button is selected (toggled on).
@export var selected_color: Color = Color(0.7, 0.7, 0.7)

@export_group("Audio")
@export var hover_audio: AudioStreamPlayer
@export var confirm_audio: AudioStreamPlayer

var _original_scale: Vector2

func _ready() -> void:
	_original_scale = scale
	pivot_offset = size * 0.5
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	toggled.connect(_on_toggled)

func _on_mouse_entered() -> void:
	if not button_pressed:
		var tween: Tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", _original_scale * hover_scale, anim_duration)
	hover_audio.play()

func _on_mouse_exited() -> void:
	if not button_pressed:
		var tween: Tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", _original_scale, anim_duration)

func _on_pressed() -> void:
	confirm_audio.play()
	var target_scale: Vector2 = _original_scale * tap_scale
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, tap_duration)
	tween.tween_property(self, "scale", _original_scale * hover_scale if is_hovered() else _original_scale, anim_duration)

func _on_toggled(toggled_on: bool) -> void:
	self_modulate = selected_color if toggled_on else Color.WHITE
