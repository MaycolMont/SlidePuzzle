extends Node
## Global autoload (singleton) for persistent game state.
## Holds the selected texture, grid size, and save/load logic for top 5 times
## per grid size.

## Whether this is a fresh game launch (no data loaded yet).
var new_game: bool = true
## The texture (image) selected by the player for the puzzle.
var texture_resource: Texture2D
## The grid size selected (e.g. 3 for 3x3).
var grid_size: int
## Filesystem path for the save file.
var save_path: String = Config.SAVE_FILE_PATH
## Loaded save data: grid_size -> Array[float] (up to 5 times, sorted ascending).
var game_data: Dictionary = {}

## Loads default debug texture and grid size when skipping the menu (DEBUG_MODE).
func _simulate_test_data() -> void:
	texture_resource = load(Config.DebugConfig.IMAGE_PATH_DEFAULT)
	grid_size = Config.DebugConfig.GRID_SIZE_DEFAULT

## Records a completion time for the current [member grid_size].
## Keeps only the top 5 fastest times, then persists to disk.
func save_time(time: float) -> void:
	if game_data.has(grid_size):
		game_data[grid_size].append(time)
		game_data[grid_size].sort()
	else:
		game_data[grid_size] = [time]

	if len(game_data[grid_size]) > 5:
		game_data[grid_size].pop_back()

	save_data()

## Writes [member game_data] to the save file via [FileAccess].
func save_data() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file.close()
	print_debug('Time saved: ', game_data)

## Reads [member game_data] from the save file if it exists.
func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)

		game_data = save_file.get_var()
		save_file.close()
		print_debug('Data loaded: ', game_data)
