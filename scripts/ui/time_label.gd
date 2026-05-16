extends Label
class_name TimeLabel
## Displays elapsed time since [method start] was called. Uses an internal
## [Timer] node for counting seconds.

## Prefix text shown before the time (e.g. "Time").
@export var label_text: String = 'Time'
## The current time string (MM:SS).
var time_text: String = '00:00'

## Elapsed hours (unused).
var hour: int = 0
## Elapsed minutes.
var minute: int = 0
## Elapsed seconds.
var second: int = 0

func _ready() -> void:
	text = '%s %s' % [label_text, time_text]

## Starts the internal timer.
func start() -> void:
	$Timer.start()

## Stops the timer and returns total elapsed seconds.
func get_time() -> int:
	$Timer.stop()
	return second + minute * 60

## Advances the time by one second and updates the display.
func _on_timer_timeout() -> void:
	second += 1
	if second == 60:
		minute += 1
		second = 0
	time_text = '%02d:%02d' % [minute, second]
	text = '%s %s' % [label_text, time_text]
