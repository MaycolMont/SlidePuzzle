extends TabContainer

func add_times():
	var tabs = get_children()
	var times = Global.game_data
	for tab in tabs:
		var grid_size = int(tab.name[0])
		var container = get_child(0)
		var tab_times = times[grid_size]
		_add_labels(tab_times, container)
		
func _add_labels(texts : Array[String], container: VBoxContainer):
	for text in texts:
		var label = Label.new()
		label.text = text
		container.add_child(label)
