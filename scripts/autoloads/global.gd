extends Node

var new_game = true
var texture_resource : Texture2D
var grid_size : int
var save_path : String = Config.SAVE_FILE_PATH
var game_data : Dictionary = {}

func _simulate_test_data():
	texture_resource = load(Config.DebugConfig.IMAGE_PATH_DEFAULT)
	grid_size = Config.DebugConfig.GRID_SIZE_DEFAULT

func save_time(time: float):
	if game_data.has(grid_size):
		game_data[grid_size].append(time)
		game_data[grid_size].sort()
	else:
		game_data[grid_size] = [time]
		
	if len(game_data[grid_size]) > 5:
		game_data[grid_size].pop_back()

	save_data()

func save_data():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file.close()
	print_debug('Time saved: ', game_data)

func load_data():
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)

		game_data = save_file.get_var()
		save_file.close()
		print_debug('Data loaded: ', game_data)
