extends BaseLabel
## Counter that increments on each move. Extends [BaseLabel] to display
## the current move count.

## Internal move counter.
var cont: int = 0

func _ready() -> void:
	super._ready()
	set_value(str(cont))

## Increments the counter and updates the displayed value.
func _on_movements_increased() -> void:
	cont += 1
	set_value(str(cont))
