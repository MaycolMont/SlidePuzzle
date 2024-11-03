extends TabContainer

func _ready():
	Global.load_data()
	add_times()

func add_times():
	var tabs = get_children()
	var times = Global.game_data as Dictionary
	for tab in tabs:
		var grid_size = int(str(tab.name)[0])
		var container = tab.get_child(0)
		if times.has(grid_size):
			var tab_times = times[grid_size]
			_add_labels(tab_times, container)

func _add_labels(times : Array, container: VBoxContainer):
	for time in times:
		var label = Label.new()
		label.text = Utils.get_format_time(time)
		container.add_child(label)
