extends TabContainer
## Displays saved best times grouped by grid size.
## Each tab corresponds to a grid size and shows up to 5 recorded times.

func _ready() -> void:
	Global.load_data()
	add_times()

## Populates each tab with saved times from [member Global.game_data].
func add_times() -> void:
	var tabs: Array[Node] = get_children()
	var times: Dictionary = Global.game_data
	for tab: Node in tabs:
		var grid_size: int = int(str(tab.name)[0])
		var container: VBoxContainer = tab.get_child(0)
		if times.has(grid_size):
			var tab_times: Array = times[grid_size]
			_add_labels(tab_times, container)

## Creates [Label] nodes for each time and adds them to the given container.
func _add_labels(times: Array, container: VBoxContainer) -> void:
	for time: Variant in times:
		var label: Label = Label.new()
		label.text = Utils.get_format_time(time)
		container.add_child(label)
