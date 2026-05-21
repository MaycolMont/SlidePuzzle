extends TextureButton
## Button that scales up smoothly when hovered and returns to normal size when
## the mouse leaves.

## Scale factor when the mouse is hovering.
@export var hover_scale: float = 1.1
## Duration of the scale animation in seconds.
@export var anim_duration: float = 0.12

var _original_scale: Vector2

func _ready() -> void:
	_original_scale = scale
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", _original_scale * hover_scale, anim_duration)

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", _original_scale, anim_duration)
