extends Label
class_name TimeLabel

@export var label_text : String = 'Time'
var time_text : String = '00:00'

func _ready():
	text = '%s %s' % [label_text, time_text]

var hour : int = 0
var minute : int = 0
var second : int = 0

func start():
	$Timer.start()
	
func stop():
	$Timer.stop()

func _on_timer_timeout():
	second += 1
	if second == 60:
		minute += 1
		second = 0
	time_text = '%02d:%02d' % [minute, second]
	text = '%s %s' % [label_text, time_text]
