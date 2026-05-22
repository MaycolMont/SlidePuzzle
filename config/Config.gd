extends Node
## Central constants and debug configuration for the project.

func _ready() -> void:
	load_settings()

#region PATHS
## Directory containing source image files for the puzzle.
const IMAGES_PATH: String = "res://assets/sprites/images/"
## Resource file defining the ButtonGroup for image selection.
const IMAGE_GROUP_PATH: String = "res://UI/images_group.tres"
## Main gameplay scene.
const GAME_SCENE_PATH: String = "res://scenes/game.tscn"
## Main menu scene.
const MENU_SCENE_PATH: String = "res://scenes/main.tscn"
## Debug configuration script (loaded only when [member DEBUG_MODE] is true).
const DEBUG_FILE_PATH: String = "res://config/DebugConfig.gd"
#endregion

#region Settings
## Background music volume (0-100), persisted across sessions.
var master_volume: float = 75.0
## Sound effects volume (0-100), persisted across sessions.
var vfx_volume: float = 90.0
#endregion

#region Debug Settings
## When true, loads [DebugConfig] and skips the menu for faster iteration.
const DEBUG_MODE: bool = true

## Reference to the [DebugConfig] script, preloaded only if [member DEBUG_MODE] is true.
var DebugConfig: Variant = preload(DEBUG_FILE_PATH) if DEBUG_MODE else null
#endregion

#region Save / Load Settings
## Path for the persistent save file (game times).
const SAVE_FILE_PATH: String = "user://save_game.dat"
## Path for the persistent settings file (volume, etc.).
const SETTINGS_FILE_PATH: String = "user://settings.cfg"

## Loads settings from disk and applies audio volume.
func load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SETTINGS_FILE_PATH) == OK:
		master_volume = config.get_value("audio", "master_volume", 75.0)
		vfx_volume = config.get_value("audio", "vfx_volume", 90.0)
	var bus_idx: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(master_volume / 100.0))

## Saves current settings to disk.
func save_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "vfx_volume", vfx_volume)
	config.save(SETTINGS_FILE_PATH)
#endregion
