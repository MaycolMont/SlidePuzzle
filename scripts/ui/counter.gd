extends BaseLabel

var cont: int = 0

func _ready():
	super._ready()
	set_value(str(cont))

func _on_movements_increased() -> void:
	cont += 1
	set_value(str(cont))
